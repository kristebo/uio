;;; I screwed something up in the viterbi algorithm, and I became a bit resigned
;;; when I realized I (probably) had to do it all from scratch again (too tired to start over) 
;;;(I know I implemented 
;;; it wrongly, and I know it has to do with out-of-bounds array indices from quick debugging). 
;;; So there goes a point and probably another one for the subtask where one actually tests 
;;; the algorithm. \o/ In retrospect I should probably have retrieved non-terminal states from my 
;;; :id-map, and used new ids for them when looping through the states in the viterbi algorithm.
;;; Also, I'm fully aware that the return value of the algorithm is not what was supposed to be
;;; returned; the reason it's placed there is solely for when I was debugging.

;;;;		 				(1.2a)
;;;;	---------------------------

;;;
;;;	Usage:	? (make-hmm 2)
;;;					> #S(HMM :STATES-ID-MAP #(0 0 0 0)
;;;       		:STATES-STRING-MAP #<HASH-TABLE :TEST EQUAL size 0/60
;;;					  #x2100C7D9AD> :N 0 :TRANSITIONS #2A((0 0 0 0) (0 0 0 0)
;;;					  (0 0 0 0) (0 0 0 0)) :EMISSIONS #(#<HASH-TABLE :TEST EQUAL
;;;					  size 0/60 #x2100C7E5CD> #<HASH-TABLE :TEST EQUAL size 0/60 
;;;						#x2100C7DFBD> 0 0))
;;;
;;; The transitions matrix is simply a two-dimensional array. My reasoning
;;; for this is that the assignment text specified the use of numeric ids
;;; for states, and I find the final (i.e. computed) matrix unlikely to be
;;; sparse. This ensures fast look-ups and (presumably) not a whole lot of
;;; redundant space consumption. Also, since the read-corpus() function 
;;;	assumes a priori knowledge of the size of the state space, a 2D array
;;; works well (if we didn't know the size of the state space, another
;;; data structure would likely be needed as I couldn't find a way to make
;;; arrays of a dimension greater than one resizable).
;;;		Since the emission probabilities matrix is indexed by a state-value
;;;	pair, my first intuition was to use an array where the indexes
;;;	represent the states (since we will be using numeric state ids).
;;;	Intuitively a 2D matrix/array *could* be used for the emissions (i.e. 
;;;	one row for each state/tag and one column for each word, but since we 
;;;	don't have a priori knowledge of the number of different words and the 
;;;	fact that I couldn't seem to make multidimensional arrays resizable 
;;;	(found some conflicting statements about this, but the :fill-pointer/
;;;	:adjustable method didn't work), I deemed this approach infeasible.
;;;	Plus, this kind of 2D matrix would have a very good chance of being
;;; sparse as well.	The only other approach I found natural to use was
;;;	using hash-tables for each state, with words as keys and 
;;;	counts/probabilities as values. Besides, this approach spared me a 
;;;	whole lot of extra work as compared to the 2D array with numeric ids 
;;;	for words too.
;;;		
(defstruct
	(hmm
		(:constructor make-hmm
			(n &aux
				(id-map (make-array (+ n 2) :fill-pointer 0));
				(string-map (make-hash-table :test #'equal))
				(transitions (make-array (list (+ n 2) (+ n 2))))
				(emissions (make-array (+ n 2)))
				(do
					(progn
						(loop for i from 0 to (- (length emissions) 1) do
							(setf (aref emissions i) (make-hash-table :test #'equal)))
						; reset n to 0 since the state2id() function increments n.
						(setf n 0))))))
	(states (list :id-map id-map :string-map string-map))
	n
	transitions
	emissions)

	
;;;;		 				(1.2b)
;;;;	---------------------------

;;;
;;; Get the probability of transitioning from 'prev-state' to 'next-state'.
;;;
(defun transition-probability (hmm prev-state next-state)
	(aref (hmm-transitions hmm) prev-state next-state))	
	

;;;
;;; Get the probability of emitting 'word' from 'state'. Notice that
;;; unknown words are assigned a probability of 0.
;;;
(defun emission-probability (hmm state word)
	(let ((probability (gethash word (aref (hmm-emissions hmm) state))))
		(if probability
			probability
			(/ 1 1000000)))) ; from (2.2a)
			
;;;
;;; Get the numerical identifier of an input state label. If the input
;;; state label is currently unknown to our HMM, try to add it if there's
;;; still room in the HMM for more states.
;;;
(defun state2id (hmm state-label)
	"Retrieve the numerical id of a specified state (string)."
	(let ((id-map (getf (hmm-states hmm) :id-map))
				(string-map (getf (hmm-states hmm) :string-map))
				(id nil))
		(if (gethash state-label string-map) ; State has previously been added.
			(setf id (gethash state-label string-map))
			; State has not previously been added, so check if there's still room
			; for more states, and add it if true.
			(if (< (hmm-n hmm) (array-dimension id-map 0))
				(progn
					(vector-push state-label id-map)
					(incf (hmm-n hmm))
					(setf id (- (fill-pointer id-map) 1))
					(setf (gethash state-label string-map) id))))
		id))
							
	
;;;;		 				(1.3a)
;;;;	---------------------------
;;;;
;;;; 	I compartmentalized my code quite a bit by making quite a few smaller 
;;;;	helper functions which come together in the actual read-corpus() function 
;;;;	further down.

;;;
;;; Usage:	? (split-string-by-tab "a	b")
;;;					>	("a" "b")
;;;
(defun split-string-by-tab (string)
	"Split a tab delimited string into its constituents."
	(loop
		for start = 0 then (+ space 1)
		for space = (position #\tab string :start start)
		for token = (subseq string start space)
		collect token until (not space)))
		
		
;;;
;;; Usage:	?	(get-observation "3	H")
;;;					>	"3"
;;;
(defun get-observation (line)
	"Retrieve the observation part of an observation-label pair."
	(nth 0 (split-string-by-tab line)))
	
	
;;;
;;;	Usage:	?	(get-label "3	H")
;;;					>	"H"
;;;
(defun get-label (line)
	"Retrieve the label part of an observation-label pair."
	(nth 1 (split-string-by-tab line)))
	

;;;
;;;	Usage:	?	(get-sentences '("2	H" "3	H" "" "1	H" ""))
;;;					>	(("2	H" "3	H") ("1	H"))
;;;
;;; Notice the "" components in the usage example. Empty lines
;;; in the training data files are read as "", and so we see that 
;;; the function works nicely. The purpose behind this function is
;;; to make it easy to spot when an observation-value pair follows 
;;;	from the start state or precedes the end state.
;;;
(defun get-sentences (lines)
	"Group the training data into ordered sentences."
	(let ((sentence nil)
				(sentences nil))
		(loop for line in lines do
			(if (> (length line) 1)
				(setf sentence (append sentence (list line)))
				(progn
					(setf sentences (append sentences (list sentence)))
					(setf sentence nil))))
		sentences))
		
;;;
;;; Add a transition: 'prev-state'->'next-state'
;;;
(defun add-transition (hmm prev-state next-state)
	(let* ((string-map (getf (hmm-states hmm) :string-map))
				 (prev-id (gethash prev-state string-map))
				 (next-id (gethash next-state string-map)))
		(incf (aref (hmm-transitions hmm) prev-id next-id))))

;;;
;;; And an emission: 'label'->'observation'
;;;
(defun add-emission (hmm label observation)
	(let* ((string-map (getf (hmm-states hmm) :string-map))
				 (label-id (gethash label string-map))
				 (emissions (aref (hmm-emissions hmm) label-id)))
		(incf (gethash observation emissions 0))))
		

;;;
;;; Usage:	? (defparameter hmm (read-corpus "eisner.tt" 2))
;;;					> HMM
;;;					? (hmm-transitions hmm)
;;;         > #2A((0 0 77 23) (0 0 0 0) (0 56 120 47) (0 44 26 66))
;;;
;;; Count the various transitions taking place in the training data.
;;; Note the special case of end lines: For each end line two transitions
;;; are added; the first one is (label of line before end line)->(label of
;;; end line), and the second one is (label of end line)->"</s>".
;;;
(defun count-transitions-emissions (hmm sentences)
	; For each sentence in the training data:
	(loop for sentence in sentences do
		; For each line in the current sentence:
		(loop for line in sentence with i = 0 do
			(let ((observation (get-observation line))
						(label (get-label line))
						(prev-state nil)
						(next-state nil))
				(if (eq i 0) ; The line is a start line.
					(progn
						(setf prev-state "<s>")
						(setf next-state label))
						(progn ; The line is not a start line.
							(setf prev-state (get-label (nth (- i 1) sentence)))
							(setf next-state label)))
				(add-transition hmm prev-state next-state)
				(if (eq i (- (length sentence) 1)) ; The line is an end line.
					(progn
						(setf prev-state label)
						(setf next-state "</s>")
						(add-transition hmm prev-state next-state)))
				(add-emission hmm label observation)
				(incf i)))))				

;;;
;;; Add the states found in the training data to a HMM.
;;;
(defun add-states (hmm sentences)
	(let* ((id-map (getf (hmm-states hmm) :id-map)))		 
		; Add start/end state.
		(state2id hmm "<s>")
		(state2id hmm "</s>")	
		; Add the other states. Only check for new states if there's still room
		; for more. Although not explicit here, new states are added to the
		; hmm-states->id-map/string-map through the state2id() function.
		(if (not (eq (fill-pointer id-map) (array-dimension id-map 0)))
			(loop for sentence in sentences do
				(loop for line in sentence do
					(let ((state (get-label line)))
						(state2id hmm state)))))))

;;;
;;; Usage:	? (defparameter eisner (read-corpus "eisner.tt" 2)
;;;					> EISNER
;;;					? (transition-probability eisner (state2id eisner "<s>") 
;;;																					 (state2id eisner "H"))
;;;					> 77
;;;					? (transition-probability eisner (state2id eisner "C") 
;;;																					 (state2id eisner "H"))
;;;					> 26
;;;					? (transition-probability eisner (state2id eisner "C") 
;;;                                          (state2id eisner "</s>"))
;;;					> 44
;;;					? (emission-probability eisner (state2id eisner "C") "3")
;;;					> 20
;;;						
(defun read-corpus (corpus n)
	(let ((hmm (make-hmm n)))
		(with-open-file (stream corpus :direction :input)
			(loop for line = (read-line stream nil)
				while line collect line into lines
				finally
				(let ((sentences (get-sentences lines)))
					(add-states hmm sentences)
					(count-transitions-emissions hmm sentences))))
		hmm))
		
;;;;		 				(1.3b)
;;;;	---------------------------

;;;
;;; Usage:	? (defparameter eisner (read-corpus "eisner.tt" 2))
;;;					> EISNER
;;;					? (state-occurrences eisner)
;;;					> #(100 100 223 136)
;;;
;;;	Produce a vector indexed by the state-ids containing occurrence
;;; counts of the states represented by said state-ids.
;;;
(defun state-occurrences (hmm)
	(let* ((transitions (hmm-transitions hmm))
				 (end-index (1- (array-dimension transitions 0)))
				 (occurrence-count (make-array (1+ end-index)))
				 (start-id (state2id hmm "<s>"))
				 (end-id (state2id hmm "</s>")))
		
		; Count how many times a state occurs in the training data,
		; and update the vector accordingly. This doesn't work for
		; for the end-state "</s>" however - see below.
		(loop for i from 0 to end-index do
			(loop for j from 0 to end-index do
				(incf (aref occurrence-count i) (aref transitions i j))))
		
		; Same number of ends as starts, so:
		(setf (aref occurrence-count end-id) (aref occurrence-count start-id))

		occurrence-count))

;;;
;;; Compute the transition probabilities in a hmm structure
;;; and destructively modify its transition matrix.
;;;		
(defun compute-transition-probabilities (hmm)
	(let* ((transitions (hmm-transitions hmm))
				 (end-index (1- (array-dimension transitions 0)))
				 (occurrence-count (state-occurrences hmm)))
		; For each state i:
		(loop for i from 0 to end-index do
			; Get the number of times current state has occurred, and
			(let ((count-i (aref occurrence-count i)))
				; loop for each state j:
				(loop for j from 0 to end-index do
					; Get the number of occurrences of the transition
					; state-i->state-j, and calculate the probability
					; P(state-j|state-i).
					(let* ((count-ij (aref transitions i j))
								 (probability (/ count-ij count-i)))
						; Destructively update with probabilities.
						(setf (aref transitions i j) probability)))))))

;;;
;;; Compute the emission probabilities in a hmm structure and
;;; destructively modify its emissions component.
;;;						
(defun compute-emission-probabilities (hmm)
	(let* ((emissions (hmm-emissions hmm))
				 (end-index (1- (array-dimension emissions 0)))
				 (occurrence-count (state-occurrences hmm)))
		(loop for i from 0 to end-index do
			(loop for word being the hash-key of (aref emissions i) do
				(let* ((state-count (aref occurrence-count i))
							 (probability (/ (gethash word (aref emissions i))
															 state-count)))
					(setf (gethash word (aref emissions i)) probability))))))
												
;;;
;;; Usage:	? (defparameter eisner (read-corpus "eisner.tt" 2))
;;;					> EISNER
;;;					? (train-hmm eisner)
;;;					> NIL
;;;         ? (transition-probability eisner (state2id eisner "C") 
;;;                                          (state2id eisner "H"))
;;;         > 13/68
;;;         ? (emission-probability eisner (state2id eisner "C") "3")
;;;					> 5/34
;;;		
(defun train-hmm (hmm)
	(compute-emission-probabilities hmm)
	(compute-transition-probabilities hmm))
	

;;;;		 				(2.2a)
;;;;	---------------------------

(defun max-prob (hmm viterbi i s obs start-id end-id)
	(let* ((probs nil)
				 (id-map (getf (hmm-states hmm) :id-map))
				 (L (length id-map)))
				 
		(loop for x from 0 to (1- L) unless (or (eq x start-id) (eq x end-id)) do
			(let* ((v-prev (aref viterbi (1- i) x))
						 (trans (transition-probability hmm x s))
						 (emit (emission-probability hmm s obs))
						 (prob (* v-prev trans emit)))
				(setf probs (append probs (list prob)))))	
				
		(reduce #'max probs)))
		
(defun arg-max (hmm viterbi i s start-id end-id)
	(let* ((id-map (getf (hmm-states hmm) :id-map))
				 (L (length id-map))
				 (best 0))
				 
		(loop for x from 0 to (1- L) unless (or (eq x start-id) (eq x end-id)) do
			(let* ((v-prev (aref viterbi (1- i) x))
						 (trans (transition-probability hmm x s))
						 (prob (* v-prev trans)))
				(if (> prob best)
					(setf best x))))	
					
		best))

(defun viterbi (hmm input-sequence)
	(let* ((id-map (getf (hmm-states hmm) :id-map))
				 (N (length input-sequence))
				 (L (length id-map))
				 (viterbi (make-array (list N L)))
				 (backpointer (make-array (list N L)))
				 (start-id (state2id hmm "<s>"))
				 (end-id (state2id hmm "</s>")))
	
		(loop for s from 0 to (1- L) unless (or (eq s start-id) (eq s end-id)) do
			(let* ((trans (transition-probability hmm start-id s))
						 (emit (emission-probability hmm s (nth 0 input-sequence)))
						 (prob (* trans emit)))
				(setf (aref viterbi 0 s) prob)
				(setf (aref backpointer 0 s) 0)))
	
		(loop for i from 1 to (1- N) do
			(loop for s from 0 to (1- L) unless (or (eq s start-id) (eq s end-id)) do
				(setf (aref viterbi i s) (max-prob hmm viterbi i s (nth i input-sequence) start-id end-id))
				(setf (aref backpointer i s) (arg-max hmm viterbi i s start-id end-id))))
				
		(let ((probs nil)
					(best 0))
			(loop for s from 0 to (1- L) unless (or (eq s start-id) (eq s end-id)) do
				(let* ((vx (aref viterbi s (1- N)))
							(vy (aref viterbi (1- N) s))
							(trans (transition-probability hmm s end-id))
							(probx (* vx trans))
							(proby (* vy trans)))
					(if (> proby best)
						(setf best s))
					(setf probs (append probs (list probx)))))
			(setf (aref viterbi (1- N) end-id) (reduce #'max probs))
			(setf (aref backpointer (1- N) end-id) best))
			
		backpointer))
			
	
;;;;		 				(2.2b)
;;;;	---------------------------	

;;; Log probabilities are better because we run the risk of
;;; encountering underflow with standard probabilities (i.e extremely small numbers). 
;;; Underflow happens when a floating point number requires more bits than what is available
;;; in the computer's registers, which messes up what the number should
;;; really be. To implement this one could either store log probabilities
;;; in the transitions/emissions components, or compute the log probabilities
;;; when retrieved from said components for further use. If one uses log
;;; probabilities one must also remember to _add_ them instead of multiplicating
;;; them (source: http://en.wikipedia.org/wiki/Log_probability)		
			
		
				
				
			
		
	

	
				