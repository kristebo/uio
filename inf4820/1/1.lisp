;;;;
;;;; INF4820 - Algorithms for artificial intelligence and natural language processing
;;;;
;;;; Mandatory Assignment 1, Fall 2013
;;;; By Magnus Andersen (magnuand@ifi.uio.no)
;;;;
;;;; Comment: Typical usage is > ('task number'-'subtask number'). Read "Usage"-comments.
;;;;          
;;;;          If I try to load the file with (load "pathname.lisp") I get the
;;;;          following error msg: "Cannot read character U+0092 as part of a token 
;;;;          because it has constituent trait 'invalid'. Not sure what's up.
;;;;          If it doesn't work, just copy-paste the various functions
;;;;          into the REPL.
;;;;


;;;
;;; Task 1 - List processing
;;;

;;
;; (a)
;;
;; Comment: Select the element at index 2 in the specified list.
;;          In this case this gives the wanted output 'pear'.
;;
;; Usage: > (1-a)
;;        >> (pear)
;;
(defun 1-a ()
  (nth 2 '(apple orange pear lemon)))

;;
;; (b)
;;
;; Comment: Select the element at index 1 in the specified list,
;;          namely the second list containing 'pear' and 'lemon',
;;          and then the first element in said second list. This
;;          again gives the wanted output 'pear'.
;;
;; Usage: > (1-b)
;;        >> (pear)
;;
(defun 1-b ()
  (nth 0 (nth 1 '((apple orange) (pear lemon)))))

;;
;; (c)
;;
;; Comment: Select the element at index 2 in the specified list,
;;          namely the third list containing 'pear', and select
;;          the first (and only) element from that list, once
;;          again outputting the wanted output 'pear'.
;;
;; Usage: > (1-c)
;;        >> (pear)
;;
(defun 1-c ()
  (nth 0 (nth 2 '((apple) (orange) (pear)))))

;;
;; (d)-b
;;
;; Usage: > (1-d-b)
;;        >> ((apple orange) (pear lemon))
;;
(defun 1-d-b () 
  (let* ((A (cons 'orange nil))  ; A -> (orange)
         (B (cons 'apple A))     ; B -> (apple orange)
		 (C (cons 'lemon nil))   ; C -> (lemon)
		 (D (cons 'pear C))      ; D -> (pear lemon)
		 (E (cons D nil))        ; E -> ((pear lemon))
		 (F (cons B E)))         ; F -> ((apple orange) (pear lemon))
		                         ;   -> desired output
		  F))
								 
;;
;; (d)-c
;;
;; Usage: > (1-d-c)
;;        > ((apple) (orange) (pear))
;;
(defun 1-d-c ()
  (let* ((A (cons 'apple nil))  ; A -> (apple)
         (B (cons 'orange nil)) ; B -> (orange)
		 (C (cons 'pear nil))   ; C -> (pear)
		 (D (cons C nil))       ; D -> ((pear))
		 (E (cons B D))         ; E -> ((orange) (pear))
		 (F (cons A E)))        ; F -> ((apple) (orange) (pear))
		  F))                   ;   -> desired output
		  
;;
;; (e)
;;
;; Comment: The function takes a query and a list as input. 'query'
;;          is the element to search for, and 'lst' is the list through
;;          which to search.  The index/position of the last occurrence of 'query'
;;          in 'lst' is then stored in 'pst' is'. The element in 'lst' one index to the 
;;          left of 'pst is then retrieved. I hope I understood the task
;;          description correctly.
;;
;; Usage: >(1-e '*foo* '(a *foo* b c d *foo* g))
;;        >> d
;;        >(1-e '*foo* '(a *foo* b c d g h))
;;        >> a
;;        etc.
;;
(defun 1-e (query lst)
  (setf pst (position query lst :from-end 1))     ; get position of last occurrence of 'query'
  (if (null pst)                                  ; if 'query' isn't in 'lst', then
    "The specified character does not exist."     ; error msg
	(if (= pst 0)                                 ; otherwise: check if 'query' has a next-to-last element
	  "No next-to-last element."                  ; error msg if not
	  (nth (- pst 1) lst))))                      ; if it has, proceed
	

;;;
;;; Task 2 - Interpreting Common Lisp
;;;
;;; My answer: The purpose of the function (named 'foo') is to count the number of elements
;;;            in some list the function takes as argument. 'foo' is the input
;;;            list. It then checks if 'foo' is empty/nil, and if it is not it 
;;;            increments by 1 and runs the function again with the same list but 
;;;            with the first element removed (i.e. (+1 (foo (rest foo))). If it is empty,
;;;            it simply returns 0. In other words, it counts elements by recursion
;;;            until the list in the final recursive call is empty - which results
;;;            in termination.


;;;
;;; Task 3 - Variable assignment
;;;

;;
;; (a)
;;
;; Usage: > (3-a)
;;        >> 42
;;
(defun 3-a ()
  (let ((foo (list 0 42 2 3)))
  (setf foo (rest foo))        ; change foo to (42 2 3)
  (first foo)))

;;
;; (b)
;;
;; Usage: > (3-b)
;;        >> 42
;;
(defun 3-b ()
  (let* ((keys '(:a :b :c))
         (values '(0 1 2))
		 (pairs (pairlis keys values))) ; make alist of 'keys' and 'values',
		                                ; i.e. 'pairs' becomes ((:a . 0) (b . 1) (c . 2)).
										  
    (setf (nth 1 pairs) (cons :b '42))   ; change (b . 1) in 'pairs' to (b . 42)
	(rest (assoc :b pairs))))	 

;;
;; (c)
;;
;; Usage: > (3-c)
;;        >> 42
;;           T
;;
(defun 3-c ()
  (let ((foo (make-hash-table)))
    (setf (gethash 'meaning foo) 41)
	(setf (gethash ’meaning foo) 42) ; change the value associated with key 'meaning
		                             ; in hash table 'foo' to 42
	(gethash 'meaning foo)))

;;
;; (d)
;;
;; Usage: > (3-d)
;;        >> 42
;;
(defun 3-d ()
  (let ((foo (make-array 5)))
    (setf (aref foo 2) 42)    ; set element at index 2 to 42
	(aref foo 2)))


;;;
;;; Task 4 - Recursion and iteration
;;;

;;
;; (a) 
;; 
;; Comment: This is the recursive version of count-member. See inline
;;          comments for clarification.
;;
;; Usage: > (4-a)
;;        > (count-member 'A '(A b c A d e g A))
;;        >> 3
;;
(defun 4-a ()
  (defun count-member (smb lst)
    (if lst                                    ; Check if 'lst' is empty.
	  (if (equal smb (first lst))              ; Check if 'smb' and (first lst) matches.
	    (1+ (count-member smb (rest lst)))     ; If so: increment by one and do recursive call.
		(count-member smb (rest lst)))         ; Otherwise: Do not increment but do recursive call.
	  0)))                                     ; If 'lst' is empty return 0 and terminate.

	  
;;
;; (b)
;;
;; Comment: This is the non-recursive version of count-member. See inline
;; 
;; Usage: > (4-a)
;;        > (count-member 'A '(A b c A d e g A))
;;        >> 3
;;
(defun 4-b ()
  (defun count-member (smb lst)
    (let ((total 0))              ; Initialize local variable 'total' to 0.
	  (loop for x in lst          ; Then, for each element 'x' in 'lst':
	    if (equal smb x)          ; if current element 'x' is equal to 'smb', 
		do (incf total))          ; then increment 'total' by one
	  total)))                    ; Return total.
	  
	  
;;;
;;; Task 5 - Reading a corpus file; basic counts
;;;

;;
;; (a)
;;
;; Comment: The (with-open-file ...) expression returns a list containing
;;          each and every token of the file "brown1000.txt". Here a token
;;          means any combination of characters so long as said combination
;;          does not contain any whitespace characters. Whitespace is the
;;          delimiter.
;;
;; Usage: > (5-a)
;;        > (tokenize "a b c")
;;        >> ("a" "b" "c")
;;
(defun 5-a ()
  ; Provided from assignment text
  (defun tokenize (string)
  (loop
    for start = 0 then (+ space 1)
	for space = (position #\space string :start start)
	for token = (subseq string start space)
	unless (string= token "") collect token
	until (not space))))
	
;;
;; (b)
;;
;; Comment: Simply use defparameter to define a new global variable *corpus*, and copy-
;;          paste the (with-open-file)-expression into the place of value. There are 23187
;;          tokens in *corpus*.
;;
;; Usage: > (5-b "D:\brown1000.txt)
;;        > (length *corpus*)
;;        >> 23187
;;        
;;
(defun 5-b (path)
  (defparameter *corpus* (with-open-file (stream path :direction :input)
                          (loop for line = (read-line stream nil)
	                       while line
	                       append (tokenize line)))))
						   
;; 
;; (c)
;;
;; Comment: The current strategy for tokenization is to delimit by whitespace. I.e.
;;          (tokenize "hello world") yields two tokens, "hello" and "world". 
;;          I did not slog through the brown1000.txt file myself (there is a reason we program :)),
;;          but the current strategy will obviously tokenize "hello" and "hello." into
;;          two separate tokens/words, both of which should probably be treated as the same 
;;          identical word. 
;;

;;
;; (d)
;;
;; Commment: First define a hash table named 'unique-words'. Then loop through
;;           each token in '*corpus* (from (b)). If the token already exists in
;;           the hash table, increment its value by one. If it does not exist,
;;           initialize it in the hash table with value 1.
;; 
;; Usage: > (5-d)
;;        >> #<EQUALP Hash Table{5914} 21C8D983>
;;
(defun 5-d ()
  (let ((unique-words (make-hash-table :test #'equalp)))
    (loop for token in *corpus*
      do (if (gethash token unique-words)
	     (incf (gethash token unique-words))
		 (setf (gethash token unique-words) 1)))
	  unique-words))
		 	
;;
;; (e)
;;
;; Comment: There are 5914 unique word types in *corpus*.
;;          This is because
;;                         > (hash-table-count (5-d))
;;                         >> 5914