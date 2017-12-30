(in-package :gamebox-math)

(declaim (inline v2zero!))
(defun* (v2zero! -> vec2) ((vec vec2))
  (with-vec2 ((v vec))
    (psetf v.x 0.0f0 v.y 0.0f0))
  vec)

(declaim (inline v2zero))
(defun* (v2zero -> vec2) ()
  (v2 0 0))

(declaim (inline v2cp!))
(defun* (v2cp! -> vec2) ((out-vec vec2) (vec vec2))
  (with-vec2 ((o out-vec) (v vec))
    (psetf o.x v.x o.y v.y))
  out-vec)

(declaim (inline v2cp))
(defun* (v2cp -> vec2) ((vec vec2))
  (v2cp! (v2zero) vec))

(declaim (inline v2clamp!))
(defun* (v2clamp! -> vec2) ((out-vec vec2) (vec vec2)
                            &key
                            ((min single-float) most-negative-single-float)
                            ((max single-float) most-positive-single-float))
  (with-vec2 ((o out-vec) (v vec))
    (psetf o.x (clamp v.x min max)
           o.y (clamp v.y min max)))
  out-vec)

(declaim (inline v2clamp))
(defun* (v2clamp -> vec2) ((vec vec2)
                           &key
                           ((min single-float) most-negative-single-float)
                           ((max single-float) most-positive-single-float))
  (v2clamp! (v2zero) vec :min min :max max))

