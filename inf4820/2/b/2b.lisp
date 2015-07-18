;;; ********* Mandatory assignment 2b ***********
;;;
;;; Usage:	CL-USER> (load "2b.lisp")
;;;					CL-USER> (defparameter space (length-normalize-vs (read-corpus-to-vs
;;;                     "D:/words.txt" "D:/brown20000.txt")))
;;;         SPACE
;;;         CL-USER> (rocchio-classify space "D:/classes.txt")
;;;         				 (("fruit" :FOODSTUFF 0.36698064) ... )
;;;
;;; Not sure if it's okay, but I'm supplying "2a.lisp" as well, since my code loads
;;; that file in order to function. I changed the tokenize and normalize-token
;;; functions after looking at the solution for assignment 2a. Other than that, the
;;; "2a.lisp" file should be identical to my previous delivery.
;;;		Also remember that I accidently switched the order of the parameters for
;;; words.txt and brown20000.txt in my read-corpus-to-vs function, so use
;;; caution. ^^
;;;		Other than that, simply check out the individual comments in the various
;;; functions below.
;;; 	Oh, and on a final note: My classification results differ somewhat from
;;; the example run in the assignment text. Specifically with regards to
;;; "hiroshima", "asia" and "moscow". Not sure if it means anything significant.
;;; 


;;; load excercise 2a
(load "2a.lisp")

;;;; 							(1a)
;;;; ----------------------------------

;;; Usage:	CL-USER> (read-classes space "D:/classes.txt")
;;;         #<HASH-TABLE :TEST EQL size 6/60 #x21025F8F7D>
;;;         CL-USER> (gethash :title (vs-classes space))
;;;         (PRODUCER DIRECTOR ... MINISTER)
;;;         T
(defun read-classes (vs path)
	"Read the class-member relationships from classes.txt and
	 store them in the 'classes' slot in the vs structure."
	(let ((classes-and-words nil)
				(classes (make-hash-table)))
	
		; read classes-words pairs into a nested list, e.g.
		; ((:FOODSTUFF (POTATO FOOD ...))
		; ...
		; (:UNKNOWN (FRUIT CALIFORNIA ...)))
		(with-open-file (stream path :direction :input)
			(loop for class = (read stream nil nil)
			 while class collect class into cw
			 finally (setf classes-and-words cw)))
			 
		; add keys (class names) and corresponding values (members).
		(loop for lists in classes-and-words do
			(setf (gethash (nth 0 lists) classes) (nth 1 lists)))
					
		; update vs structure.
		(setf (vs-classes vs) classes)))
		
					
;;;; 							(1b)
;;;; ----------------------------------

;;; Basically identical to what went on in my implementation of excercise 
;;; 2a, but figured I'd make a separate function to normalize a single 
;;; vector this time 'round.
;;;
;;; Usage: 	CL-USER> (defparameter vec (get-feature-vector space "food"))
;;;					VEC
;;;					CL-USER> (euclidian-length vec)
;;;         0.99999875
(defun normalize-vector (vec)
	"Normalize a vector."
	(let ((el (euclidian-length vec)))
		(loop for key being the hash-key of vec do
			(setf (gethash key vec) (/ (gethash key vec) el)))))


;;; Usage:	CL-USER> (defparameter centroid (compute-centroid space :title))
;;;         CENTROID
;;;         CL-USER> centroid
;;;         #<HASH-TABLE :TEST EQL size 7667/7837 #x21022EEA0D>
;;;         CL-USER> (euclidian-length centroid)
;;;         0.9999869               
(defun compute-centroid (vs class)
	"Compute and return the centroid of a single class."
	(let* ((centroid (make-hash-table))
				 (members (gethash class (vs-classes vs)))
				 (cardinality (length members)))
				 
		; for each members of the class:
		(loop for mem in members do
			(let* ((mem (normalize-token (string mem)))
						 (features (get-feature-vector vs mem)))
				; for each feature (id/count) of the current member:
				(loop for feat being the hash-key of features using (hash-value val) do
					; feature already observed?
					(if (gethash feat centroid)
						; yep: increment its value accordingly;
						; equivalent to e.g. prev + new = [1, *2*] + [0, *1*] = [1, *3*]
						(incf (gethash feat centroid) val)
						; nope: add it;
						; equivalent to e.g. prev + new = new = [*0*, 1] + [*4*, 0] = [*4*, 1]
						(setf (gethash feat centroid) val)))))
						
		; average the centroid
		(loop for key being the hash-key of centroid do
			(setf (gethash key centroid) (/ (gethash key centroid) cardinality)))
			
		; normalize the centroid
		(normalize-vector centroid)
	  centroid))


;;; Note: This one overwrites the previous values of the hash-map stored in
;;; the 'classes' slot. The values used to be a list of the members 
;;; associated with each key (class), but centroid computation renders this
;;; information useless. The previous class members are therefore overwritten
;;; by the class centroids.
;;;
;;; Usage:	CL-USER> (compute-class-centroids space)
;;;         NIL
;;;					CL-USER> (gethash :foodstuff (vs-classes space))
;;;         #<HASH-TABLE :TEST EQL size 3909/5228 #x2102468C0D>
;;;         T
;;;         CL-USER (gethash :place_name (vs-classes space))
;;;         #<HASH-TABLE :TEST EQL size 6812/7837 #x21023A220D>
;;;         T
(defun compute-class-centroids (vs)
	"Compute the length-normalized centroids for each class and
	 store the centroids in the vs structure."
	(loop for class-name being the hash-key of (vs-classes vs) do
		(let ((centroid (compute-centroid vs class-name)))
			(setf (gethash class-name (vs-classes vs)) centroid))))
			

