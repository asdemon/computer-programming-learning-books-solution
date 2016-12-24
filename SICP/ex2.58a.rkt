;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex2.58) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp) (if (same-variable? exp var) 1 0))
        ((sum? exp) (make-sum (deriv (addend exp) var)
                              (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
          (make-product (multiplier exp)
                        (deriv (multiplicand exp) var))
          (make-product (deriv (multiplier exp) var)
                        (multiplicand exp))))
        ((exponentiation? exp)
         (make-product (make-product (exponent exp) (make-exponentiation (base exp) (make-sum (exponent exp) -1)))
                       (deriv (base exp) var)))
        (else
         (error "unknown expression type: DERIV" exp))))

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (sum? x) (and (cons? x) (eq? (second x) '+)))
(define (addend s) (car s))
(define (augend s)
  (caddr s))

(define (product? x) (and (cons? x) (eq? (second x) '*)))
(define (multiplier p) (car p))
(define (multiplicand p)
  (caddr p))

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2))
         (+ a1 a2))
        (else (list a1 '+ a2))))

(define (=number? exp num) (and (number? exp) (= exp num)))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list m1 '* m2))))

(define (exponentiation? x) (and (cons? x) (eq? (car x) '**)))
(define (base p) (cadr p))
(define (exponent p) (caddr p))
(define (make-exponentiation b n)
  (cond ((=number? n 0) 1)
        ((=number? n 1) b)
        ((and (number? b) (number? n)) (expt b n))
        (else (list '** b n))))