(declaim (inline v2stab!))
(defun* (v2stab! -> vec2) ((out-vec vec2) (vec vec2)
                           &key
                           ((tolerance single-float) +epsilon+))
  (with-vec2 ((o out-vec) (v vec))
    (macrolet ((stabilize (place)
                 `(if (< (abs ,place) tolerance) 0.0f0 ,place)))
      (psetf o.x (stabilize v.x)
             o.y (stabilize v.y))))
  out-vec)

(declaim (inline v2stab))
(defun* (v2stab -> vec2) ((vec vec2) &key ((tolerance single-float) +epsilon+))
  (v2stab! (v2zero) vec :tolerance tolerance))

(declaim (inline v2->list))
(defun* (v2->list -> list) ((vec vec2))
  (with-vec2 ((v vec))
    (list v.x v.y)))

(declaim (inline list->v2))
(defun* (list->v2 -> vec2) ((list list))
  (apply #'v2 list))

(declaim (inline v2=))
(defun* (v2= -> boolean) ((vec-a vec2) (vec-b vec2))
  (with-vec2 ((v1 vec-a) (v2 vec-b))
    (and (= v1.x v2.x)
         (= v1.y v2.y))))

(declaim (inline v2~))
(defun* (v2~ -> boolean) ((vec-a vec2) (vec-b vec2)
                          &key
                          ((tolerance single-float) +epsilon+))
  (with-vec2 ((v1 vec-a) (v2 vec-b))
    (and (~ v1.x v2.x tolerance)
         (~ v1.y v2.y tolerance))))

(declaim (inline v2+!))
(defun* (v2+! -> vec2) ((out-vec vec2) (vec-a vec2) (vec-b vec2))
  (with-vec2 ((o out-vec) (v1 vec-a) (v2 vec-b))
    (psetf o.x (+ v1.x v2.x)
           o.y (+ v1.y v2.y)))
  out-vec)

(declaim (inline v2+))
(defun* (v2+ -> vec2) ((vec-a vec2) (vec-b vec2))
  (v2+! (v2zero) vec-a vec-b))

(declaim (inline v2-!))
(defun* (v2-! -> vec2) ((out-vec vec2) (vec-a vec2) (vec-b vec2))
  (with-vec2 ((o out-vec) (v1 vec-a) (v2 vec-b))
    (psetf o.x (- v1.x v2.x)
           o.y (- v1.y v2.y)))
  out-vec)

(declaim (inline v2-))
(defun* (v2- -> vec2) ((vec-a vec2) (vec-b vec2))
  (v2-! (v2zero) vec-a vec-b))

(declaim (inline v2had*!))
(defun* (v2had*! -> vec2) ((out-vec vec2) (vec-a vec2) (vec-b vec2))
  (with-vec2 ((o out-vec) (v1 vec-a) (v2 vec-b))
    (psetf o.x (* v1.x v2.x)
           o.y (* v1.y v2.y)))
  out-vec)

(declaim (inline v2had*))
(defun* (v2had* -> vec2) ((vec-a vec2) (vec-b vec2))
  (v2had*! (v2zero) vec-a vec-b))

(declaim (inline v2had/!))
(defun* (v2had/! -> vec2) ((out-vec vec2) (vec-a vec2) (vec-b vec2))
  (with-vec2 ((o out-vec) (v1 vec-a) (v2 vec-b))
    (psetf o.x (if (zerop v2.x) 0.0f0 (/ v1.x v2.x))
           o.y (if (zerop v2.y) 0.0f0 (/ v1.y v2.y))))
  out-vec)

(declaim (inline v2had/))
(defun* (v2had/ -> vec2) ((vec-a vec2) (vec-b vec2))
  (v2had/! (v2zero) vec-a vec-b))

(declaim (inline v2scale!))
(defun* (v2scale! -> vec2) ((out-vec vec2) (vec vec2) (scalar single-float))
  (with-vec2 ((o out-vec) (v vec))
    (psetf o.x (* v.x scalar)
           o.y (* v.y scalar)))
  out-vec)

(declaim (inline v2scale))
(defun* (v2scale -> vec2) ((vec vec2) (scalar single-float))
  (v2scale! (v2zero) vec scalar))

(declaim (inline v2dot))
(defun* (v2dot -> single-float) ((vec-a vec2) (vec-b vec2))
  (with-vec2 ((v1 vec-a) (v2 vec-b))
    (+ (* v1.x v2.x) (* v1.y v2.y))))

(declaim (inline v2magsq))
(defun* (v2magsq -> single-float) ((vec vec2))
  (v2dot vec vec))

(declaim (inline v2mag))
(defun* (v2mag -> single-float) ((vec vec2))
  (sqrt (v2magsq vec)))

(declaim (inline v2normalize!))
(defun* (v2normalize! -> vec2) ((out-vec vec2) (vec vec2))
  (let ((magnitude (v2mag vec)))
    (unless (zerop magnitude)
      (v2scale! out-vec vec (/ magnitude))))
  out-vec)

(declaim (inline v2normalize))
(defun* (v2normalize -> vec2) ((vec vec2))
  (v2normalize! (v2zero) vec))

(declaim (inline v2round!))
(defun* (v2round! -> vec2) ((out-vec vec2) (vec vec2))
  (with-vec2 ((o out-vec) (v vec))
    (psetf o.x (fround v.x)
           o.y (fround v.y)))
  out-vec)

(declaim (inline v2round))
(defun* (v2round -> vec2) ((vec vec2))
  (v2round! (v2zero) vec))

(declaim (inline v2abs!))
(defun* (v2abs! -> vec2) ((out-vec vec2) (vec vec2))
  (with-vec2 ((o out-vec) (v vec))
    (psetf o.x (abs v.x)
           o.y (abs v.y)))
  out-vec)

(declaim (inline v2abs))
(defun* (v2abs -> vec2) ((vec vec2))
  (v2abs! (v2zero) vec))

(declaim (inline v2neg!))
(defun* (v2neg! -> vec2) ((out-vec vec2) (vec vec2))
  (v2scale! out-vec vec -1.0f0))

(declaim (inline v2neg))
(defun* (v2neg -> vec2) ((vec vec2))
  (v2neg! (v2zero) vec))

(declaim (inline v2angle))
(defun* (v2angle -> single-float) ((vec-a vec2) (vec-b vec2))
  (let ((dot (v2dot vec-a vec-b))
        (m*m (* (v2mag vec-a) (v2mag vec-b))))
    (if (zerop m*m) 0.0f0 (acos (/ dot m*m)))))

(declaim (inline v2zerop))
(defun* (v2zerop -> boolean) ((vec vec2))
  (with-vec2 ((v vec))
    (and (zerop v.x)
         (zerop v.y))))

(declaim (inline v2dir=))
(defun* (v2dir= -> boolean) ((vec-a vec2) (vec-b vec2))
  (>= (v2dot (v2normalize vec-a) (v2normalize vec-b)) (- 1 +epsilon+)))

(declaim (inline v2lerp!))
(defun* (v2lerp! -> vec2) ((out-vec vec2) (vec-a vec2) (vec-b vec2)
                           (factor single-float))
  (with-vec2 ((o out-vec) (v1 vec-a) (v2 vec-b))
    (psetf o.x (lerp factor v1.x v2.x)
           o.y (lerp factor v1.y v2.y)))
  out-vec)

(declaim (inline v2lerp))
(defun* (v2lerp -> vec2) ((vec-a vec2) (vec-b vec2) (factor single-float))
  (v2lerp! (v2zero) vec-a vec-b factor))

(declaim (inline v2<))
(defun* (v2< -> boolean) ((vec-a vec2) (vec-b vec2))
  (with-vec2 ((v1 vec-a) (v2 vec-b))
    (and (< v1.x v2.x)
         (< v1.y v2.y))))

(declaim (inline v2<=))
(defun* (v2<= -> boolean) ((vec-a vec2) (vec-b vec2))
  (with-vec2 ((v1 vec-a) (v2 vec-b))
    (and (<= v1.x v2.x)
         (<= v1.y v2.y))))

(declaim (inline v2>))
(defun* (v2> -> boolean) ((vec-a vec2) (vec-b vec2))
  (with-vec2 ((v1 vec-a) (v2 vec-b))
    (and (> v1.x v2.x)
         (> v1.y v2.y))))

(declaim (inline v2>=))
(defun* (v2>= -> boolean) ((vec-a vec2) (vec-b vec2))
  (with-vec2 ((v1 vec-a) (v2 vec-b))
    (and (>= v1.x v2.x)
         (>= v1.y v2.y))))

(declaim (inline v2min!))
(defun* (v2min! -> vec2) ((out-vec vec2) (vec-a vec2) (vec-b vec2))
  (with-vec2 ((o out-vec) (v1 vec-a) (v2 vec-b))
    (psetf o.x (min v1.x v2.x)
           o.y (min v1.y v2.y)))
  out-vec)

(declaim (inline v2min))
(defun* (v2min -> vec2) ((vec-a vec2) (vec-b vec2))
  (v2min! (v2zero) vec-a vec-b))

(declaim (inline v2max!))
(defun* (v2max! -> vec2) ((out-vec vec2) (vec-a vec2) (vec-b vec2))
  (with-vec2 ((o out-vec) (v1 vec-a) (v2 vec-b))
    (psetf o.x (max v1.x v2.x)
           o.y (max v1.y v2.y)))
  out-vec)

(declaim (inline v2max))
(defun* (v2max -> vec2) ((vec-a vec2) (vec-b vec2))
  (v2max! (v2zero) vec-a vec-b))
