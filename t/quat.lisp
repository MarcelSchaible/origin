(in-package :gamebox-math.test)

(setf *default-test-function* #'equalp)

(plan 82)

(diag "accessors")
(let ((q (q 1 2 3 4)))
  (is (qw q) 1)
  (is (qx q) 2)
  (is (qy q) 3)
  (is (qz q) 4)
  (psetf (qw q) 10.0 (qx q) 20.0 (qy q) 30.0 (qz q) 40.0)
  (is (qw q) 10)
  (is (qx q) 20)
  (is (qy q) 30)
  (is (qz q) 40))

(diag "identity")
(let ((q (qid))
      (r (q 1 0 0 0)))
  (is q r)
  (is +qid+ r))

(diag "equality")
(let ((q1 (q 0.25889468 -0.4580922 0.6231675 0.34003425))
      (q2 (q 1e-8 1e-8 1e-8 1e-8)))
  (ok (q= q1 q1))
  (ok (q~ (q+ q1 q2) q1))
  (ok (q~ q2 (qzero))))

(diag "copy")
(let ((q (q 0.34003425 -0.4920528 0.8754709 0.6535034))
      (o (qzero)))
  (is (qcp! o q) q)
  (is o q)
  (is (qcp q) q)
  (isnt q (qcp q) :test #'eq))

(diag "addition")
(let ((q1 (q -0.11586404 -0.47056317 0.23266816 -0.6098385))
      (q2 (q -0.81111765 0.11399269 -0.24647212 -0.812474))
      (r (q -0.9269817 -0.35657048 -0.013803959 -1.4223125))
      (o (qzero)))
  (is (q+! o q1 q2) r)
  (is o r)
  (is (q+ q1 q2) r))

(diag "subtraction")
(let ((q1 (q 0.1688292 0.5137224 0.83796954 -0.9853494))
      (q2 (q -0.3770373 0.19171429 -0.8571534 0.4451759))
      (r (q 0.5458665 0.32200813 1.695123 -1.4305253))
      (o (qzero)))
  (is (q-! o q1 q2) r)
  (is o r)
  (is (q- q1 q2) r))

(diag "multiplication")
(let ((qa (q 1 2 3 4))
      (qb (q 10 20 30 40))
      (qc +qid+)
      (r (q -280 40 60 80))
      (rot-x (qrot +qid+ (v3 (/ pi 3) 0 0)))
      (rot-y (qrot +qid+ (v3 0 (/ pi 4) 0)))
      (rot-xy (qrot +qid+ (v3 (/ pi 3) (/ pi 4) 0)))
      (o (qzero)))
  (is (q*! o qa qb) r)
  (is o r)
  (is (q* qa qc) qa)
  (is (q* qc qa) qa)
  (is (q* qa qb) (q* qb qa))
  (is (q* rot-x rot-y) rot-xy)
  (isnt (q* rot-x rot-y) (q* rot-y rot-x)))

(diag "scalar product")
(let ((q (q 0.25889468 -0.4580922 0.6231675 0.34003425))
      (r (q -0.12738985 0.22540556 -0.30663133 -0.1673148))
      (o (qzero)))
  (is (qscale! o q -0.4920528) r)
  (is o r)
  (is (qscale q -0.4920528) r))

(diag "cross product")
(let ((q1 (q 0.8660254 0.5 0 0))
      (q2 (q 0.8660254 0 0.5 0))
      (r (q 0.75 0 0.4330127 0.25))
      (o (qzero)))
  (is (qcross! o q1 q2) r)
  (is o r)
  (is (qcross q1 q2) r))

(diag "conjugate")
(let ((q (q 0.8754709 0.6535034 -0.11586404 -0.47056317))
      (r (q 0.8754709 -0.6535034 0.11586404 0.47056317))
      (o (qzero)))
  (is (qconj! o q) r)
  (is o r)
  (is (qconj q) r))

(diag "magnitude")
(is (qmag +qid+) 1)
(is (qmag (q 0.23266816 -0.6098385 -0.81111765 0.11399269)) 1.0473508)

(diag "normalize")
(let ((q (q -0.24647212 -0.812474 0.9715252 0.8300271))
      (r (q -0.16065533 -0.52958643 0.6332591 0.5410279))
      (o (qzero)))
  (is (qnormalize! o q) r)
  (is o r)
  (is (qnormalize q) r)
  (is (qnormalize (q 2 0 0 0)) +qid+))

(diag "negate")
(let ((q (q 0.9858451 0.85955405 0.8707795 -0.36954784))
      (r (q -0.9858451 -0.85955405 -0.8707795 0.36954784))
      (o (qzero)))
  (is (qneg! o q) r)
  (is o r)
  (is (qneg q) r))

(diag "dot product")
(let ((q1 (q -0.55014205 0.66294193 -0.44094658 0.1688292))
      (q2 (q 0.5137224 0.83796954 -0.9853494 -0.3770373)))
  (is (qdot q1 q2) 0.64373636))

(diag "inverse")
(let ((q (q 0.19171429 -0.8571534 0.4451759 0.39651704))
      (r (q 0.17012934 0.76064724 -0.39505392 -0.35187355))
      (o (qzero)))
  (is (qinv! o q) r)
  (is o r)
  (is (qinv q) r))

(diag "rotate")
(let ((oqx (qid))
      (oqy (qid))
      (oqz (qid))
      (rqx (q 0.86602545 0.5 0 0))
      (rqy (q 0.86602545 0 0.5 0))
      (rqz (q 0.86602545 0 0 0.5))
      (vx (v3 (/ pi 3) 0 0))
      (vy (v3 0 (/ pi 3) 0))
      (vz (v3 0 0 (/ pi 3))))
  (ok (q~ (qrot! oqx +qid+ vx) rqx))
  (ok (q~ (qrot! oqy +qid+ vy) rqy))
  (ok (q~ (qrot! oqz +qid+ vz) rqz))
  (ok (q~ oqx rqx))
  (ok (q~ oqy rqy))
  (ok (q~ oqz rqz))
  (ok (q~ (qrot +qid+ vx) rqx))
  (ok (q~ (qrot +qid+ vy) rqy))
  (ok (q~ (qrot +qid+ vz) rqz)))

(diag "vec3 conversion")
(let* ((q (q 0.3628688 0.9540863 0.017128706 0.32979298))
       (r (v3 (qx q) (qy q) (qz q)))
       (o (v3zero)))
  (is (q->v3! o q) r)
  (is o r)
  (is (q->v3 q) r))
(let* ((v (v3 0.2571392 0.19932675 -0.025900126))
       (r (q 0 (v3x v) (v3y v) (v3z v)))
       (o (qzero)))
  (is (v3->q! o v) r)
  (is o r)
  (is (v3->q v) r))

(diag "vec4 conversion")
(let* ((q (q 0.3628688 0.9540863 0.017128706 0.32979298))
       (r (v4 (qw q) (qx q) (qy q) (qz q)))
       (o (v4zero)))
  (is (q->v4! o q) r)
  (is o r)
  (is (q->v4 q) r))
(let* ((v (v4 0.2571392 0.19932675 -0.025900126 0.8267517))
       (r (q (v4x v) (v4y v) (v4z v) (v4w v)))
       (o (qzero)))
  (is (v4->q! o v) r)
  (is o r)
  (is (v4->q v) r))

(diag "matrix conversion")
(let ((q (qrot +qid+ (v3 (/ pi 3) 0 0)))
      (qo (qzero))
      (r (m4 1 0 0 0 0 0.5 -0.86602545 0 0 0.86602545 0.5 0 0 0 0 1))
      (mo (m4id)))
  (ok (m4~ (q->m4! mo q) r))
  (ok (m4~ mo r))
  (ok (m4~ (q->m4 q) r))
  (ok (q~ (m4->q! qo r) q))
  (ok (q~ qo q))
  (ok (q~ (m4->q r) q)))

(diag "spherical linear interpolation")
(let ((q1 (q -0.15230274 0.7359729 -0.27456188 -0.28505945))
      (q2 (q 0.594954 0.030960321 -0.037411213 -0.02747035))
      (r (q -0.5157237 0.4865686 -0.16367096 -0.17777666))
      (o (qzero)))
  (is (qslerp! o q1 q2 0.5) r)
  (is o r)
  (is (qslerp q1 q2 0.5) r))

(finalize)
