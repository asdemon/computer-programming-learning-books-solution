#lang sicp

(define (last l)
  (cond
    ((null? l) '())
    ((null? (cdr l)) (car l))
    (else (last (cdr l)))))

(define (append! x y)
  (set-cdr! (last-pair x) y)
  x)

(define (last-pair x)
  (if (null? (cdr x)) x (last-pair (cdr x))))


(define x (list 'a 'b))
(define y (list 'c 'd))
(define z (append x y))
(define w (append! x y))