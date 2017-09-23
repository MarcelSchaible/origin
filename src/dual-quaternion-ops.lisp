(in-package :gamebox-math)

(eval-when (:compile-toplevel :load-toplevel)
  (defun* dquat-identity! ((dquat dquat)) (:result dquat :abbrev dqid!)
    "Modify the components of DQUAT to form an identity dual quaternion."
    (with-dquat (d dquat)
      (quat-identity! dr)
      (psetf ddw 0.0 ddx 0.0 ddy 0.0 ddz 0.0))
    dquat)

  (defun* dquat-identity () (:result dquat :abbrev dqid)
    "Create an identity dual quaternion."
    (dquat-identity! (dquat)))

  (define-constant +identity-dual-quaternion+ (dquat-identity) :test #'equalp)
  (define-constant +dqid+ (dquat-identity) :test #'equalp))

(defun* dquat= ((dquat1 dquat) (dquat2 dquat)) (:result boolean :abbrev dq=)
  "Check if the components of DQUAT1 are equal to the components of DQUAT2."
  (with-dquats ((d1 dquat1) (d2 dquat2))
    (and (quat= d1r d2r)
         (quat= d1d d2d))))

(defun* dquat~ ((dquat1 dquat) (dquat2 dquat)
                &key ((tolerance single-float) +epsilon+))
    (:result boolean :abbrev dq~)
  "Check if the components of DQUAT1 are approximately equal to the components of
DQUAT2."
  (with-dquats ((d1 dquat1) (d2 dquat2))
    (and (quat~ d1r d2r :tolerance tolerance)
         (quat~ d1d d2d :tolerance tolerance))))

(defun* dquat-copy! ((out-dquat dquat) (dquat dquat))
    (:result dquat :abbrev dqcp!)
  "Copy the components of DQUAT, storing the result in OUT-DQUAT."
  (with-dquats ((o out-dquat) (d dquat))
    (quat-copy! or dr)
    (quat-copy! od dd))
  out-dquat)

(defun* dquat-copy ((dquat dquat)) (:result dquat :abbrev dqcp)
   "Copy the components of DQUAT, storing the result in a new dual quaternion."
  (dquat-copy! (dquat-identity) dquat))

(defun* dquat+! ((out-dquat dquat) (dquat1 dquat) (dquat2 dquat))
    (:result dquat :abbrev dq+!)
   "Dual quaternion addition of DQUAT1 and DQUAT2, storing the result in
OUT-DQUAT."
  (with-dquats ((o out-dquat) (d1 dquat1) (d2 dquat2))
    (quat+! or d1r d2r)
    (quat+! od d1d d2d))
  out-dquat)

(defun* dquat+ ((dquat1 dquat) (dquat2 dquat)) (:result dquat :abbrev dq+)
  "Dual quaternion addition of DQUAT1 and DQUAT2, storing the result as a new
dual quaternion."
  (dquat+! (dquat-identity) dquat1 dquat2))

(defun* dquat-! ((out-dquat dquat) (dquat1 dquat) (dquat2 dquat))
    (:result dquat :abbrev dq-!)
  "Dual quaternion subtraction of DQUAT2 from DQUAT1, storing the result in
OUT-DQUAT."
  (with-dquats ((o out-dquat) (d1 dquat1) (d2 dquat2))
    (quat-! or d1r d2r)
    (quat-! od d1d d2d))
  out-dquat)

(defun* dquat- ((dquat1 dquat) (dquat2 dquat)) (:result dquat :abbrev dq-)
  "Dual quaternion subtraction of DQUAT2 from DQUAT1, storing the result as a new
dual quaternion."
  (dquat-! (dquat-identity) dquat1 dquat2))

(defun* dquat*! ((out-dquat dquat) (dquat1 dquat) (dquat2 dquat))
    (:result dquat :abbrev dq*!)
  "Dual quaternion multiplication of DQUAT1 and DQUAT2, storing the result in
OUT-DQUAT."
  (let ((dual1 (quat))
        (dual2 (quat)))
    (with-dquats ((o out-dquat) (d1 dquat1) (d2 dquat2))
      (quat*! or d1r d2r)
      (quat*! dual1 d1r d2d)
      (quat*! dual2 d1d d2r)
      (quat+! od dual1 dual2)))
  out-dquat)

(defun* dquat* ((dquat1 dquat) (dquat2 dquat)) (:result dquat :abbrev dq*)
  "Dual quaternion multiplication of DQUAT1 and DQUAT2, storing the result as a
new dual quaternion."
  (dquat*! (dquat-identity) dquat1 dquat2))

(defun* dquat-scale! ((out-dquat dquat) (dquat dquat) (scalar single-float))
    (:result dquat :abbrev dqscale!)
  "Dual quaternion scalar multiplication of DQUAT by SCALAR, storing the result
in OUT-DQUAT."
  (with-dquats ((o out-dquat) (d dquat))
    (quat-scale! or dr scalar)
    (quat-scale! od dd scalar))
  out-dquat)

(defun* dquat-scale ((dquat dquat) (scalar single-float))
    (:result dquat :abbrev dqscale)
  "Dual quaternion scalar multiplication of DQUAT by SCALAR, storing the result
as a new dual quaternion."
  (dquat-scale! (dquat-identity) dquat scalar))

(defun* dquat-conjugate! ((out-dquat dquat) (dquat dquat))
    (:result dquat :abbrev dqconj!)
  "Calculate the conjugate of DQUAT, storing the result in OUT-DQUAT."
  (with-dquats ((o out-dquat) (d dquat))
    (quat-conjugate! or dr)
    (quat-conjugate! od dd))
  out-dquat)

(defun* dquat-conjugate ((dquat dquat)) (:result dquat :abbrev dqconj)
  "Calculate the conjugate of DQUAT, storing the result as a new dual
quaternion."
  (dquat-conjugate! (dquat-identity) dquat))

(defun* dquat-conjugate-full! ((out-dquat dquat) (dquat dquat))
    (:result dquat :abbrev dqconjf!)
  "Calculate the full conjugate of DQUAT, storing the result in OUT-DQUAT."
  (with-dquats ((o out-dquat) (d dquat))
    (quat-conjugate! or dr)
    (psetf odw (- ddw) odx ddx ody ddy odz ddz))
  out-dquat)

(defun* dquat-conjugate-full ((dquat dquat)) (:result dquat :abbrev dqconjf)
  "Calculate the full conjugate of DQUAT, storing the result as a new dual
quaternion."
  (dquat-conjugate-full! (dquat-identity) dquat))

(defun* dquat-apply! ((out-dquat dquat) (dquat1 dquat) (dquat2 dquat))
    (:result dquat :abbrev dqapply!)
  "Apply the sandwich operator to DQUAT1 and DQUAT2, storing the result
OUT-DQUAT."
  (let ((dquat2 (dqnormalize dquat2)))
    (dquat*! out-dquat
             (dquat* dquat2 dquat1)
             (dquat-conjugate-full dquat2))))

(defun* dquat-apply ((dquat1 dquat) (dquat2 dquat))
    (:result dquat :abbrev dqapply)
  "Apply the sandwich operator to DQUAT1 and DQUAT2, storing the result as a new
dual quaternion."
  (dquat-apply! (dquat-identity) dquat1 dquat2))

(defun* dquat-magnitude-squared ((dquat dquat))
    (:result single-float :abbrev dqmagsq)
  "Compute the magnitude (also known as length or Euclidean norm) of the real
part of DQUAT. This results in a squared value, which is cheaper to compute."
  (with-dquat (d dquat)
    (quat-magnitude-squared dr)))

(defun* dquat-magnitude ((dquat dquat)) (:result single-float :abbrev dqmag)
  "Compute the magnitude (also known as length or Euclidean norm) of the real
part of DQUAT."
  (sqrt (dquat-magnitude-squared dquat)))

(defun* dquat-normalize! ((out-dquat dquat) (dquat dquat))
    (:result dquat :abbrev dqnormalize!)
  "Normalize a dual quaternion so its real part has a magnitude of 1.0, storing
the result in OUT-DQUAT."
  (let ((magnitude (dquat-magnitude dquat)))
    (unless (zerop magnitude)
      (dquat-scale! out-dquat dquat (/ magnitude))))
  out-dquat)

(defun* dquat-normalize ((dquat dquat)) (:result dquat :abbrev dqnormalize)
  "Normalize a dual quaternion so its real part has a magnitude of 1.0, storing
the result as a new dual quaternion."
  (dquat-normalize! (dquat-identity) dquat))

(defun* dquat-negate! ((out-dquat dquat) (dquat dquat))
    (:result dquat :abbrev dqneg!)
  "Negate each component of DQUAT, storing the result in OUT-DQUAT."
  (dquat-scale! out-dquat dquat -1.0))

(defun* dquat-negate ((dquat dquat)) (:result dquat :abbrev dqneg)
  "Negate each component of DQUAT, storing the result as a new dual quaternion."
  (dquat-negate! (dquat-identity) dquat))

(defun* dquat-dot ((dquat1 dquat) (dquat2 dquat))
    (:result single-float :abbrev dqdot)
  "Compute the dot product of DQUAT1 and DQUAT2."
  (with-dquats ((d1 dquat1) (d2 dquat2))
    (quat-dot d1r d2r)))

(defun* dquat-inverse! ((out-dquat dquat) (dquat dquat))
    (:result dquat :abbrev dqinv!)
  "Compute the multiplicative inverse of DQUAT, storing the result in OUT-DQUAT."
  (with-dquats ((o out-dquat) (d dquat))
    (quat-inverse! or dr)
    (quat-scale! od (quat* or (quat* dd or)) -1.0))
  out-dquat)

(defun* dquat-inverse ((dquat dquat)) (:result dquat :abbrev dqinv)
  "Compute the multiplicative inverse of DQUAT, storing the result as a new dual
quaternion."
  (dquat-inverse! (dquat-identity) dquat))

(defun* dquat-translation-to-vec! ((out-vec vec) (dquat dquat))
    (:result vec :abbrev dqtr->v!)
  "Decode the translation in the dual part of a dual quaternion, storing the
result in OUT-VEC."
  (let ((s (quat))
        (c (quat)))
    (with-vector (o out-vec)
      (with-dquat (d dquat)
        (quat-scale! s dd 2.0)
        (quat-conjugate! c dr)
        (with-quat (q (quat* s c))
          (setf ox qx oy qy oz qz)))))
  out-vec)

(defun* dquat-translation-to-vec ((dquat dquat)) (:result vec :abbrev dqtr->v)
  "Decode the translation in the dual part of a dual quaternion, storing the
result as a new vector."
  (dquat-translation-to-vec! (vec) dquat))

(defun* dquat-translation-from-vec! ((out-dquat dquat) (vec vec))
    (:result dquat :abbrev v->dqtr!)
  "Encode a translation vector into a dual quaternion, storing the result in
OUT-DQUAT."
  (with-dquat (o (dquat-identity! out-dquat))
    (quat-from-vec! od vec)
    (quat-scale! od od 0.5))
  out-dquat)

(defun* dquat-translation-from-vec ((vec vec)) (:result dquat :abbrev v->dqtr)
  "Encode a translation vector into a dual quaternion, storing the result in a
new dual quaternion."
  (dquat-translation-from-vec! (dquat) vec))

(defun* dquat-translate! ((out-dquat dquat) (dquat dquat) (vec vec))
    (:result dquat :abbrev dqtr!)
  "Translate a quaternion in each of 3 dimensions as specified by VEC, storing
the result in OUT-DQUAT."
  (dquat*! out-dquat (dquat-translation-from-vec vec) dquat))

(defun* dquat-translate ((dquat dquat) (vec vec)) (:result dquat :abbrev dqtr)
  "Translate a quaternion in each of 3 dimensions as specified by VEC, storing
the result as a new dual quaternion."
  (dquat-translate! (dquat-identity) dquat vec))

(defun* dquat-rotation-to-quat! ((out-quat quat) (dquat dquat))
    (:result quat :abbrev dqrot->q!)
  "Get the rotation of a dual quaternion, storing the result in OUT-QUAT."
  (with-dquat (d dquat)
    (quat-copy! out-quat dr))
  out-quat)

(defun* dquat-rotation-to-quat ((dquat dquat)) (:result quat :abbrev dqrot->q)
   "Get the rotation of a dual quaternion, storing the result as a new
quaternion."
  (dquat-rotation-to-quat! (quat) dquat))

(defun* dquat-rotation-from-quat! ((out-dquat dquat) (quat quat))
    (:result dquat :abbrev q->dqrot!)
  "Set the rotation of a dual quaternion from a quaternion, storing the result
in OUT-DQUAT."
  (with-dquat (o out-dquat)
    (qcp! or quat)
    (qzero! od))
  out-dquat)

(defun* dquat-rotation-from-quat ((quat quat)) (:result dquat :abbrev q->dqrot)
  "Set the rotation of a dual quaternion from a quaternion, storing the result
as a new dual quaternion."
  (dquat-rotation-from-quat! (dquat-identity) quat))

(defun* dquat-rotate! ((out-dquat dquat) (dquat dquat) (vec vec))
    (:result dquat :abbrev dqrot!)
  "Rotate a dual quaternion in each of 3 dimensions as specified by the vector of
radians VEC, storing the result in OUT-DQUAT."
  (with-dquats ((o out-dquat) (d dquat))
    (quat-rotate! or dr vec))
  out-dquat)

(defun* dquat-rotate ((dquat dquat) (vec vec)) (:result dquat :abbrev dqrot)
  "Rotate a dual quaternion in each of 3 dimensions as specified by the vector of
radians VEC, storing the result as a new dual quaternion."
  (dquat-rotate! (dquat-identity) dquat vec))

(defun* dquat-to-matrix! ((out-matrix matrix) (dquat dquat))
    (:result matrix :abbrev dq->m!)
  "Convert a dual quaternion to a matrix, storing the result in OUT-MATRIX."
  (with-matrix (o out-matrix)
    (with-dquat (d dquat)
      (with-vector (v (dquat-translation-to-vec dquat))
        (quat-to-matrix! o dr)
        (psetf o03 vx o13 vy o23 vz))))
  out-matrix)

(defun* dquat-to-matrix ((dquat dquat)) (:result matrix :abbrev dq->m)
  "Convert a dual quaternion to a matrix, storing the result as a new matrix."
  (dquat-to-matrix! (matrix-identity) dquat))

(defun* dquat-from-matrix! ((out-dquat dquat) (matrix matrix))
    (:result dquat :abbrev m->dq!)
  "Convert a matrix to a dual quaternion, storing the result in OUT-DQUAT."
  (with-dquat (o out-dquat)
    (let ((rot (dquat-rotation-from-quat
                (quat-from-matrix matrix)))
          (tr (dquat-translation-from-vec
               (matrix-translation-to-vec matrix))))
      (dquat*! out-dquat tr rot)))
  out-dquat)

(defun* dquat-from-matrix ((matrix matrix)) (:result dquat :abbrev m->dq)
  "Convert a matrix to a dual quaternion, storing the result as a new dual
quaternion."
  (dquat-from-matrix! (dquat-identity) matrix))

(defun* dquat-to-screw-parameters ((dquat dquat))
    (:result (values single-float single-float vec vec) :abbrev dq->screw)
  "Convert a dual quaternion to a set of 6 screw parameters."
  (with-dquat (d (dquat-normalize dquat))
    (let* ((angle (* 2 (acos (clamp drw -1 1))))
           (dir (vec-normalize (quat-to-vec dr)))
           (tr (dquat-translation-to-vec dquat))
           (pitch (vec-dot tr dir))
           (moment (vec-scale
                    (vec+ (vec-cross tr dir)
                          (vec-scale (vec- (vec-scale tr (vec-dot dir dir))
                                           (vec-scale dir pitch))
                                     (/ (tan (/ angle 2)))))
                    0.5)))
      (values angle pitch dir moment))))

(defun* dquat-from-screw-parameters! ((out-dquat dquat) (angle single-float)
                                      (pitch single-float) (direction vec)
                                      (moment vec))
    (:result dquat :abbrev screw->dq!)
  "Convert a set of 6 screw parameters to a dual quaternion, storing the result
in OUT-DQUAT."
  (let* ((half-angle (* angle 0.5))
         (c (cos half-angle))
         (s (sin half-angle)))
    (with-vectors ((r (vscale direction s))
                   (d (v+ (vscale moment s) (vscale direction (* pitch c 0.5)))))
      (setf (dq-real out-dquat) (quat c rx ry rz)
            (dq-dual out-dquat) (quat (- (* pitch s 0.5)) dx dy dz))))
  out-dquat)

(defun* dquat-from-screw-parameters ((angle single-float) (pitch single-float)
                                     (direction vec) (moment vec))
    (:result dquat :abbrev screw->dq)
  "Convert a set of 6 screw parameters to a dual quaternion, storing the result
as a new dual quaternion."
  (dquat-from-screw-parameters! (dquat-identity) angle pitch direction moment))

(defun* dquat-sclerp! ((out-dquat dquat) (dquat1 dquat) (dquat2 dquat)
                       (coeff single-float))
    (:result dquat :abbrev dqsclerp!)
  "Perform a screw spherical linear interpolation between DQUAT1 and DQUAT2 by
the interpolation coefficient COEFF, storing the result in OUT-DQUAT."
  (let ((diff (dquat* (dquat-inverse dquat1) dquat2)))
    (multiple-value-bind (angle pitch direction moment) (dq->screw diff)
      (dquat*! out-dquat dquat1 (screw->dq (* angle coeff) (* pitch coeff)
                                           direction moment))))
  out-dquat)

(defun* dquat-sclerp ((dquat1 dquat) (dquat2 dquat) (coeff single-float))
    (:result dquat :abbrev dqsclerp)
  "Perform a screw spherical linear interpolation between DQUAT1 and DQUAT2 by
the interpolation coefficient COEFF, storing the result as a new dual
quaternion."
  (dquat-sclerp! (dquat-identity) dquat1 dquat2 coeff))

(defun* dquat-nlerp! ((out-dquat dquat) (dquat1 dquat) (dquat2 dquat)
                      (coeff single-float))
    (:result dquat :abbrev dqnlerp!)
  "Perform a normalized linear interpolation between DQUAT1 and DQUAT2 by the
interpolation coefficient COEFF, storing the result in OUT-DQUAT."
  (dquat+! out-dquat dquat1 (dquat-scale (dquat- dquat2 dquat1) coeff)))

(defun* dquat-nlerp ((dquat1 dquat) (dquat2 dquat) (coeff single-float))
    (:result dquat :abbrev dqnlerp)
  "Perform a normalized linear interpolation between DQUAT1 and DQUAT2 by the
interpolation coefficient COEFF, storing the result as a new dual quaternion."
  (dquat-nlerp! (dquat-identity) dquat1 dquat2 coeff))
