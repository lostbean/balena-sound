(set-bounds! [-15 -15 -15] [15 15 15])
(set-quality! 6)
(set-resolution! 10)

(define front-x-wire-space 1.3)
(define back-x-wire-space 4.6)

(define 12V-x (+ 11.3 front-x-wire-space ))
(define 12V-y 7.9)
(define 12V-z 3.6)

(define amp-x (+ 11.0 front-x-wire-space))
(define amp-y 11.3)
(define amp-z 5.1)

(define pi4-x 6)
(define pi4-y 8.9)
(define pi4-z 3.0)

(define dac-x 3.2)
(define dac-y 2.4)
(define dac-z 0.7)

(define gap 0.1)
(define gyroid-freq 52)
(define wall-thick 0.6)
(define r-box 0.1)

(define box-z
  (+ (* 2 wall-thick) amp-z 12V-z wall-thick))
(define box-x
  (+ (* 2 wall-thick) (max amp-x (+ 12V-x pi4-x gap))))
(define box-y
  (+ wall-thick wall-thick (max amp-y 12V-y pi4-y)))

(define amplifier
  (union
    (move
      (rotate-y
        (cylinder-z (* amp-z 0.4) (- box-x amp-x))
      (/ pi -2))
    [6 0])
    (box-centered [amp-x amp-y amp-z])))
(define 12V-supplier
  (box-centered [12V-x 12V-y 12V-z]))
(define pi4
  (box-centered [pi4-x pi4-y pi4-z]))
(define dac
  (box-centered [dac-x dac-y dac-z]))

(define 12V-cavit (offset 12V-supplier gap))
(define amp-cavit (offset amplifier gap))
(define pi4-cavit (offset pi4 gap))

(define half-box-x (* box-x 0.5))
(define half-box-y (* box-y 0.5))
(define half-box-z (* box-z 0.5))

(define main-body
  (rounded-box
    [(- half-box-x) (- half-box-y) (- half-box-z)]
    [half-box-x half-box-y half-box-z]
    r-box))

(define front-cover
  (rounded-box
    [(- half-box-x) (- half-box-y) (- half-box-z)]
    [(- wall-thick half-box-x) half-box-y half-box-z]
    r-box))

(define back-cover
  (rounded-box
    [(- half-box-x wall-thick) (- half-box-y) (- half-box-z)]
    [half-box-x half-box-y half-box-z]
    r-box))

(define air-duct
  (intersection
    (move (rotate-x (cylinder 3.5 box-y) (/ pi 2)) [0 (/ box-y 2) 1])
    (gyroid [gyroid-freq gyroid-freq gyroid-freq] 3)))

(define wire-duct
  (let*
    ((wire-d 0.4)
     (house-x 5)
     (house-y 1.4)
     (house-z 3)
     (loft-x  2)
     (x (/ (- box-x (* 2 wall-thick) (* 2 house-x) (* 2 loft-x)) 2))
     (wire-z-shift (- (/ house-z 2) wire-d))
     (couple (loft
      (move
        (rectangle-centered-exact [house-y house-z]) [(- wire-d (/ house-y 2)) 0])
      (move
        (circle wire-d) [0 wire-z-shift])
      0
      loft-x)))
  (symmetric-x (union
    (move (rotate-z (rotate-x couple (/ pi -2)) (/ pi 2)) [(+ x loft-x) 0])
    (move (box-centered [house-x house-y house-z]) [(+ x loft-x (/ house-x 2)) (- wire-d (/ house-y 2))])
    (move (rotate-x (cylinder-z wire-d x) (/ pi 2)) [(+ x loft-x house-x) 0])
    (move (rotate-y (cylinder-z wire-d x) (/ pi -2)) [0 0 (- wire-z-shift)])))))

(define wire-duct-amp
  (let
    ((x (/ (- box-z wall-thick wall-thick) 2))
     (wire-d 0.5)
     (house-d 1.65)
     (house-len 4))
  (union
    (move (rotate-y (cylinder-z house-d house-len) (/ pi -2)) [(- wire-d) 0])
    (rotate-x (cylinder-z wire-d x) (/ pi 2))
    (move (cylinder-z wire-d x) [0 0 (- x)])
    (move (sphere house-d) [(- wire-d) 0]))))

(define ima-r 0.255)
(define ima-h 0.22)

(define ima-hole
  (rotate-y (cylinder ima-r ima-h) (/ pi 2)))

(define sound-case
  (let (
    (x-12v-pos (+ (- half-box-x) (* 12V-x 0.5) wall-thick))
    (x-amp-pos (+ (- half-box-x) (* amp-x 0.5) wall-thick))
    (x-pi4-pos (- half-box-x (* pi4-x 0.5) wall-thick))

    (z-12v-pos (+ (- half-box-z) (* 12V-z 0.5) wall-thick))
    (z-amp-pos (- half-box-z (* amp-z 0.5) wall-thick))
    (half-core-box-x (- wall-thick half-box-x))
    (lower-wire-z (- (* 4 wall-thick) half-box-z))
    (wire-y (- half-box-y wall-thick )))
  (difference main-body
    front-cover
    back-cover
    (move amp-cavit [x-amp-pos 0 z-amp-pos])
    (move air-duct [-0.7 0 -1])
    (move pi4-cavit [x-pi4-pos 0 z-12v-pos])
    (move 12V-cavit [x-12v-pos 0 z-12v-pos])
    (symmetric-y
      (move wire-duct [0 wire-y lower-wire-z]))
    (symmetric-y 
      (move wire-duct-amp [(- half-box-x wall-thick 3.5) 4 2]))
    ;; imãs
    (symmetric-x
      (symmetric-z
        (symmetric-y
          (move ima-hole [
            (- half-box-x wall-thick (- (/ ima-h 2)))
            (- half-box-y wall-thick -0.2)
            (- half-box-z wall-thick -0.2)])))))))

sound-case
;wire-duct

