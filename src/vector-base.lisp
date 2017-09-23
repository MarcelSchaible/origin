(in-package :gamebox-math)

(eval-when (:compile-toplevel :load-toplevel)
  (deftype vec () '(simple-array single-float (3)))

  (defstruct (vec (:type (vector single-float))
                  (:constructor %vec (&optional x y z))
                  (:conc-name v)
                  (:copier nil)
                  (:predicate nil))
    (x 0.0 :type single-float)
    (y 0.0 :type single-float)
    (z 0.0 :type single-float))

  (defun* vec (&optional ((x real) 0) ((y real) 0) ((z real) 0)) (:result vec)
    "Create a new vector."
    (%vec (float x 1.0) (float y 1.0) (float z 1.0)))

  (define-constant +zero-vector+ (vec) :test #'equalp)
  (define-constant +0vec+ (vec) :test #'equalp))

(defmacro with-vector ((prefix vec) &body body)
  "A convenience macro for concisely accessing components of a vector.
Example: (with-vector (v vector) vz) would allow accessing the Z component of the
vector as simply the symbol VZ."
  `(with-accessors ((,prefix identity)
                    (,(symbolicate prefix 'x) vx)
                    (,(symbolicate prefix 'y) vy)
                    (,(symbolicate prefix 'z) vz))
       ,vec
     ,@body))

(defmacro with-vectors (binds &body body)
  "A convenience macro for concisely accessing components of multiple vectors.
Example: (with-vectors ((a vector1) (b vector2) (c vector3)) (values ax by cz))
would access the X component of vector1, the Y component of vector2, and the Z
component of vector3."
  (if (null binds)
      `(progn ,@body)
      `(with-vector ,(car binds)
         (with-vectors ,(cdr binds) ,@body))))

(defun* vref ((vec vec) (index (integer 0 2))) (:result single-float)
  "A virtualized vector component reader. Use this instead of AREF to prevent
unintended behavior should ordering of a vector ever change."
  (aref vec index))

(defun* (setf vref) ((value single-float) (vec vec) (index (integer 0 2)))
    (:result single-float)
  "A virtualized vector component writer. Use this instead of (SETF AREF) to
prevent unintended behavior should ordering of a vector ever change."
  (setf (aref vec index) value))

(set-pprint-dispatch
 'vec
 (lambda (stream object)
   (print-unreadable-object (object stream)
     (with-vector (v object)
       (format stream "~f ~f ~f" vx vy vz))))
 1)
