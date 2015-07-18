;;;;;
;;;;; assignment2.lisp
;;;;; 

;;;;
;;;; Task 1 - Theory: Word–context vector space models
;;;;
;;;; Comment: There are many ways in which we could define what 'context' should
;;;;          mean. In this assignment we use the Bag-of-Words (BoW) approach, 
;;;;          in which we have defined the context of X to be all words that 
;;;;          co-occur with X in the sentences X appear in.
;;;;            Another approach could be so-called 'context windows', which is
;;;;          similar to BoW but with a contraint of N words in each direction
;;;;          of X. Both BoW and context windows have the useful quality that 
;;;;          they do not require a priori knowledge.
;;;;            We could also use a 'syntactical/grammatical' context, which
;;;;          (I think) could be similar to BoW and windows, but with the 
;;;;          imposition that the words are categorized into various grammatical
;;;;          classes, such that two contexts of X containing the same words
;;;;          could have vastly different semantic meanings because of the
;;;;          aforementioned grammatical classes. For example, X could be a
;;;;          direct object inone context and an indirect object in another
;;;;          context. This approach is probably much more realistic, but also
;;;;          supposedly computationally more expensive since it requires a 
;;;;          priori knowledge of grammar.
;;;;           

;;;;
;;;; Task 2a - Representing the vector space
;;;;
(defstruct vs string-map id-map matrix similarity-fn classes)

