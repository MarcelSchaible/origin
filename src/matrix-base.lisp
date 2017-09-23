(in-package :gamebox-math)

(deftype matrix () '(simple-array single-float (16)))

(defstruct (matrix (:type (vector single-float))
                   (:constructor %matrix (m00 m01 m02 m03
                                          m10 m11 m12 m13
                                          m20 m21 m22 m23
                                          m30 m31 m32 m33))
                   (:conc-name nil)
                   (:copier nil)
                   (:predicate nil))
  (m00 0.0 :type single-float)
  (m10 0.0 :type single-float)
  (m20 0.0 :type single-float)
  (m30 0.0 :type single-float)
  (m01 0.0 :type single-float)
  (m11 0.0 :type single-float)
  (m21 0.0 :type single-float)
  (m31 0.0 :type single-float)
  (m02 0.0 :type single-float)
  (m12 0.0 :type single-float)
  (m22 0.0 :type single-float)
  (m32 0.0 :type single-float)
  (m03 0.0 :type single-float)
  (m13 0.0 :type single-float)
  (m23 0.0 :type single-float)
  (m33 0.0 :type single-float))

(defun* matrix (&optional ((m00 real) 0) ((m01 real) 0) ((m02 real) 0)
                          ((m03 real) 0) ((m10 real) 0) ((m11 real) 0)
                          ((m12 real) 0) ((m13 real) 0) ((m20 real) 0)
                          ((m21 real) 0) ((m22 real) 0) ((m23 real) 0)
                          ((m30 real) 0) ((m31 real) 0) ((m32 real) 0)
                          ((m33 real) 0))
    (:result matrix)
  (%matrix (float m00 1.0) (float m01 1.0) (float m02 1.0) (float m03 1.0)
           (float m10 1.0) (float m11 1.0) (float m12 1.0) (float m13 1.0)
           (float m20 1.0) (float m21 1.0) (float m22 1.0) (float m23 1.0)
           (float m30 1.0) (float m31 1.0) (float m32 1.0) (float m33 1.0)))

(defmacro with-matrix ((prefix matrix) &body body)
  `(with-accessors ((,prefix identity)
                    (,(symbolicate prefix "00") m00)
                    (,(symbolicate prefix "01") m01)
                    (,(symbolicate prefix "02") m02)
                    (,(symbolicate prefix "03") m03)
                    (,(symbolicate prefix "10") m10)
                    (,(symbolicate prefix "11") m11)
                    (,(symbolicate prefix "12") m12)
                    (,(symbolicate prefix "13") m13)
                    (,(symbolicate prefix "20") m20)
                    (,(symbolicate prefix "21") m21)
                    (,(symbolicate prefix "22") m22)
                    (,(symbolicate prefix "23") m23)
                    (,(symbolicate prefix "30") m30)
                    (,(symbolicate prefix "31") m31)
                    (,(symbolicate prefix "32") m32)
                    (,(symbolicate prefix "33") m33))
       ,matrix
     ,@body))

(defmacro with-matrices (binds &body body)
  (if (null binds)
      `(progn ,@body)
      `(with-matrix ,(car binds)
         (with-matrices ,(cdr binds) ,@body))))

(defun* mref ((matrix matrix) (row (integer 0 15)) (column (integer 0 15)))
    (:result single-float)
  (aref matrix (+ row (* column 4))))

(defun* (setf mref) ((value single-float) (matrix matrix) (row (integer 0 15))
                     (column (integer 0 15)))
    (:result single-float)
  (setf (aref matrix (+ row (* column 4))) value))

(set-pprint-dispatch
 'matrix
 (lambda (stream object)
   (print-unreadable-object (object stream)
     (with-matrix (m object)
       (format stream "~f ~f ~f ~f~%  ~f ~f ~f ~f~%  ~f ~f ~f ~f~%  ~f ~f ~f ~f"
               m00 m01 m02 m03
               m10 m11 m12 m13
               m20 m21 m22 m23
               m30 m31 m32 m33))))
 1)
