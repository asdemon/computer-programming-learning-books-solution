;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex310) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct no-parent [])
(define-struct child [father mother name date eyes])
(define NP (make-no-parent))
; A FT is one of: 
; – NP
; – (make-child FT FT String N String)


; Oldest Generation:
(define Carl (make-child NP NP "Carl" 1926 "green"))
(define Bettina (make-child NP NP "Bettina" 1926 "green"))

; Middle Generation:
(define Adam (make-child Carl Bettina "Adam" 1950 "hazel"))
(define Dave (make-child Carl Bettina "Dave" 1955 "black"))
(define Eva (make-child Carl Bettina "Eva" 1965 "blue"))
(define Fred (make-child NP NP "Fred" 1966 "pink"))

; Youngest Generation: 
(define Gustav (make-child Fred Eva "Gustav" 1988 "brown"))


;; FT -> ???
;(define (fun-FT a-ftree)
;  (cond
;    [(no-parent? a-ftree) ...]
;    [else (... (child-father a-ftree) ...
;           ... (child-mother a-ftree) ...
;           ... (child-name a-ftree) ...
;           ... (child-date a-ftree) ...
;           ... (child-eyes a-ftree) ...)]))



; FT -> Boolean
; does a-ftree contain a child
; structure with "blue" in the eyes field

(check-expect (blue-eyed-child? Carl) #false)
(check-expect (blue-eyed-child? Gustav) #true)

(define (blue-eyed-child? a-ftree)
  (cond
    [(no-parent? a-ftree) #false]
    [else (or (string=? (child-eyes a-ftree) "blue")
              (blue-eyed-child? (child-father a-ftree))
              (blue-eyed-child? (child-mother a-ftree)))]))


; ex310
; FT -> number
; counts a-ftree contain a child
(check-expect (count-persons? Carl) 1)
(check-expect (count-persons? Gustav) 5)

(define (count-persons? a-ftree)
  (cond
    [(no-parent? a-ftree) 0]
    [else (+  1
              (count-persons? (child-father a-ftree))
              (count-persons? (child-mother a-ftree)))]))

; ex311
; FT year -> number
; counts a-ftree contain a child
(check-expect (sum-age Carl 1936) 11)
(check-expect (sum-age Gustav 1936) 22)

(define (sum-age a-ftree year)
  (cond
    [(no-parent? a-ftree) 0]
    [else (+  (max (- year (child-date a-ftree) -1) 0)
              (sum-age (child-father a-ftree) year)
              (sum-age (child-mother a-ftree) year))]))
(define (average-age a-ftree year)
  (/ (sum-age a-ftree year) (count-persons? a-ftree)))


; ex312
; FT  -> list of eye-colors
; it consumes a family tree and produces a list of all eye colors in the tree.
(check-expect (eye-colors Carl) '("green"))
(define (eye-colors a-ftree)
  (cond
    [(no-parent? a-ftree) '()]
    [else (append (list (child-eyes a-ftree))
                  (eye-colors (child-father a-ftree))
                  (eye-colors (child-mother a-ftree)))]))


; ex313
(check-expect (blue-eyed-child? Eva) #true)
(check-expect (blue-eyed-ancestor? Eva) #false)
(check-expect (blue-eyed-ancestor? Gustav) #true)
(define (blue-eyed-ancestor? a-ftree)
  (cond
    [(no-parent? a-ftree) #false]
    [else
     (or (parent-blue-eyed? a-ftree)
       (blue-eyed-ancestor?
         (child-father a-ftree))
       (blue-eyed-ancestor?
         (child-mother a-ftree)))]))

(define (parent-blue-eyed? a-ftree)
  (cond
    ((and (no-parent? (child-father a-ftree))
          (no-parent? (child-mother a-ftree))) #f)
    ((no-parent? (child-father a-ftree)) (string=? (child-eyes (child-mother a-ftree)) "blue"))
    ((no-parent? (child-mother a-ftree)) (string=? (child-eyes (child-father a-ftree)) "blue"))
    (else (or (string=? (child-eyes (child-mother a-ftree)) "blue")
              (string=? (child-eyes (child-father a-ftree)) "blue")))))
      
