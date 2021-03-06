#lang sicp
(#%require racket/base)

(define (make-account balance password)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (begin
      (set! balance (+ balance amount))
      balance))
  (let ((incorrent-times 0))
    (lambda (p m)
      (if (eqv? p password)
          (begin (set! incorrent-times 0)
                 (cond ((eq? m 'withdraw) withdraw)
                       ((eq? m 'deposit) deposit)
                       (else (error "Unknown request: MAKE-ACCOUNT"
                                    m))))
          (begin (set! incorrent-times (add1 incorrent-times))
                 (if (= incorrent-times 7)
                     (display 'call-the-cops)
                     (error "Incorrect password")))))))


(define acc (make-account 100 'secret-password))
((acc 'secret-password 'withdraw) 40)
((acc 'some-other-password 'deposit) 50)
((acc 'some-other-password 'deposit) 50)
((acc 'some-other-password 'deposit) 50)
((acc 'some-other-password 'deposit) 50)
((acc 'some-other-password 'deposit) 50)
((acc 'some-other-password 'deposit) 50)
((acc 'secret-password 'withdraw) 40)
((acc 'some-other-password 'deposit) 50)