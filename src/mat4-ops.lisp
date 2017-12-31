(in-package :gamebox-math)

(eval-when (:compile-toplevel :load-toplevel)
  (declaim (inline m4zero!))
  (defun* (m4zero! -> mat4) ((mat mat4))
    (with-mat4 ((m mat))
      (psetf m.00 0.0f0 m.01 0.0f0 m.02 0.0f0 m.03 0.0f0
             m.10 0.0f0 m.11 0.0f0 m.12 0.0f0 m.13 0.0f0
             m.20 0.0f0 m.21 0.0f0 m.22 0.0f0 m.23 0.0f0
             m.30 0.0f0 m.31 0.0f0 m.32 0.0f0 m.33 0.0f0))
    mat)

  (declaim (inline m4zero))
  (defun* (m4zero -> mat4) ()
    (%mat4 0.0f0 0.0f0 0.0f0 0.0f0
           0.0f0 0.0f0 0.0f0 0.0f0
           0.0f0 0.0f0 0.0f0 0.0f0
           0.0f0 0.0f0 0.0f0 0.0f0))

  (define-constant +m4zero+ (m4zero) :test #'equalp)

  (declaim (inline m4id!))
  (defun* (m4id! -> mat4) ((mat mat4))
    (with-mat4 ((m mat))
      (psetf m.00 1.0f0 m.01 0.0f0 m.02 0.0f0 m.03 0.0f0
             m.10 0.0f0 m.11 1.0f0 m.12 0.0f0 m.13 0.0f0
             m.20 0.0f0 m.21 0.0f0 m.22 1.0f0 m.23 0.0f0
             m.30 0.0f0 m.31 0.0f0 m.32 0.0f0 m.33 1.0f0))
    mat)

  (declaim (inline m4id))
  (defun* (m4id -> mat4) ()
    (%mat4 1.0f0 0.0f0 0.0f0 0.0f0
           0.0f0 1.0f0 0.0f0 0.0f0
           0.0f0 0.0f0 1.0f0 0.0f0
           0.0f0 0.0f0 0.0f0 1.0f0))

  (define-constant +m4id+ (m4id) :test #'equalp))

(declaim (inline m4=))
(defun* (m4= -> boolean) ((mat-a mat4) (mat-b mat4))
  (with-mat4 ((ma mat-a) (mb mat-b))
    (and (= ma.00 mb.00) (= ma.01 mb.01) (= ma.02 mb.02) (= ma.03 mb.03)
         (= ma.10 mb.10) (= ma.11 mb.11) (= ma.12 mb.12) (= ma.13 mb.13)
         (= ma.20 mb.20) (= ma.21 mb.21) (= ma.22 mb.22) (= ma.23 mb.23)
         (= ma.30 mb.30) (= ma.31 mb.31) (= ma.32 mb.32) (= ma.33 mb.33))))

(declaim (inline m4~))
(defun* (m4~ -> boolean) ((mat-a mat4) (mat-b mat4)
                          &key
                          ((tolerance single-float) +epsilon+))
  (with-mat4 ((ma mat-a) (mb mat-b))
    (and (~ ma.00 mb.00 tolerance)
         (~ ma.01 mb.01 tolerance)
         (~ ma.02 mb.02 tolerance)
         (~ ma.03 mb.03 tolerance)
         (~ ma.10 mb.10 tolerance)
         (~ ma.11 mb.11 tolerance)
         (~ ma.12 mb.12 tolerance)
         (~ ma.13 mb.13 tolerance)
         (~ ma.20 mb.20 tolerance)
         (~ ma.21 mb.21 tolerance)
         (~ ma.22 mb.22 tolerance)
         (~ ma.23 mb.23 tolerance)
         (~ ma.30 mb.30 tolerance)
         (~ ma.31 mb.31 tolerance)
         (~ ma.32 mb.32 tolerance)
         (~ ma.33 mb.33 tolerance))))

(declaim (inline m4cp!))
(defun* (m4cp! -> mat4) ((out-mat mat4) (mat mat4))
  (with-mat4 ((o out-mat) (m mat))
    (psetf o.00 m.00 o.01 m.01 o.02 m.02 o.03 m.03
           o.10 m.10 o.11 m.11 o.12 m.12 o.13 m.13
           o.20 m.20 o.21 m.21 o.22 m.22 o.23 m.23
           o.30 m.30 o.31 m.31 o.32 m.32 o.33 m.33))
  out-mat)

(declaim (inline m4cp))
(defun* (m4cp -> mat4) ((mat mat4))
  (m4cp! (m4zero) mat))

(defun* (m4clamp! -> mat4) ((out-mat mat4) (mat mat4)
                            &key
                            ((min single-float) most-negative-single-float)
                            ((max single-float) most-positive-single-float))
  (with-mat4 ((o out-mat) (m mat))
    (psetf o.00 (clamp m.00 min max) o.01 (clamp m.01 min max)
           o.02 (clamp m.02 min max) o.03 (clamp m.03 min max)
           o.10 (clamp m.10 min max) o.11 (clamp m.11 min max)
           o.12 (clamp m.12 min max) o.13 (clamp m.13 min max)
           o.20 (clamp m.20 min max) o.21 (clamp m.21 min max)
           o.22 (clamp m.22 min max) o.23 (clamp m.23 min max)
           o.30 (clamp m.30 min max) o.31 (clamp m.31 min max)
           o.32 (clamp m.32 min max) o.33 (clamp m.33 min max)))
  out-mat)

(declaim (inline m4clamp))
(defun* (m4clamp -> mat4) ((mat mat4)
                           &key
                           ((min single-float) most-negative-single-float)
                           ((max single-float) most-positive-single-float))
  (m4clamp! (m4zero) mat :min min :max max))

(declaim (inline m4*!))
(defun* (m4*! -> mat4) ((out-mat mat4) (mat-a mat4) (mat-b mat4))
  (with-mat4 ((o out-mat) (a mat-a) (b mat-b))
    (psetf o.00 (+ (* a.00 b.00) (* a.01 b.10) (* a.02 b.20) (* a.03 b.30))
           o.10 (+ (* a.10 b.00) (* a.11 b.10) (* a.12 b.20) (* a.13 b.30))
           o.20 (+ (* a.20 b.00) (* a.21 b.10) (* a.22 b.20) (* a.23 b.30))
           o.30 (+ (* a.30 b.00) (* a.31 b.10) (* a.32 b.20) (* a.33 b.30))
           o.01 (+ (* a.00 b.01) (* a.01 b.11) (* a.02 b.21) (* a.03 b.31))
           o.11 (+ (* a.10 b.01) (* a.11 b.11) (* a.12 b.21) (* a.13 b.31))
           o.21 (+ (* a.20 b.01) (* a.21 b.11) (* a.22 b.21) (* a.23 b.31))
           o.31 (+ (* a.30 b.01) (* a.31 b.11) (* a.32 b.21) (* a.33 b.31))
           o.02 (+ (* a.00 b.02) (* a.01 b.12) (* a.02 b.22) (* a.03 b.32))
           o.12 (+ (* a.10 b.02) (* a.11 b.12) (* a.12 b.22) (* a.13 b.32))
           o.22 (+ (* a.20 b.02) (* a.21 b.12) (* a.22 b.22) (* a.23 b.32))
           o.32 (+ (* a.30 b.02) (* a.31 b.12) (* a.32 b.22) (* a.33 b.32))
           o.03 (+ (* a.00 b.03) (* a.01 b.13) (* a.02 b.23) (* a.03 b.33))
           o.13 (+ (* a.10 b.03) (* a.11 b.13) (* a.12 b.23) (* a.13 b.33))
           o.23 (+ (* a.20 b.03) (* a.21 b.13) (* a.22 b.23) (* a.23 b.33))
           o.33 (+ (* a.30 b.03) (* a.31 b.13) (* a.32 b.23) (* a.33 b.33))))
  out-mat)

(declaim (inline m4*))
(defun* (m4* -> mat4) ((mat-a mat4) (mat-b mat4))
  (m4*! (m4zero) mat-a mat-b))

(declaim (inline m4tr->v3!))
(defun* (m4tr->v3! -> vec3) ((out-vec vec3) (mat mat4))
  (with-vec3 ((o out-vec))
    (with-mat4 ((m mat))
      (psetf o.x m.03 o.y m.13 o.z m.23)))
  out-vec)

(declaim (inline m4tr->v3))
(defun* (m4tr->v3 -> vec3) ((mat mat4))
  (m4tr->v3! (v3zero) mat))

(declaim (inline v3->m4tr!))
(defun* (v3->m4tr! -> mat4) ((mat mat4) (vec vec3))
  (with-mat4 ((m mat))
    (with-vec3 ((v vec))
      (psetf m.03 v.x m.13 v.y m.23 v.z)))
  mat)

(declaim (inline v3->m4tr))
(defun* (v3->m4tr -> mat4) ((mat mat4) (vec vec3))
  (v3->m4tr! (m4cp mat) vec))

(declaim (inline m4tr!))
(defun* (m4tr! -> mat4) ((out-mat mat4) (mat mat4) (vec vec3))
  (m4*! out-mat (v3->m4tr (m4id) vec) mat))

(declaim (inline m4tr))
(defun* (m4tr -> mat4) ((mat mat4) (vec vec3))
  (m4tr! (m4id) mat vec))

(declaim (inline m4cprot!))
(defun* (m4cprot! -> mat4) ((out-mat mat4) (mat mat4))
  (with-mat4 ((o out-mat) (m mat))
    (psetf o.00 m.00 o.01 m.01 o.02 m.02
           o.10 m.10 o.11 m.11 o.12 m.12
           o.20 m.20 o.21 m.21 o.22 m.22))
  out-mat)

(declaim (inline m4cprot))
(defun* (m4cprot -> mat4) ((mat mat4))
  (m4cprot! (m4id) mat))

(declaim (inline m4rot->v3!))
(defun* (m4rot->v3! -> vec3) ((out-vec vec3) (mat mat4) (axis keyword))
  (with-vec3 ((v out-vec))
    (with-mat4 ((m mat))
      (ecase axis
        (:x (psetf v.x m.00 v.y m.10 v.z m.20))
        (:y (psetf v.x m.01 v.y m.11 v.z m.21))
        (:z (psetf v.x m.02 v.y m.12 v.z m.22)))))
  out-vec)

(declaim (inline m4rot->v3))
(defun* (m4rot->v3 -> vec3) ((mat mat4) (axis keyword))
  (m4rot->v3! (v3zero) mat axis))

(declaim (inline v3->m4rot!))
(defun* (v3->m4rot! -> mat4) ((mat mat4) (vec vec3) (axis keyword))
  (with-mat4 ((m mat))
    (with-vec3 ((v vec))
      (ecase axis
        (:x (psetf m.00 v.x m.10 v.y m.20 v.z))
        (:y (psetf m.01 v.x m.11 v.y m.21 v.z))
        (:z (psetf m.02 v.x m.12 v.y m.22 v.z)))))
  mat)

(declaim (inline v3->m4rot))
(defun* (v3->m4rot -> mat4) ((mat mat4) (vec vec3) (axis keyword))
  (v3->m4rot! (m4cp mat) vec axis))

(defun* (m4rot! -> mat4) ((out-mat mat4) (mat mat4) (vec vec3))
  (macrolet ((rotate-angle (angle s c &body body)
               `(when (> (abs ,angle) +epsilon+)
                  (let ((,s (sin ,angle))
                        (,c (cos ,angle)))
                    ,@body
                    (m4*! out-mat out-mat m)))))
    (with-mat4 ((m (m4id)))
      (with-vec3 ((v vec))
        (m4cp! out-mat mat)
        (rotate-angle v.z s c
                      (psetf m.00 c m.01 (- s)
                             m.10 s m.11 c))
        (rotate-angle v.x s c
                      (psetf m.00 1.0f0 m.01 0.0f0 m.02 0.0f0
                             m.10 0.0f0 m.11 c m.12 (- s)
                             m.20 0.0f0 m.21 s m.22 c))
        (rotate-angle v.y s c
                      (psetf m.00 c m.01 0.0f0 m.02 s
                             m.10 0.0f0 m.11 1.0f0 m.12 0.0f0
                             m.20 (- s) m.21 0.0f0 m.22 c)))))
  out-mat)

(declaim (inline m4rot))
(defun* (m4rot -> mat4) ((mat mat4) (vec vec3))
  (m4rot! (m4id) mat vec))

(declaim (inline m4scale->v3!))
(defun* (m4scale->v3! -> vec3) ((out-vec vec3) (mat mat4))
  (with-vec3 ((o out-vec))
    (with-mat4 ((m mat))
      (psetf o.x m.00 o.y m.11 o.z m.22)))
  out-vec)

(declaim (inline m4scale->v3))
(defun* (m4scale->v3 -> vec3) ((mat mat4))
  (m4scale->v3! (v3zero) mat))

(declaim (inline v3->m4scale!))
(defun* (v3->m4scale! -> mat4) ((mat mat4) (vec vec3))
  (with-mat4 ((m mat))
    (with-vec3 ((v vec))
      (psetf m.00 v.x m.11 v.y m.22 v.z)))
  mat)

(declaim (inline v3->m4scale))
(defun* (v3->m4scale -> mat4) ((mat mat4) (vec vec3))
  (v3->m4scale! (m4cp mat) vec))

(declaim (inline m4scale!))
(defun* (m4scale! -> mat4) ((out-mat mat4) (mat mat4) (vec vec3))
  (m4*! out-mat (v3->m4scale (m4id) vec) mat))

(declaim (inline m4scale))
(defun* (m4scale -> mat4) ((mat mat4) (vec vec3))
  (m4scale! (m4id) mat vec))

(declaim (inline m4*v3!))
(defun* (m4*v3! -> vec3) ((out-vec vec3) (mat mat4) (vec vec3))
  (with-vec3 ((v vec) (o out-vec))
    (with-mat4 ((m mat))
      (psetf o.x (+ (* m.00 v.x) (* m.01 v.y) (* m.02 v.z) m.03)
             o.y (+ (* m.10 v.x) (* m.11 v.y) (* m.12 v.z) m.13)
             o.z (+ (* m.20 v.x) (* m.21 v.y) (* m.22 v.z) m.23))))
  out-vec)

(declaim (inline m4*v3))
(defun* (m4*v3 -> vec3) ((mat mat4) (vec vec3))
  (m4*v3! (v3zero) mat vec))

(declaim (inline m4*v4!))
(defun* (m4*v4! -> vec4) ((out-vec vec4) (mat mat4) (vec vec4))
  (with-vec4 ((v vec) (o out-vec))
    (with-mat4 ((m mat))
      (psetf o.x (+ (* m.00 v.x) (* m.01 v.y) (* m.02 v.z) (* m.03 v.w))
             o.y (+ (* m.10 v.x) (* m.11 v.y) (* m.12 v.z) (* m.13 v.w))
             o.z (+ (* m.20 v.x) (* m.21 v.y) (* m.22 v.z) (* m.23 v.w))
             o.w (+ (* m.30 v.x) (* m.31 v.y) (* m.32 v.z) (* m.33 v.w)))))
  out-vec)

(declaim (inline m4*v4))
(defun* (m4*v4 -> vec4) ((mat mat4) (vec vec4))
  (m4*v4! (v4zero) mat vec))

(declaim (inline m4transpose!))
(defun* (m4transpose! -> mat4) ((out-mat mat4) (mat mat4))
  (with-mat4 ((o (m4cp! out-mat mat)))
    (rotatef o.01 o.10)
    (rotatef o.02 o.20)
    (rotatef o.03 o.30)
    (rotatef o.12 o.21)
    (rotatef o.13 o.31)
    (rotatef o.23 o.32))
  out-mat)

(declaim (inline m4transpose))
(defun* (m4transpose -> mat4) ((mat mat4))
  (m4transpose! (m4id) mat))

(defun* (m4orthop -> boolean) ((mat mat4))
  (m4~ (m4* mat (m4transpose mat)) +m4id+))

(defun* (m4orthonormalize! -> mat4) ((out-mat mat4) (mat mat4))
  (let* ((x (m4rot->v3 mat :x))
         (y (m4rot->v3 mat :y))
         (z (m4rot->v3 mat :z)))
    (v3normalize! x x)
    (v3normalize! y (v3- y (v3scale x (v3dot y x))))
    (v3cross! z x y)
    (v3->m4rot! out-mat x :x)
    (v3->m4rot! out-mat y :y)
    (v3->m4rot! out-mat z :z))
  out-mat)

(declaim (inline m4orthonormalize))
(defun* (m4orthonormalize -> mat4) ((mat mat4))
  (m4orthonormalize! (m4id) mat))

(declaim (inline m4trace))
(defun* (m4trace -> single-float) ((mat mat4))
  (with-mat4 ((m mat))
    (+ m.00 m.11 m.22 m.33)))

(declaim (inline m4det))
(defun* (m4det -> single-float) ((mat mat4))
  (with-mat4 ((m mat))
    (- (+ (* m.00 m.11 m.22 m.33)
          (* m.00 m.12 m.23 m.31)
          (* m.00 m.13 m.21 m.32)
          (* m.01 m.10 m.23 m.32)
          (* m.01 m.12 m.20 m.33)
          (* m.01 m.13 m.22 m.30)
          (* m.02 m.10 m.21 m.33)
          (* m.02 m.11 m.23 m.30)
          (* m.02 m.13 m.20 m.31)
          (* m.03 m.10 m.22 m.31)
          (* m.03 m.11 m.20 m.32)
          (* m.03 m.12 m.21 m.30))
       (* m.00 m.11 m.23 m.32)
       (* m.00 m.12 m.21 m.33)
       (* m.00 m.13 m.22 m.31)
       (* m.01 m.10 m.22 m.33)
       (* m.01 m.12 m.23 m.30)
       (* m.01 m.13 m.20 m.32)
       (* m.02 m.10 m.23 m.31)
       (* m.02 m.11 m.20 m.33)
       (* m.02 m.13 m.21 m.30)
       (* m.03 m.10 m.21 m.32)
       (* m.03 m.11 m.22 m.30)
       (* m.03 m.12 m.20 m.31))))

(declaim (inline m4invtortho!))
(defun* (m4invtortho! -> mat4) ((out-mat mat4) (mat mat4))
  (m4cp! out-mat mat)
  (with-mat4 ((o out-mat))
    (rotatef o.10 o.01)
    (rotatef o.20 o.02)
    (rotatef o.21 o.12)
    (psetf o.03 (+ (* o.00 (- o.03)) (* o.01 (- o.13)) (* o.02 (- o.23)))
           o.13 (+ (* o.10 (- o.03)) (* o.11 (- o.13)) (* o.12 (- o.23)))
           o.23 (+ (* o.20 (- o.03)) (* o.21 (- o.13)) (* o.22 (- o.23)))))
  out-mat)

(declaim (inline m4invtortho))
(defun* (m4invtortho -> mat4) ((mat mat4))
  (m4invtortho! (m4id) mat))

(defun* (m4invt! -> mat4) ((out-mat mat4) (mat mat4))
  (let ((determinant (m4det mat)))
    (when (< (abs determinant) +epsilon+)
      (error "Cannot invert a matrix with a determinant of zero."))
    (with-mat4 ((o out-mat) (m mat))
      (psetf o.00 (/ (- (+ (* m.11 m.22 m.33)
                           (* m.12 m.23 m.31)
                           (* m.13 m.21 m.32))
                        (* m.11 m.23 m.32)
                        (* m.12 m.21 m.33)
                        (* m.13 m.22 m.31))
                     determinant)
             o.01 (/ (- (+ (* m.01 m.23 m.32)
                           (* m.02 m.21 m.33)
                           (* m.03 m.22 m.31))
                        (* m.01 m.22 m.33)
                        (* m.02 m.23 m.31)
                        (* m.03 m.21 m.32))
                     determinant)
             o.02 (/ (- (+ (* m.01 m.12 m.33)
                           (* m.02 m.13 m.31)
                           (* m.03 m.11 m.32))
                        (* m.01 m.13 m.32)
                        (* m.02 m.11 m.33)
                        (* m.03 m.12 m.31))
                     determinant)
             o.03 (/ (- (+ (* m.01 m.13 m.22)
                           (* m.02 m.11 m.23)
                           (* m.03 m.12 m.21))
                        (* m.01 m.12 m.23)
                        (* m.02 m.13 m.21)
                        (* m.03 m.11 m.22))
                     determinant)
             o.10 (/ (- (+ (* m.10 m.23 m.32)
                           (* m.12 m.20 m.33)
                           (* m.13 m.22 m.30))
                        (* m.10 m.22 m.33)
                        (* m.12 m.23 m.30)
                        (* m.13 m.20 m.32))
                     determinant)
             o.11 (/ (- (+ (* m.00 m.22 m.33)
                           (* m.02 m.23 m.30)
                           (* m.03 m.20 m.32))
                        (* m.00 m.23 m.32)
                        (* m.02 m.20 m.33)
                        (* m.03 m.22 m.30))
                     determinant)
             o.12 (/ (- (+ (* m.00 m.13 m.32)
                           (* m.02 m.10 m.33)
                           (* m.03 m.12 m.30))
                        (* m.00 m.12 m.33)
                        (* m.02 m.13 m.30)
                        (* m.03 m.10 m.32))
                     determinant)
             o.13 (/ (- (+ (* m.00 m.12 m.23)
                           (* m.02 m.13 m.20)
                           (* m.03 m.10 m.22))
                        (* m.00 m.13 m.22)
                        (* m.02 m.10 m.23)
                        (* m.03 m.12 m.20))
                     determinant)
             o.20 (/ (- (+ (* m.10 m.21 m.33)
                           (* m.11 m.23 m.30)
                           (* m.13 m.20 m.31))
                        (* m.10 m.23 m.31)
                        (* m.11 m.20 m.33)
                        (* m.13 m.21 m.30))
                     determinant)
             o.21 (/ (- (+ (* m.00 m.23 m.31)
                           (* m.01 m.20 m.33)
                           (* m.03 m.21 m.30))
                        (* m.00 m.21 m.33)
                        (* m.01 m.23 m.30)
                        (* m.03 m.20 m.31))
                     determinant)
             o.22 (/ (- (+ (* m.00 m.11 m.33)
                           (* m.01 m.13 m.30)
                           (* m.03 m.10 m.31))
                        (* m.00 m.13 m.31)
                        (* m.01 m.10 m.33)
                        (* m.03 m.11 m.30))
                     determinant)
             o.23 (/ (- (+ (* m.00 m.13 m.21)
                           (* m.01 m.10 m.23)
                           (* m.03 m.11 m.20))
                        (* m.00 m.11 m.23)
                        (* m.01 m.13 m.20)
                        (* m.03 m.10 m.21))
                     determinant)
             o.30 (/ (- (+ (* m.10 m.22 m.31)
                           (* m.11 m.20 m.32)
                           (* m.12 m.21 m.30))
                        (* m.10 m.21 m.32)
                        (* m.11 m.22 m.30)
                        (* m.12 m.20 m.31))
                     determinant)
             o.31 (/ (- (+ (* m.00 m.21 m.32)
                           (* m.01 m.22 m.30)
                           (* m.02 m.20 m.31))
                        (* m.00 m.22 m.31)
                        (* m.01 m.20 m.32)
                        (* m.02 m.21 m.30))
                     determinant)
             o.32 (/ (- (+ (* m.00 m.12 m.31)
                           (* m.01 m.10 m.32)
                           (* m.02 m.11 m.30))
                        (* m.00 m.11 m.32)
                        (* m.01 m.12 m.30)
                        (* m.02 m.10 m.31))
                     determinant)
             o.33 (/ (- (+ (* m.00 m.11 m.22)
                           (* m.01 m.12 m.20)
                           (* m.02 m.10 m.21))
                        (* m.00 m.12 m.21)
                        (* m.01 m.10 m.22)
                        (* m.02 m.11 m.20))
                     determinant))))
  out-mat)

(declaim (inline m4invt))
(defun* (m4invt -> mat4) ((mat mat4))
  (m4invt! (m4id) mat))

(defun* (m4view! -> mat4) ((out-mat mat4) (eye vec3) (target vec3) (up vec3))
  (let ((f (v3zero))
        (s (v3zero))
        (u (v3zero))
        (inv-eye (v3zero))
        (translation (m4id)))
    (with-mat4 ((o (m4id! out-mat)))
      (with-vec3 ((f (v3normalize! f (v3-! f target eye)))
                  (s (v3normalize! s (v3cross! s f up)))
                  (u (v3cross! u s f)))
        (psetf o.00 s.x o.10 u.x o.20 (- f.x)
               o.01 s.y o.11 u.y o.12 (- f.y)
               o.02 s.z o.12 u.z o.22 (- f.z))
        (v3->m4tr! translation (v3neg! inv-eye eye))
        (m4*! out-mat out-mat translation))))
  out-mat)

(declaim (inline m4view))
(defun* (m4view -> mat4) ((eye vec3) (target vec3) (up vec3))
  (m4view! (m4id) eye target up))

(defun* (m4ortho! -> mat4) ((out-mat mat4) (left real) (right real)
                            (bottom real) (top real) (near real) (far real))
  (let ((right-left (float (- right left) 1.0f0))
        (top-bottom (float (- top bottom) 1.0f0))
        (far-near (float (- far near) 1.0f0)))
    (with-mat4 ((m (m4id! out-mat)))
      (psetf m.00 (/ 2.0f0 right-left)
             m.03 (- (/ (+ right left) right-left))
             m.11 (/ 2.0f0 top-bottom)
             m.13 (- (/ (+ top bottom) top-bottom))
             m.22 (/ -2.0f0 far-near)
             m.23 (- (/ (+ far near) far-near))))
    out-mat))

(declaim (inline m4ortho))
(defun* (m4ortho -> mat4) ((left real) (right real) (bottom real) (top real)
                           (near real) (far real))
  (m4ortho! (m4id) left right bottom top near far))

(defun* (m4persp! -> mat4) ((out-mat mat4) (fov real) (aspect real)
                            (near real) (far real))
  (let ((f (float (/ (tan (/ fov 2))) 1.0f0))
        (z (float (- near far) 1.0f0)))
    (with-mat4 ((m (m4zero! out-mat)))
      (psetf m.00 (/ f aspect)
             m.11 f
             m.22 (/ (+ near far) z)
             m.23 (/ (* 2 near far) z)
             m.32 -1.0f0)))
  out-mat)

(declaim (inline m4persp))
(defun* (m4persp -> mat4) ((fov real) (aspect real) (near real) (far real))
  (m4persp! (m4id) fov aspect near far))
