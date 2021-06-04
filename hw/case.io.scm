(set-bounds! [-15 -15 -15] [15 15 15])
(set-quality! 8)
(set-resolution! 10)

(define 12V-x 7.9)
(define 12V-y 11.3)
(define 12V-z 3.6)

(define amp-x 11.3)
(define amp-y 11.0)
(define amp-z 5.1)

(define pi4-x 5.6)
(define pi4-y 8.9)
(define pi4-z 2.0)

(define dac-x 3.2)
(define dac-y 2.4)
(define dac-z 0.7)

(define gap 0.1)
(define gyroid-freq 30)
(define wall-thick 1)
(define r-box 0.1)

(define 12V-supplier (box-centered [12V-x 12V-y 12V-z]))
(define amplifier (box-centered [amp-x amp-y amp-z]))
(define pi4 (box-centered [pi4-x pi4-y pi4-z]))
(define dac (box-centered [dac-x dac-y dac-z]))

(define 12V-cavit (offset 12V-supplier gap))
(define amp-cavit (offset amplifier gap))

(define box-z
  (+ wall-thick amp-z wall-thick  12V-z wall-thick))
(define box-x
  (+ wall-thick wall-thick (max amp-x 12V-x pi4-x)))
(define box-y
  (+ wall-thick wall-thick (max amp-y 12V-x pi4-y)))

(define half-box-x (* box-x 0.5))
(define half-box-y (* box-y 0.5))
(define half-box-z (* box-z 0.5))

(define main-body
  (rounded-box
    [(- half-box-x) (- half-box-y) (- half-box-z)]
    [half-box-x half-box-y half-box-z]
    r-box))

(define cover
  (rounded-box
    [(- half-box-x) (- half-box-y) (- half-box-z)]
    [(- wall-thick half-box-x) half-box-y half-box-z]
    r-box))

(define air-duct-12V
  (intersection
    (box-centered [box-x (* wall-thick 4) box-z])
    (gyroid [gyroid-freq gyroid-freq gyroid-freq] 3)))

(difference main-body
  cover
  (move amp-cavit [0 0 (- half-box-z (* amp-z 0.5) wall-thick)])
  (move air-duct-12V [0 3 0])
  (move air-duct-12V [0 -3 0])
  (move 12V-cavit [(+ (- half-box-x) (* 12V-x 0.5) wall-thick) 0 (+ (- half-box-z) (* 12V-z 0.5) wall-thick)]))

(move dac [0 0 10])
(move pi4 [0 0 8.2])