;;;;
;;;; Task 2b - Populating the co-occurrence matrix
;;;;
;;;; Comment: I created a lot of helper functions so as to not spaghettify my
;;;;          code too much. Some were also copied from assignment 1. It
;;;;          all comes together in the read-corpus-to-vs function. See
;;;;          individual function comments for clarifications.
;;;
;;; Tokenize a string and output the result as a list of tokens.
;;; Copied from the text of assignment 1.
;;;
;;; Example usage: CL-USER> (tokenize "hello world")
;;;                ("hello" "world")
;;;
(defun tokenize (string)
  "Splits a sequence into tokens, filters stop-words and normalizes."
  (loop 
      for start = 0 then (+ space 1)
      for space = (position #\space string :start start)
      for token = (normalize-token (subseq string start space))
      unless (string= token "") 
      collect token
      until (not space)))
	
;;;
;;; Remove duplicate words in a nested list that is supposed to contain each
;;; sentence from brown20000.txt. I.e. the output is a hash-map containing
;;; one copy of each word in the corpus.
;;;
;;; Example usage: CL-USER> (get-unique-words '(("A" "B") ("A C")))
;;;                #<HASH-TABLE :TEST EQUALP size 3/60 #x2100BE69BD>
;;;
(defun get-unique-words (corpus)
	(let ((unique-words (make-hash-table :test #'equalp)))
    (loop for lst in corpus
			do (loop for token in lst
				do (if (gethash token unique-words)
					 (incf (gethash token unique-words))
					 (setf (gethash token unique-words) 1))))
		unique-words))

;;;
;;; Loop through the elements of a list and insert them into a hash table.
;;; Specifically used for turning the *stop-list* into a hash-table.
;;;
;;; Example usage: CL-USER> (make-hash-of-list '(1 2 3 4))
;;;                #<HASH-TABLE :TEST EQUAL size 4/60 #x2100C401DD>
;;;		
(defun make-hash-of-list (lst)
	(let ((table (make-hash-table :test #'equal)))
		(loop for x in lst
			do (setf (gethash x table) 1))
		table))

;;;
;;; Construct an association list from the key-value pairs in a hash-table.
;;;
;;; Example usage: CL-USER> (make-alist-of-hash-table (get-feature-vector space "potato"))
;;                 ((6404 . 1) (8039 . 1) (9269 . 1) ... )
;;; 
(defun make-alist-of-hash-table (table)
	(let (alist '())
		(loop for key being the hash-key using (hash-value val) of table
			do (setf alist (acons key val alist)))
		alist))
		
		
;;;
;;; Normalize a token, i.e. remove unwanted prefixes and suffixes and also
;;; make it lowercase. This could be fine-tuned a whole lot more. Not sure 
;;; if CL has built-in regex features. I included code for removing the 
;;; possessive ending "'s", but plural forms will still exist. See example 
;;; usage below.
;;;
;;; Example usage: CL-USER> (normalize-token ".!Georgia's")
;;;                "georgia"
;;;                CL-USER> (normalize-token ".!HUMANS")
;;;                humans
;;;                
;;;
(defun normalize-token (token)
	(setf token (string-downcase token))
	(setf token (string-trim " ,.!?(){}[]-+@&\";:'*#" token))
	(if (eq (position #\' token) (- (length token) 2))
		(setf token (string-right-trim "'s" token)))
	token)
	
;;;
;;; Read, normalize and store all sentences in brown20000.txt into a nested
;;; list. E.g. return value is ((sentence1) (sentence2) ... (sentence20000)).
;;;
;;; Example usage: CL-USER> (defparameter *brown20000* (read-corpus
;;;                          "D:/brown20000.txt"))
;;;                *brown20000*
;;;                CL-USER> (nth 0 *brown2000*)
;;;                ("fulton" "county" "grand" ... "place")
(defun read-corpus (path)
	(let* ((corpus '())
				 (stop-list
					'("a" "about" "also" "an" "and" "any" "are" "as" "at" "be" "been"
						"but" "by" "can" "could" "do" "for" "from" "had" "has" "have"
						"he" "her" "him" "his" "how" "i" "if" "in" "is" "it" "its" "la"
						"may" "most" "new" "no" "not" "of" "on" "or" "she" "some" "such"
						"than" "that" "the" "their" "them" "there" "these" "they" "this"
						"those" "to" "was" "we" "were" "what" "when" "where" "which"
						"who" "will" "with" "would" "you"))
				 (stop-list (make-hash-of-list stop-list)))
		(with-open-file (stream path)
			(loop for line = (read-line stream nil)
				while line
				do (
					let ((sentence '()))
						;; Loop through each token in the current line, check if
						;; current token is OK according to the stop-list and
		        ;; and add it to a temporary sentence, which will in turn
						;; be expanded with the next token and so on. The sentence
						;; is then nested into the 'corpus' list.
						(loop for token in (tokenize line)
							do (if (not (gethash (normalize-token token) stop-list))
										(setf sentence (append sentence 
																		(list (normalize-token token))))))
						(setf corpus (append corpus (list sentence))))))
	corpus))

;;;
;;; Read the words of a file into a list (for use with words.txt)
;;;
;;; Example usage: CL-USER> (read-words "D:/words.txt")
;;;                ("potato" "food" "bread" ... "minister" "sheriff")
;;;
(defun read-words (path)
	(let ((words '()))
		(with-open-file (stream path)
			(loop for line = (read-line stream nil)
				while line
				do (setf words (append words (tokenize line)))))
		words))
						
;;;
;;; Map from string to id.
;;; The return value is a list consisting of the (separate) string-to-id
;;; mappings of the (unique) words in words.txt and brown20000.txt, 
;;; respectively.
;;;
;;; Example usage: CL-USER> (gethash "food" (nth 0 (string2id *words* *features*)))
;;;                1
;;;                T
;;;                CL-USER> (gethash "food" (nth 1 (string2id *words* *features*)))
;;;                21173
;;;                T
;;;
(defun string2id (words features)
	(let ((string-map-w (make-hash-table :test #'equal))
				(string-map-f (make-hash-table :test #'equal))
				(id-w 0)
				(id-f 0))
		(loop for w in words 
			do (
				progn (setf (gethash w string-map-w) id-w)
							(incf id-w)))
		(loop for key being the hash-key of features
			do (
				progn (setf (gethash key string-map-f) id-f)
							(incf id-f)))
		(list string-map-w string-map-f)))

;;
;; And map from id and back to string.
;; The return value is a list consisting of the (separate) id-to-string
;; mappings of the (unique) words in words.txt and brown20000.txt,
;; respectively.
;;
;; Example usage: CL-USER> (defparameter *id-map* (id2string
;;                            (nth 0 *string-map*) (nth 1 *string-map*)))
;;                *ID-MAP*
;;                CL-USER> (gethash 0 (nth 0 *id-map*))
;;                "potato"
;;                T
;;                CL-USER> (gethash 0 (nth 1 *id-map))
;;                "overemphasized"
;;                T                  
;;
(defun id2string (string-map-words string-map-features)
	(let ((id-map-w (make-hash-table))
				(id-map-f (make-hash-table)))
		(loop for key being the hash-key of string-map-words
			do (setf (gethash (gethash key string-map-words) id-map-w) key))
		(loop for key being the hash-key of string-map-features
			do (setf (gethash (gethash key string-map-features) id-map-f) key))
		(list id-map-w id-map-f)))
		
(defun update-feature-vector (vector word-id)
	(if (gethash word-id vector)
		(incf (gethash word-id vector))
		(setf (gethash word-id vector) 1))
	vector)
	

;;;
;;; Create and populate the co-occurrence matrix. 
;;; 
;;; 
;;; The matrix is an array of 122 places; one for each word in "words.txt". The 
;;; index of each place corresponds to a word which can be retrieved by looking  
;;; up the index number in the id-map. Each place shall in turn hold the 
;;; features of the word corresponding to that place. 
;;; 
;;; Considering that the feature vectors for each word will, in general,
;;; presumably be extremely sparse, I chose to store the feature vectors as hash
;;; tables; each key is a number which corresponds to a word in the corpus (use
;;; id-map), and the value for said key is the number of times the word
;;; corresponding to the key have co-occurred with the word the feature vector
;;; belongs to.
;;; 
;;; An alternative to hash tables could be to use lists or arrays of a size
;;; equal to the number of unique words in the corpus, in which each index
;;; number corresponded to a word (by using id-map), and the value at said
;;; place was the number of times the word had co-occurred with the word the
;;; feature vector belongs to. The problem with this approach is that these
;;; vectors would have a length of around 32k, which would lead to much
;;; higher space and time complexities as compared to hash tables.
;;;		
(defun create-matrix (string-map id-map corpus)
	
	      ; local variables
	(let ((matrix (make-array 122))
				(word nil)
				(id nil))
		
		; Loop through each id corresponding to the words in "words.txt"
		; while at the same time looping through each sentence in the corpus.
		; If the current word is in the current sentence, the words in said
		; sentence are added to the feature vector for the current word,
		; provided that they are unequal to the current word.
		(loop for i from 0 to 121 ; for each of the 122 words in words.txt
			do (let ((features (make-hash-table :test #'equal)))
						(progn
						(setf word (gethash i (nth 0 id-map)))
						(loop for sentence in corpus
							do (if (member word sentence :test #'equal)
									(loop for token in sentence
										do (if (not (equal word token))
													(progn
													; update id
													(setf id (gethash token (nth 1 string-map)))
													; update feature vector
													(setf features (update-feature-vector features id))))))))
						(setf (aref matrix i) features))) ; insert the feature vector				
						
		matrix)) ; return
					

;;;
;;; This is the "main" function, i.e. the one which accomplishes what the task 
;;; indeed was. The code is pretty straight-forward; see the individual helper
;;; functions for clarification.
;;;
(defun read-corpus-to-vs (path-words path-corpus)

         ; local variables
	(let* ((words (read-words path-words))
	       (corpus (read-corpus path-corpus))
				 (features (get-unique-words corpus))
				 (space (make-vs))
				 (string-map nil)
				 (id-map nil)
				 (matrix nil))
		
		; pre-required stuff
		(setf string-map (string2id words features))
		(setf id-map (id2string (nth 0 string-map) (nth 1 string-map)))
		(setf matrix (create-matrix string-map id-map corpus))
		
		; put pre-required stuff into structure  
		(setf (vs-string-map space) string-map)
		(setf (vs-id-map space) id-map)
		(setf (vs-matrix space) matrix)
		
		space)) ; return
		
;;;;
;;;; Task 2c - Retrieve feature vector
;;;;
;;;; Retrieve the id for the word, and retrieve the feature vector
;;;; at index = id. Pretty simple. 
;;;;
(defun get-feature-vector (space word)
	(let ((id (gethash word (nth 0 (vs-string-map space)))))
		(aref (vs-matrix space) id)))
		
;;;;
;;;; Task 2d - Printing features
;;;;
;;;; For some input word print the N features with the highest occurrence
;;;;  count. I got the sorting trick from 
;;;; www.ai.mit.edu/projects/iiip/doc/CommonLISP/HyperSpec/Body/fun_sortcm_stable-sort.html
;;;;
;;;; Example usage: CL-USER> (print-featuers space "university" 10)
;;;;                "" 55
;;;; 								"dr" 17
;;;; 								"state" 16
;;;; 								"college" 15
;;;;                "students" 12
;;;; 								"professor" 11
;;;;						    "emory" 11
;;;;                "school" 11
;;;;                "only" 9
;;;;                "after" 9
;;;;                NIL
;;;;
(defun print-features (space word n)
	(let* ((features (get-feature-vector space word))
	       (alist (make-alist-of-hash-table features))
		     (alist (sort alist #'> :key #'cdr))
				 (word nil)
				 (count 0))				
		(loop for i from 0 to (- n 1)
			do (
				progn
			  (setf word (gethash (car (nth i alist)) (nth 1 (vs-id-map space))))
			  (setf count (cdr (nth i alist)))
			  (format t "~S ~D~%" word count)))))

;;;;
;;;; Task 3a - Euclidian length
;;;;
;;;; Retrieve the id for the word, and retrieve the feature vector
;;;; at index = id. Pretty simple. 
;;;;
;;;; Example usage: CL-USER> (euclidian-length (get-feature-vector space "food"))
;;;;                58.258045
;;;;                CL-USER> (euclidian-length (get-feature-vector space "university"))
;;;;                96.44688
;;;;
(defun euclidian-length (vec)
	(let ((sum 0))
		(loop for val being the hash-value of vec
			do (setf sum (+ sum (* val val))))
		(sqrt sum)))

;;;;
;;;; Task 3b - Normalize feature vectors
;;;;
;;;; Destructively modify all feature vectors in the co-occurrence matrix such
;;;; that each vector has euclidian length equal to 1. 
;;;;
;;;; Example usage: CL-USER> (setf space (length-normalize-vs space))
;;;;                #S(VS :STRING-MAP ...
;;;;                CL-USER> (euclidian-length (get-feature-vector space "university"))
;;;;                1.0000001
;;;;                CL-USER> (euclidian-length (get-feature-vector space "potato"))
;;;;                0.9999997
;;;;
(defun length-normalize-vs (space)
	(let ((vec nil)
			  (el 0))
		(loop for i from 0 to 121 
			do (
			progn (setf vec (aref (vs-matrix space) i))
						(setf el (euclidian-length vec))
						(loop for key being the hash-key using (hash-value val) of vec
							do (setf (gethash key vec) (/ val el)))
						(setf (aref (vs-matrix space) i) vec)))
		space))
		
;;;;
;;;; Task 3c - Dot product
;;;;
;;;; Compute the similarity score of two vectors.
;;;; Storing it in the structure can be done by
;;;; (setf (vs-similarity-fn space) #'dot-product)
;;;;
(defun dot-product (vec-a vec-b)
	(let ((sum 0))
		(loop for key-a being the hash-key using (hash-value val-a) of vec-a
			do (
				loop for key-b being the hash-key using (hash-value val-b) of vec-b
					do (
						if (eq key-a key-b)
							(setf sum (+ sum (* val-a val-b))))))
		sum))
		
;;;;
;;;; Task 3d - Word similarity
;;;;
;;;; Compute the similarity score between two words.
;;;;
;;;; Example usage: CL-USER> (word-similarity space "university" "college")
;;;;                0.7075184
;;;;                CL-USER> (word-similarity space "university" "bread")
;;;;                0.10800878
;;;;
(defun word-similarity (space word-a word-b)
	(let ((vec-a (get-feature-vector space word-a))
	      (vec-b (get-feature-vector space word-b)))
		(funcall (vs-similarity-fn space) vec-a vec-b)))

		