(set-bounds! [-5 -5 -5] [30 30 30])
(set-quality! 8)
(set-resolution! 4)


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

(define 12V-supplier (box [0 0 0] [12V-x 12V-y 12V-z]))
(define amplifier (box [0 0 0] [amp-x amp-y amp-z]))
(define pi4 (box [0 0 0] [pi4-x pi4-y pi4-z]))

(define 12V-cavit (offset amplifier gap))
(define amp-cavit (offset amplifier gap))

(define air-duct-12V
  (intersection (box [0 0 0] [12 12 3]) (gyroid [20 20 20] 3)))

(difference (box [0 0 0] [14 14 14])
  (move amp-cavit [10 (- 7 (* 0.5 amp-y)) 1])
  (move air-duct-12V [1 0 6])
  (move 12V-cavit [10 (- 7 (* 0.5 12V-y)) (+ amp-z 3)]))

