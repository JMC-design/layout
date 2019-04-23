(defpackage :layout
  (:use :cl)
  (:export #:calc-layout
	   #:calc-sizes)
  (:documentation "basics of dividing a surface into different sections"))
(in-package :layout)

(defun calc-box (list limit)
  "Divides limit by amount of items in list."
  (let ((free 0)      ;views with unspecified sizes
	(first-free ) ;We add all division remainders to the first unsized 
	(free-space limit)
	(result '()))
    (loop :for item :in list :do
       (typecase item
	 (symbol (let ((res (cons item nil)))
		   (push res result)
		   (when (eql free 0) (setf first-free res))
		   (incf free)))
	 ;; cons means division or param. if cdr is a symbol it's a param
	 (cons   (if (listp (cdr item)) ; division?
		     (progn   ; when division, push the whole division
		       (let ((res (cons item nil)))
			 (push res result)
			 (when (eql free 0) (setf first-free res))
			 (incf free)))
		     (let* ((unit (car item))
			    (param (cdr item))
			    (measure (typecase param
				       (integer (decf free-space param) param) ; pixels
				       (real (let ((amount (round (* param limit))))
					       (decf free-space amount) ; percentage 
					       amount))
				       (cons nil)))) ; means we've got a division
		       (push (cons unit measure) result))))))
    (let ((remaining free-space))
      (multiple-value-bind (division remainder)(floor free-space free)
	(dolist (unit result)
	  (when (null (cdr unit))
	    (rplacd unit division )))
	(when (plusp remaining) (incf (cdr first-free) remainder))))
    (nreverse result)))

(defun calc-layout (layout size &optional (horizontal nil) (x 0) (y 0))
  "Takes a layout and size (width . height) and returns a list of items with their dimensions and locations."
  (let* ((width (car size))
	 (height (cdr size))
	 (current (calc-box layout height))
	 (cur-x x) (cur-y y) 
	 (result '()))
    (loop :for (box . size) :in current
       :do (let ((new-x (if horizontal (+ cur-x size) (+ cur-x width)))
		 (new-y (if horizontal (+ cur-y width) (+ cur-y size))))
	     (if (symbolp box)
		 (progn (push `(,box ,(if horizontal `(,size . ,width) `(,width . ,size))
				     (,cur-x . ,cur-y)) result)
			(if horizontal (setf cur-x new-x)(setf cur-y new-y)))

		 (progn (setf result (append (nreverse (calc-layout box (if horizontal `(,size . ,width) `(,size . ,width)) (if horizontal nil t) cur-x cur-y)) result))
			(if horizontal (setf cur-x new-x) (setf cur-y new-y))))))
    (nreverse result)))

(defun calc-sizes (layout size &optional (horizontal nil))
  "Takes a layout and size (width . height) and returns a list of items and their dimensions."
  (let* ((width (car size))
	 (height (cdr size))
	 (current (calc-box layout height))
	 (result '()))
    (print current)
    (loop :for (box . size) :in current
       :do (if (symbolp box)
	       (push `(,box ,(if horizontal `(,size . ,width) `(,width . ,size))) result)
	       (setf result  (append (nreverse (calc-box box (if horizontal `(,size . ,width) `(,size . ,width)))) result))))
    (nreverse result)))

;;this shouldn't be here, but here it is.
#+life
(defun preview-layout (layout &optional (divisor 4))
  (let* ((width (floor 1920 divisor)) ;let's make the wrong assumption that it's fullscreen
	 (height (floor 1080 divisor))
	 (container (view:view (xwindows:get-window :width width :height height))))
    (xlib:map-window (view:surface-of container))
    (loop :for (name size location) :in layout
       :for colour :from 10000 by 10000
       :do (let* ((xwindows:*background* colour)
		  (xwindows::*default-parent* (view:surface-of container))
		  (view (view:view name :location `(,(floor (car location) divisor) . ,(floor (cdr location) divisor)))))
	     (setf (view:dimensions-of view)`(,(floor (car size) divisor) . ,(floor (cdr size) divisor)))
	     (view:update view)))
    container))
