#lang sicp
(define (stream-car stream) (car stream))
(define (stream-cdr stream) (force (cdr stream)))



(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))
(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams))
       (apply stream-map
              (cons proc (map stream-cdr argstreams))))))
(define (stream-for-each proc s)
  (if (stream-null? s)
      'done
      (begin (proc (stream-car s))
             (stream-for-each proc (stream-cdr s)))))
(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream
       low
       (stream-enumerate-interval (+ low 1) high))))
(define (stream-filter pred stream)
  (cond ((stream-null? stream) the-empty-stream)
        ((pred (stream-car stream))
         (cons-stream (stream-car stream)
                      (stream-filter
                       pred
                       (stream-cdr stream))))
        (else (stream-filter pred (stream-cdr stream)))))

;display the previous n element of stream s
(define (display-stream-1 s n)
  (stream-for-each (lambda (n) (display-line (stream-ref s n))) (stream-enumerate-interval 0 (- n 1))))
(define (display-stream s)
  (stream-for-each display-line s))
(define (display-line x) (newline) (display x))

(define (add-streams a b)
  (stream-map + a b))

(define ones (cons-stream 1 ones))

(define (integers-starting-from n)
  (cons-stream n (add-streams ones (integers-starting-from n))))

(define integers (integers-starting-from 1))


(define (mul-streams a b)
  (stream-map * a b))

(define (partial-sums s)
  (cons-stream
   (stream-car s)
   (add-streams (stream-cdr s) (partial-sums s))))

(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor))
              stream))

(define (merge s1 s2)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
         (let ((s1car (stream-car s1))
               (s2car (stream-car s2)))
           (cond ((< s1car s2car)
                  (cons-stream
                   s1car
                   (merge (stream-cdr s1) s2)))
                 ((> s1car s2car)
                  (cons-stream
                   s2car
                   (merge s1 (stream-cdr s2))))
                 (else
                  (cons-stream
                   s1car
                   (merge (stream-cdr s1)
                          (stream-cdr s2)))))))))

;ex3.59
;a
(define (integrate-series s)
  (stream-map / s (integers-starting-from 1)))

;b
(define exp-series
  (cons-stream 1 (integrate-series exp-series)))

;e^(ax) series
(define (exp-series-ax a)
  (mul-streams exp-series (stream-map (lambda (n) (expt a n)) (integers-starting-from 0))))

(define cosine-series
  (scale-stream (add-streams (exp-series-ax 0+i) (exp-series-ax 0-i)) (/ 1 2)))

(define sine-series
  (scale-stream (stream-map - (exp-series-ax 0+i) (exp-series-ax 0-i)) (/ 1 0+2i)))