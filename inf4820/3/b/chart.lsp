;;; Hey, emacs, this file is -*- Mode: common-lisp; -*- ... got that?
(in-package :common-lisp-user)

;; TODO
;; grammar definitions and training functions
;(start 'start)
(defstruct grammar
	(start 'start)
	(rules (make-hash-table :test #'equalp))
	(lexemes (make-hash-table :test #'equal)))

;;; Lexeme structure. Holds a slot for its category and
;;; and its probability. 
(defstruct
	(lexeme
		(:constructor make-lexeme
			(cat &aux
				(category cat))))
	category
	(probability 1))

;;; Syntactic rule structure. Holds a slot for the left and right hand side
;;; of the rule, and for its probability.
(defstruct
	(rule
		(:constructor make-rule
			(left right &aux
				(lhs left)
				(rhs right))))
	lhs
	rhs
	(probability 1))

;;;
;;; Usage:	? (lexeme-p '("to"))
;;;					> T
;;;					? (lexeme-p '(VBD NP PP))
;;;					> nil
(defun lexeme-p (rhs)
	"Check if a rule is a lexeme."
	(if (stringp (car rhs))
		t
		nil))
		
;;;
;;; Usage:	? (unary-rec-p '(VP (VBD NP PP)))
;;;					> NIL
;;;					? (unary-rec-p '(VP (NP)))
;;;					> NIL
;;;					? (unary-rec-p '(NP (NP)))
;;;					> T			
;;;
(defun unary-rec-p (lhs rhs)
	(if (eql 1 (length rhs))
		(if (equal lhs (car rhs))
			t
			nil)
		nil))

;;;
;;; Usage:	? (get-sides '(S (NP (NNP "Frodo")) (NP (NNP "Sam"))))
;;;					> (S (NP NP))
;;;
(defun get-sides (list)
	"Return a list whose first and second element is the
	lhs and rhs of the 'top' rule the input 'list' represents."
	(let* ((lhs (car list))
				rhs
				(sides (list lhs)))
		(loop for i from 1 to (- (length list) 1) do
			(if (listp (nth i list))
				(setf rhs (append rhs (list (car (nth i list)))))
				(setf rhs (append rhs (list (nth i list))))))			
		(setf sides (append sides (list rhs)))
		sides))

;;;
;;; Usage:	? (add-lexeme 'NNP '("Frodo") grammar)
;;;					> 1
;;;					? (add-lexeme 'NNP '("Frodo") grammar)
;;;					> 2
;;;
(defun add-lexeme (lhs rhs grammar)
	"Add a lexeme to the grammar."
	(let* ((lexemes (grammar-lexemes grammar))
				 (lexeme (make-lexeme lhs))
				 (word (car rhs)))
		(if (not (gethash word lexemes))
			(setf (gethash word lexemes) (make-hash-table :test #'equalp)))
		(incf (gethash lexeme (gethash word lexemes) 0))))

;;;
;;; Usage:	? (add-rule 'VP '(VBD NP NN) grammar)
;;;					> 1
;;;					? (add-rule 'VP '(VBD NP NN) grammar)
;;;					> 2
;;;
(defun add-rule (lhs rhs grammar)
	"Add a syntactic rule to the grammar."
	(let ((rules (grammar-rules grammar))
				(rule (make-rule lhs rhs)))
		(if (not (unary-rec-p lhs rhs))
			(incf (gethash rule rules 0)))))

;;;
;;; Usage:	? (add-rule-or-lexeme 'VP '(VBD NP NN) grammar)
;;;					> 1
;;;					? (add-rule-or-lexeme 'NNP '("Frodo") grammar)
;;;					> 1
;;;
(defun add-rule-or-lexeme (lhs rhs grammar)
	"Add a syntactic rule or a lexeme to the grammar,
	depending on a lexeme-p check."
	(if (lexeme-p rhs)
		(add-lexeme lhs rhs grammar)
		(add-rule lhs rhs grammar)))

;;;
;;; Usage:	? tree
;;;					> (S (NP (NNP "Frodo"))
;;;						 (VP (VBD "gave") (NP (DT "the") (NN "ring")) (PP (P "to") (NP (NNP "Sam")))))
;;;					? (parse-tree tree grammar)
;;;					> NIL
;;;					? grammar
;;;					> #S(GRAMMAR :RULES #<HASH-TABLE :TEST EQUALP size 5/31 #x2100CC6EDD>
;;;											 :LEXEMES #<HASH-TABLE :TEST EQUAL size 6/60 #x2100CC68ED>)
;;;
(defun parse-tree (tree grammar start)
	"Parse a single tree recursively and add rules or lexemes as
	appropriate."
	(when tree
		(let* ((sides (get-sides tree))
					 (lhs (car sides))
					 (rhs (car (cdr sides))))
			(if start
				(add-rule 'START (list lhs) grammar))
			(add-rule-or-lexeme lhs rhs grammar))					
			
		; Recursion
		(if (listp tree)
			(loop for i from 1 to (- (length tree) 1) do
				(if (listp (nth i tree))
					(parse-tree (nth i tree) grammar nil))))))

;;;
;;; Usage:	? (defparameter toy (read-grammar "toy.mrg"))
;;;					> TOY
;;;					? (count-lhs 'S grammar)
;;;					> 11					
;;;					
(defun count-lhs (lhs grammar)
	"Count the number of times 'lhs' appears as the lhs
	of syntactic/lexical rules."
	(let ((count 0)
				(rules (grammar-rules grammar))
				(lexemes (grammar-lexemes grammar)))
		(loop for rule being the hash-key of rules using (hash-value val) do
			(if (equal lhs (rule-lhs rule))
				(incf count val)))
		(loop for word-lexemes being the hash-value of lexemes do
			(loop for lexeme being the hash-key of word-lexemes using (hash-value val) do
				(if (equal lhs (lexeme-category lexeme))
					(incf count val))))
		count))		
					
(defun calculate-probabilities (grammar)
	"Calculate the probabilities of 'grammar's rules
	and lexemes."
	(let ((rules (grammar-rules grammar))
				(lexemes (grammar-lexemes grammar)))
		
		; Calculate syntactic rules probabilities
		(loop for rule being the hash-key of rules do
			(calculate-rule-probability grammar rule))
		
		; Calculate lexeme probabilities
		(loop for word-lexemes being the hash-value of lexemes do
			(loop for lexeme being the hash-key of word-lexemes using (hash-value count) do
				(let* ((lhs-count (count-lhs (lexeme-category lexeme) grammar))
							(prob (/ count lhs-count)))
					(setf (lexeme-probability lexeme) (log prob)))))))

					
(defun calculate-rule-probability (grammar rule)
	"Calculate the probability of a single rule."
	; Calculate a rule's (log) probability
	(let* ((rule-count (gethash rule (grammar-rules grammar)))
				 (lhs-count (count-lhs (rule-lhs rule) grammar))
				 (prob (/ rule-count lhs-count)))
		(setf (rule-probability rule) (log prob))))
		
				
(defun read-grammar (file)
	"Construct a grammar based on the contents of
	'file'."
	(let ((grammar (make-grammar)))
		(with-open-file (stream file :direction :input)
			(loop for tree = (read stream nil)
			while tree collect tree into trees
			finally
				(progn
					(loop for tree in trees do
						(parse-tree tree grammar t))
					(calculate-probabilities grammar))))
		grammar))

;; you may choose to filter which rules get added to your grammar by adjusting
;; this threshold
(defparameter *rule-frequency-threshold* 0)

;;;
;;; Usage:	? (rules-starting-in 'NP toy)
;;;					> (#S(RULE :LHS START :RHS (NP) :PROBABILITY -1.5404451)
;;;						 #S(RULE :LHS S :RHS (NP VP) :PROBABILITY 0.0))
;;;
(defun rules-starting-in (category grammar)
	"Return a list containing all grammar rules with 'category'
	as the first thing on the right hand side."
	(let ((result nil)
				(rules (grammar-rules grammar)))
		(loop for rule being the hash-key of rules do
			(if (equal category (car (rule-rhs rule)))
				(setf result (append result (list rule)))))
		result))

;;;
;;; Usage:	? (get-lexemes "flies" toy)
;;;					> (#S(LEXEME :CATEGORY NNS :PROBABILITY -2.0794415)
;;;						 #S(LEXEME :CATEGORY VBZ :PROBABILITY -1.9459101))
;;;
(defun get-lexemes (word grammar)
	"Return a list containing all lexemes relevant for
	'word' in 'grammar'."
	(let ((lexemes (gethash word (grammar-lexemes grammar)))
				(result nil))
		(loop for lexeme being the hash-key of lexemes do
			(setf result (append result (list lexeme))))
		result))
		
	




;; In Part 2, we have provided most of the code, only requiring you to complete
;; one function: fundamental-rule(). Read through
;; the rest of the code and make sure you understand how it implements the
;; chart parser we discussed in lectures.


;; Our chart parser and associated structures and functions

;;; The parse chart we use is a two-dimensional array indexed by string 
;;; positions. We use the second dimension to indicate whether we are indexing 
;;; by start or end positions, and whether the edge is passive or active ie:
;;;   chart[i,0] is for passive edges starting at i,
;;;   chart[i,1] is for passive edges ending at i,
;;;   chart[i,2] is for active edges starting at i; and
;;;   chart[i,3] is for active edges ending at i

;; Given a start and end vertex (i.e. sub-string from and to indices),
;; retrieve the relevant chart edges (defaulting to passive edges only)
(defun chart-cell (from to chart &optional activep)
  (loop
      for edge in (append
                   (aref chart from 0) (and activep (aref chart from 2)))
      when (= (edge-to edge) to) collect edge))

;; For a given chart vertex (aka string from position), retrieve all the
;; passive edges from the chart that start at that vertex
(defun passive-edges-from (index chart)
  (aref chart index 0))

;; For a given chart vertex (aka string to position), retrieve all the
;; active edges from the chart that end at that vertex
(defun active-edges-to (index chart)
  (aref chart index 3))

;; Given the way we have organized our chart, inserting a new edge requires
;; adding it by both its from and to positions in two `rows' of our
;; chart implementation.
(defun chart-adjoin (edge chart)
  (let ((offset (if (passive-edge-p edge) 0 2)))
    (push edge (aref chart (edge-from edge) (+ offset 0)))
    (push edge (aref chart (edge-to edge) (+ offset 1)))))

;; The edges record their span and category, the daughters they have 
;; seen (daughters) and the daughters they still require (unanalyzed).
;; The alternates slot holds other edges with the same span and category.
;; During forest construction, probability holds the (log) probability of the
;; associated rule. The viterbi function updates this to be the maximum
;; probability of the subtree this edge represents.
;; The cache slot is used in viterbi() to avoid recalculations.
(defstruct edge
  from to category 
  daughters unanalyzed
  alternates 
  probability 
  cache)

;; Expands the edge to a tree, using daughters (ignoring alternates)
(defun edge-to-tree (edge)
  (if (edge-daughters edge)
      (cons (edge-category edge)
	    (loop
		for daughter in (edge-daughters edge)
		collect (edge-to-tree daughter)))
    (edge-category edge)))

;; Passive edges have seen all their daughters
(defun passive-edge-p (edge)
  (null (edge-unanalyzed edge)))

;;; Our agenda, here just a simple stack, but that could be changed to
;;; implement another agenda strategy
(defstruct agenda
  (contents nil)
  (popped nil))

(defun agenda-push (edge agenda)
  (push edge (agenda-contents agenda)))

(defun agenda-pop (agenda)
  (setf (agenda-popped agenda) (pop (agenda-contents agenda))))

;;; Finally, the actual chart parser
(defun parse (input grammar)
  (let* ((agenda (make-agenda))
	 (n (length input))
	 (chart (make-array (list (+ n 1) 4) :initial-element nil)))
    
    ;; Create a `lexical' edge (one without daughters that is passive from the
    ;; start) for each word of the input sequence.
    ;; Then add passive edges for each possible word category to the agenda.
    (loop
	for i from 0
	for word in input
	for lexemes = (get-lexemes word grammar)
	for daughters = (list (make-edge :from i :to (+ i 1) :category word
					 :probability 0.0))
	do
	  ;; If we haven't seen all the words in training, fail immediately.
	  ;; Don't waste time filling a chart that will never complete.
	  (if (null lexemes) 
	      (return-from parse nil) 
	    (loop 
		for lexeme in (get-lexemes word grammar) 
		for edge = (make-edge :from i :to (+ i 1) 
				      :category (lexeme-category lexeme) 
				      :daughters daughters 
				      :probability (lexeme-probability lexeme)) 
		do (agenda-push edge agenda))))
    
    ;; main parser loop
    (loop
	for edge = (agenda-pop agenda)
	while edge do 
	  (cond 
	   ;; A passive edge we first try and pack into an existing edge in the
	   ;; chart. If there are no compatible edges in the chart yet, add this
	   ;; edge, apply the fundamental rule, then predict new edges and add 
	   ;; them to the agenda also.
	   ((passive-edge-p edge)
	    (unless (pack-edge edge chart) 
	      (chart-adjoin edge chart)
	      (loop
		  for active in (active-edges-to (edge-from edge) chart)
		  do (fundamental-rule active edge agenda)) 
	      (loop
		  with from = (edge-from edge) with to = (edge-to edge)
		  for rule in (rules-starting-in (edge-category edge) grammar)
		  for new = (make-edge :from from :to to
				       :category (rule-lhs rule)
				       :daughters (list edge)
				       :unanalyzed (rest (rule-rhs rule))
				       :probability (rule-probability rule))
		  do (agenda-push new agenda))))
	   ;; An active edge doesn't get packed and doesn't predict new edges.
	   ;; Just add the edge to the chart and apply the fundamental rule.
           (t 
	    (chart-adjoin edge chart) 
	    (loop 
		for passive in (passive-edges-from (edge-to edge) chart) 
		do (fundamental-rule edge passive agenda)))))
    
    ;; agenda is now empty, check for a passive edge that spans the input and 
    ;; has a category equal to our start symbol
    (loop
	for edge in (chart-cell 0 (length input) chart)
	when (eq (edge-category edge) (grammar-start grammar))
	return edge)))

;; TODO
;; The fundamental rule of chart parsing: given one active and one
;; passive edge (known to be adjacent already), check for compatibility of
;; the two edges and add a new edge to the agenda when successful.
(defun fundamental-rule (active passive agenda)
)

;; A recursive implementation of the Viterbi algorithm
(defun viterbi (edge)
  (or (edge-cache edge)
      (setf (edge-cache edge)
	(if (edge-daughters edge)
	    (loop
		initially
		  (setf (edge-probability edge)
		    (+ (edge-probability edge)
		       (loop
			   for daughter in (edge-daughters edge)
			   sum (edge-probability (viterbi daughter)))))
		for alternate in (edge-alternates edge)
		for probability = (edge-probability (viterbi alternate))
		when (> probability (edge-probability edge))
		do
		  (setf (edge-probability edge) probability)
		  (setf (edge-daughters edge) (edge-daughters alternate))
		finally (return edge))
	  edge))))

;; If there is more than one way to create a particular category for a
;; particular span, pack all alternatives into the first such edge we added.
(defun pack-edge (edge chart)
  ;; Should only be called on passive edges, but we check.
  (when (passive-edge-p edge)
    (loop
      ;; Look for a passive edge with same span and category. There will be 
      ;; at most one.
	for host in (passive-edges-from (edge-from edge) chart)
	when (and (= (edge-to host) (edge-to edge))
		  (equal (edge-category host) (edge-category edge)))
	do
	  ;; If we find one, add the new edge to our host, unless that would
	  ;; create a cycle, in which case, discard our new edge. Return the
	  ;; host, indicating no more processing is necessary on this edge.
	  (unless (daughterp host edge)
	    (push edge (edge-alternates host)))
	  (return host))))

;; Tests whether host is (transitively) embedded as a daughter below edge.
(defun daughterp (host edge)
  (loop
      for daughter in (edge-daughters edge)
      thereis (or (eq daughter host) (daughterp host daughter))))

;; Reads test file, extracting gold trees and using their leaves as input to
;; our parser, for any sentence <= 20 (for efficiency). Uses parseval to compare
;; between the tree from the parser and the gold tree, after first stripping our
;; dummy start node
(defun pcfg-eval (file grammar &key baseline (maxlength 10))
  (with-open-file (stream file)
    (loop
	with inputs = 0 with analyses = 0
	with tcorrect = 0 with tfound = 0 with tgold = 0
	for gold = (read stream nil nil)
	while gold do
	  (let* ((leaves (leaves gold))
		 (n (length leaves)))
	    (when (<= n maxlength)
	      (incf inputs)
	      (let* ((start (get-internal-run-time))
		     (parse (parse leaves grammar))
		     (end (get-internal-run-time))
		     (tree (when parse
			     (edge-to-tree (if baseline parse (viterbi parse)))))
		     ;; remove our dummy start node before eval
		     (tree (when (consp tree) (first (rest tree)))))
		(multiple-value-bind (correct found gold) (parseval tree gold)
		  (format
		   t "~a. [~a] |~{~a~^ ~}| (~,2fs) P=~,2f R=~,2f~%"
		   inputs n leaves 
		   (/ (- end start) internal-time-units-per-second)
		   (if (zerop found) 0 (/ correct found)) (/ correct gold))
		  (when parse
		    (incf analyses)
		    (incf tcorrect correct)
		    (incf tfound found))
		  (incf tgold gold)))))
	finally
	  (let* ((precision (if (zerop tfound) 1 (/ tcorrect tfound)))
		 (recall (/ tcorrect tgold))
		 (fscore (/ (* 2 precision recall) (+ precision recall))))
	    (format
	     t "== ~a input~p; ~,2f% coverage; P=~,2f R=~,2f F1=~,2f~%"
	     inputs inputs (/ analyses inputs) precision recall fscore)
	    (return (float fscore))))))

;;; ParsEval compares trees by extracting all constituents (identified by start
;;; and end positions, and category) from each tree and counting the overlap
;;; (correct) as well as the total constituents in each tree.
(defun parseval (tree gold)
  (let* ((tree (and tree (explode tree)))
	 (gold (and gold (explode gold)))
	 (correct (intersection tree gold :test #'equal)))
    (values (length correct) (length tree) (length gold))))

(defun leaves (tree)
  (if (consp tree) 
      (loop for daughter in (rest tree) append (leaves daughter)) 
    (list tree)))

(defun explode (tree &optional (from 0))
  (if (and (null (rest (rest tree))) (atom (first (rest tree))))
      (list (list from (+ from 1) (first tree)))
    (let* ((to from)
	   (daughters
	    (loop
		for daughter in (rest tree)
		for bracketings = (explode daughter to)
		do (setf to (second (first bracketings)))
		append bracketings)))
      (cons (list from to (first tree)) daughters))))