;;;; 							(1c)
;;;; ----------------------------------
	
;;;
;;; Usage:	CL-USER> (rocchio-classify space "D:/classes.txt")
;;;					(("fruit" :FOODSTUFF 0.36698064) ("california" :PERSON_NAME 0.33499405)
;;:					 ("peter" :PERSON_NAME 0.32838178) ("egypt" :INSTITUTION 0.21396887)
;;;					 ("department" :INSTITUTION 0.5725189) ("hiroshima" :FOODSTUFF 0.20936832)
;;;					 ("robert" :PERSON_NAME 0.6210513) ("butter" :FOODSTUFF 0.3811706)
;;;					 ("pepper" :FOODSTUFF 0.3658523) ("asia" :INSTITUTION 0.29352966)
;;;					 ("roosevelt" :TITLE 0.28158894) ("moscow" :TITLE 0.42441374)
;;;					 ("senator" :TITLE 0.38437977) ("university" :INSTITUTION 0.6031033)
;;;					 ("sheriff" :TITLE 0.24818212))	
;;;				
(defun rocchio-classify (vs path)
	"Attempt to classify all the 'unknown' words in classes.txt"
	(let ((results nil))
	
		; get the classes and their members
		(read-classes vs path)
		
					; store the unknowns
		(let ((unknowns (gethash :unknown (vs-classes vs))))
		
		; compute the centroids
			(compute-class-centroids vs)
			
			; for each unknown word:
			(loop for unknown in unknowns do
				(let* ((unknown (normalize-token (string unknown)))
							 (fvec	(get-feature-vector vs unknown))
							 (result nil)
							 (best-score 0)
							 (best-match nil))
							 
					; loop for each actual class:
					(loop for class being the hash-key of (vs-classes vs) unless (eq class :unknown) do						
						(let* ((centroid (gethash class (vs-classes vs)))
									 (score (dot-product fvec centroid)))
									 
							; check if current class is the most similar so far, and if so update
							; accordingly
							(if (not best-match)
								(setf best-match class)
								(if (> score best-score)
									(progn
										(setf best-score score)
										(setf best-match class))))))
										
					; update results list
					(setf result (list (list unknown best-match best-score)))
					(setf results (append results result)))))
					
		; return/output		
		results))
		
		
;;;; 							(1d)
;;;; ----------------------------------

;;; I did indeed choose to use the same data type as the
;;; feature vectors for my centroids. My reasoning for this
;;; was simply that I already had a working 'dot-product'
;;; function, so no extra work needed to be done for 
;;; computing the similarity score of a centroid vector
;;; and a feature vector.


;;;; 							(2a)
;;;; ----------------------------------

;;; One of the main differences between Rocchio and kNN classification
;;; is the way the training data is used; in Rocchio all the training data
;;; is used prior to a classification attempt (averaging etc), while in kNN 
;;; only the k nearest samples are used - and only during a query.
;;;		In Rocchio classification, the classes are represented as the mean
;;; of their (normalized) members, and one can thus attempt to classify 
;;; an unlabeled object by looking at how "similar" the unlabeled object is
;;; to the class representation as a whole. In kNN however, there is no
;;; "collective" class representation; one simply looks at the k feature
;;; vectors with the highest similarity score and choose the most frequent
;;; class among these.
;;;		Time complexities (TC): Much higher for training a Rocchio than kNN,
;;; since the latter doesn't really "train" at all (constant TC). Testing
;;; is typically more computationally expensive for kNN than Rocchio, since
;;; Rocchio has already done most of the work during the "training" part.
;;; (didn't delve too much into the details here, tried to keep it somewhat
;;; short).
;;;		Boundaries: Rocchio has linear boundaries and so really only works
;;; well on problems involving classes with a high degree of linear separability, 
;;; while kNN is more general, i.e. in the sense that the boundaries can be non-linear (
;;; i.e. classes don't have to be separable by a straight line/hyperplane). 


;;;; 							(2b)
;;;; ----------------------------------

;;; The main difference between Rocchio and k-means is that while the former
;;; is supervised (i.e. training data with known classes), the latter is
;;; *unsupervised*. 
;;; 	They are similar in the sense that they both involve means/centroids,
;;; but while the Rocchio variant uses fixed centroids, the k-means centroids
;;; get updated along the way as new observations are added (e.g. find that new
;;; X goes into cluster A -> revise centroid for cluster A -> find that new Y that
;;; would perhaps previously go into cluster D now, with the updated cluster A, 
;;; actually should belong to cluster B -> revise centroid for cluster B, etc.).


;;;; 							(2c)
;;;; ----------------------------------

;;; In order to evaluate our Rocchio classifier we would have to evaluate the number
;;; of correctly classified test samples - e.g. by comparing to a kind of pre-decided
;;; solution. The test set/solution should be independent of the training set so as
;;; to avoid overfitting (i.e. generalization to randomness in the training set rather
;;; than actual test sets).
;;; 	How well the classifier performed could be determined by concepts such as
;;;	'precision', 'accuracy' and 'recall' - all of which say something about the
;;; classification performance (emphasizing different aspects of the performance),
;;; but used alone they  may have various drawbacks, one may also use combined 
;;; measures involving e.g. both precision and recall (== F-score). This approach
;;; can also be extended to multi-class classification problems.

