#lang racket

(require "partitions.rkt" (only-in math/number-theory (partitions nr-of-partitions)))

(define (p>? a b)
 (or (null? b)
  (> (car a) (car b))
  (and (= (car a) (car b)) (p>? (cdr a) (cdr b)))))

(define (test n)
 (define str (partitions-stream n))
 (define lst (stream->list str))
 (unless
  (and
   (not (check-duplicates lst equal?))
   (= (length lst) (nr-of-partitions n)) 
   (andmap (λ (p) (and (= (apply + p) n) (apply >= n n p))) lst)
  ; in (apply >= n n p) argument n is duplicated because
  ; >= requires at least 2 arguments and p is empty when n=0.
   (for/and ((p (in-list lst)) (q (in-list (cdr lst)))) (p>? p q)))
  (error 'test "~s ~s" n lst)))

(for/and ((n (in-range 0 30))) (test n))
