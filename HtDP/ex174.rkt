;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex174) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)
(require 2htdp/batch-io)

; 1String -> String
; converts the given 1String to a 3-letter numeric String
(check-expect (encode-letter "z") (code1 "z"))
(check-expect (encode-letter "\t")
              (string-append "00" (code1 "\t")))
(check-expect (encode-letter "a")
              (string-append "0" (code1 "a")))
 
(define (encode-letter s)
  (cond
    [(>= (string->int s) 100) (code1 s)]
    [(< (string->int s) 10)
     (string-append "00" (code1 s))]
    [(< (string->int s) 100)
     (string-append "0" (code1 s))]))
 
; 1String -> String
; convert the given 1String into a String
(check-expect (code1 "z") "122")
 
(define (code1 c)
  (number->string (string->int c)))


; list-of-lines -> string
; encode list-of-lines to string
(define (encode-l list1)
    (encode-str (collapse list1)))

; string -> string
;encode
(define (encode-str line)
  (encode-list-of-char (explode line)))

(define (encode-list-of-char l)
  (cond
    ((empty? l) "")
    ((empty? (rest l)) (encode-letter (first l)))
    (else (string-append (encode-letter (first l)) " " (encode-list-of-char (rest l))))))

(define (in? ele l)
  (cond
    ((empty? l) #false)
    (else (or (equal? ele (first l))
        (in? ele (rest l))))))


; list-of-lines -> string
; converts a list of lines into a string
(check-expect (collapse (list (list "line 0") '() (list "line 2")))
              "line 0\n\nline 2\n")
(define (collapse list1)
  (cond
    ((empty? list1) "")
    (else (string-append (cat (first list1)) (collapse (rest list1))))))
; list-of-strings -> string
; converts a list of strings into a string
(check-expect (cat (list "line 0" "line 2"))
              "line 0 line 2\n")
(define (cat line)
  (cond
    ((empty? line) "\n")
    ((empty? (rest line)) (string-append (first line) "\n"))
    (else (string-append (first line) " " (cat (rest line))))))