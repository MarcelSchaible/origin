(in-package :gamebox-math.test)

(setf *default-test-function* #'equalp)

(plan 108)

(diag "identity")
(let ((m (m4id))
      (r (m4 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1)))
  (is m r)
  (is +m4id+ r))

(diag "copy")
(let ((m +m4id+)
      (o (m4zero)))
  (is (m4cp! o m) +m4id+)
  (is o +m4id+)
  (is (m4cp m) +m4id+)
  (isnt m (m4cp m) :test #'eq))

(diag "clamp")
(let ((m (m4 1 -2 3 -4 5 -6 7 -8 9 -10 11 -12 13 -14 15 -16))
      (o (m4zero))
      (r (m4 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1)))
  (is (m4clamp! o m :min -1.0 :max 1.0) r)
  (is o r)
  (is (m4clamp m :min -1.0 :max 1.0) r)
  (is (m4clamp m) m))

(diag "multiplication")
(let ((ma (m4 1 5 9 13 2 6 10 14 3 7 11 15 4 8 12 16))
      (mb (m4 10 50 90 130 20 60 100 140 30 70 110 150 40 80 120 160))
      (mc +m4id+)
      (r (m4 90 202 314 426 100 228 356 484 110 254 398 542 120 280 440 600))
      (rot-x (m4rot +m4id+ (v3 (/ pi 3) 0 0)))
      (rot-y (m4rot +m4id+ (v3 0 (/ pi 4) 0)))
      (rot-xy (m4rot +m4id+ (v3 (/ pi 3) (/ pi 4) 0)))
      (tr1 (m4tr +m4id+ (v3 5 10 15)))
      (tr2 (m4tr +m4id+ (v3 10 20 30)))
      (o (m4zero)))
  (is (m4*! o ma ma) r)
  (is o r)
  (is (m4* ma mc) ma)
  (is (m4* mc ma) ma)
  (is (m4* ma mb) (m4* mb ma))
  (is (m4* rot-x rot-y) rot-xy)
  (isnt (m4* rot-x rot-y) (m4* rot-y rot-x))
  (is (m4tr->v3 (m4* tr1 rot-xy)) (m4tr->v3 tr1))
  (is (m4tr->v3 (m4* tr1 tr2)) (v3 15 30 45))
  (is (m4tr->v3 (m4* tr2 tr1)) (v3 15 30 45)))

(diag "translation conversion")
(let ((ma (m4 1 5 9 13 2 6 10 14 3 7 11 15 4 8 12 16))
      (rm (m4 1 0 0 5 0 1 0 10 0 0 1 15 0 0 0 1))
      (om (m4id))
      (v (v3 5 10 15))
      (rv (v3 13 14 15))
      (ov (v3zero)))
  (is (v3->m4tr! om v) rm)
  (is om rm)
  (is (v3->m4tr om v) rm)
  (is (m4tr->v3! ov ma) rv)
  (is ov rv)
  (is (m4tr->v3 ma) rv))

(diag "translate")
(let ((m (m4rot +m4id+ (v3 (/ pi 3) 0 0)))
      (o (m4id))
      (r (m4 1 0 0 5 0 0.5 -0.86602545 10 0 0.86602545 0.5 15 0 0 0 1))
      (v (v3 5 10 15)))
  (ok (m4~ (m4tr! o m v) r))
  (ok (m4~ o r))
  (is (m4tr->v3 (m4tr +m4id+ v)) v)
  (is (m4tr->v3 (m4tr m v)) v))

(diag "rotation copy")
(let ((ma (m4 1 5 9 13 2 6 10 14 3 7 11 15 4 8 12 16))
      (r (m4 1 5 9 0 2 6 10 0 3 7 11 0 0 0 0 1))
      (o (m4id)))
  (is (m4cprot! o ma) r)
  (is o r)
  (is (m4cprot ma) r))

(diag "rotation conversion")
(let ((m (m4rot +m4id+ (v3 (/ pi 3) 0 0)))
      (rmx +m4id+)
      (rmy (m4 1 0 0 0 0 0.5 0 0 0 0.86602545 1 0 0 0 0 1))
      (rmz (m4 1 0 0 0 0 1 -0.86602545 0 0 0 0.5 0 0 0 0 1))
      (omx (m4id))
      (omy (m4id))
      (omz (m4id))
      (rvx (v3 1 0 0))
      (rvy (v3 0 0.5 0.86602545))
      (rvz (v3 0 -0.86602545 0.5))
      (ovx (v3zero))
      (ovy (v3zero))
      (ovz (v3zero)))
  (is (m4rot->v3! ovx m :x) rvx)
  (ok (v3~ (m4rot->v3! ovy m :y) rvy))
  (ok (v3~ (m4rot->v3! ovz m :z) rvz))
  (ok (v3~ ovx rvx))
  (ok (v3~ ovy rvy))
  (ok (v3~ ovz rvz))
  (is (m4rot->v3 m :x) rvx)
  (ok (v3~ (m4rot->v3 m :y) rvy))
  (ok (v3~ (m4rot->v3 m :z) rvz))
  (is (v3->m4rot! omx rvx :x) rmx)
  (ok (m4~ (v3->m4rot! omy rvy :y) rmy))
  (ok (m4~ (v3->m4rot! omz rvz :z) rmz))
  (ok (m4~ omx rmx))
  (ok (m4~ omy rmy))
  (ok (m4~ omz rmz))
  (is (v3->m4rot +m4id+ rvx :x) rmx)
  (ok (m4~ (v3->m4rot +m4id+ rvy :y) rmy))
  (ok (m4~ (v3->m4rot +m4id+ rvz :z) rmz)))

(diag "rotation")
(let ((omx (m4id))
      (omy (m4id))
      (omz (m4id))
      (rmx (m4 1 0 0 0 0 0.5 -0.86602545 0 0 0.86602545 0.5 0 0 0 0 1))
      (rmy (m4 0.5 0 0.86602545 0 0 1 0 0 -0.86602545 0 0.5 0 0 0 0 1))
      (rmz (m4 0.5 -0.86602545 0 0 0.86602545 0.5 0 0 0 0 1 0 0 0 0 1))
      (vx (v3 (/ pi 3) 0 0))
      (vy (v3 0 (/ pi 3) 0))
      (vz (v3 0 0 (/ pi 3))))
  (ok (m4~ (m4rot! omx +m4id+ vx) rmx))
  (ok (m4~ (m4rot! omy +m4id+ vy) rmy))
  (ok (m4~ (m4rot! omz +m4id+ vz) rmz))
  (ok (m4~ omx rmx))
  (ok (m4~ omy rmy))
  (ok (m4~ omz rmz))
  (ok (m4~ (m4rot +m4id+ vx) rmx))
  (ok (m4~ (m4rot +m4id+ vy) rmy))
  (ok (m4~ (m4rot +m4id+ vz) rmz)))

(diag "scaling")
(let ((m (m4 10 0 0 0 0 20 0 0 0 0 30 0 0 0 0 1))
      (o (m4id))
      (s (m4 10 0 0 0 0 40 0 0 0 0 90 0 0 0 0 1))
      (v (v3 1 2 3)))
  (ok (m4= (m4scale! o m v) s))
  (ok (m4= o s))
  (is (m4scale->v3 (m4scale +m4id+ v)) v))

(diag "matrix * vec3 multiplication")
(let ((m (m4rot +m4id+ (v3 (/ pi 3) 0 0)))
      (v (v3 1 2 3))
      (o (v3zero))
      (rv (v3 1.0 -1.5980763 3.232051)))
  (is (m4*v3! o m v) rv)
  (is o rv)
  (is (m4*v3 m v) rv)
  (is (m4*v3 +m4id+ v) v)
  (is (m4*v3 +m4id+ +v3zero+) +v3zero+))

(diag "matrix * vec4 multiplication")
(let ((m (m4rot +m4id+ (v3 (/ pi 3) 0 0)))
      (v (v4 1 2 3 4))
      (o (v4zero))
      (rv (v4 1.0 -1.5980763 3.232051 4.0)))
  (is (m4*v4! o m v) rv)
  (is o rv)
  (is (m4*v4 m v) rv)
  (is (m4*v4 +m4id+ v) v)
  (is (m4*v4 +m4id+ +v4zero+) +v4zero+))

(diag "transpose")
(let ((m (m4 1 5 9 13 2 6 10 14 3 7 11 15 4 8 12 16))
      (r (m4 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16))
      (o (m4id)))
  (is (m4transpose! o m) r)
  (is o r)
  (is (m4transpose m) r)
  (is (m4transpose +m4id+) +m4id+))

(diag "orthogonality predicate")
(ok (m4orthop (m4rot +m4id+ (v3 pi 0 0))))
(ok (m4orthop (m4rot +m4id+ (v3 (/ pi 2) 0 0))))
(ok (m4orthop (m4rot +m4id+ (v3 (/ pi 3) 0 0))))
(ok (m4orthop (m4rot +m4id+ (v3 (/ pi 4) 0 0))))
(ok (m4orthop (m4rot +m4id+ (v3 (/ pi 5) 0 0))))
(ok (m4orthop (m4rot +m4id+ (v3 (/ pi 6) 0 0))))

(diag "orthogonalization")
(let ((m (m4 0 1 -0.12988785 1.0139829 0 0 0.3997815 -0.027215311 1 0 0.5468181
             0.18567966 0 0 0 0))
      (o (m4id))
      (r (m4 0 1 0 0 0 0 1 0 1 0 0 0 0 0 0 1)))
  (is (m4orthonormalize! o m) r)
  (is o r)
  (is (m4orthonormalize m) r))

(diag "trace")
(is (m4trace (m4zero)) 0)
(is (m4trace +m4id+) 4)
(is (m4trace (m4 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16)) 34)

(diag "determinant")
(is (m4det (m4 1 5 9 13 2 6 10 14 3 7 11 15 4 8 12 16)) 0)
(is (m4det +m4id+) 1)
(is (m4det (m4rot +m4id+ (v3 (/ pi 3) 0 0))) 1)
(is (m4det (m4 1 0 0 0 0 0 1 0 0 1 0 0 0 0 0 1)) -1)

(diag "inversion")
(let ((m (m4rot +m4id+ (v3 (/ pi 3) 0 0)))
      (r (m4rot +m4id+ (v3 (/ pi -3) 0 0)))
      (o (m4id)))
  (is (m4invt! o m) r)
  (is o r)
  (is (m4invt m) r)
  (is (m4invt +m4id+) +m4id+)
  (is-error (m4invt (m4 1 5 9 13 2 6 10 14 3 7 11 15 4 8 12 16)) simple-error))

(diag "view matrix")
(let ((o (m4id))
      (r (m4 -0.7071068 0 -0.7071068 0.7071068 0 1 0 0 0.7071068 0 -0.7071068
             -0.7071068 0 0 0 1)))
  (ok (m4~ (m4view! o (v3 1 0 0) (v3 0 0 1) (v3 0 1 0)) r))
  (ok (m4~ o r))
  (ok (m4~ (m4view (v3 1 0 0) (v3 0 0 1) (v3 0 1 0)) r))
  (is (m4view +v3zero+ +v3zero+ +v3zero+) (m4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)))

(diag "orthographic projection matrix")
(let ((r (m4 0.05 0 0 0 0 0.1 0 0 0 0 -0.002 -1 0 0 0 1))
      (o (m4id)))
  (is (m4ortho! o -20 20 -10 10 0 1000) r)
  (is o r)
  (is (m4ortho -20 20 -10 10 0 1000) r))

(diag "perspective projection matrix")
(let ((r (m4 0.97427857 0 0 0 0 1.7320508 0 0 0 0 -1.002002 -2.002002 0 0 -1 0))
      (o (m4id)))
  (is (m4persp! o (/ pi 3) (/ 16 9) 1 1000) r)
  (is o r)
  (is (m4persp (/ pi 3) (/ 16 9) 1 1000) r))

(finalize)
