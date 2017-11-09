#lang racket

(provide partitions-list  partitions-stream  in-partitions
         partitions-list* partitions-stream* in-partitions*
         clear-partition-hashes)

(define-syntax-rule (stream-lazy x)
 (stream-rest (stream-cons 'who-cares? x)))

(define-syntax-rule
 (define-with-hash hash-name form form* . body)
 (begin
  (define hash-name (make-hash))
  (define form . body)
  (define form* (define hash-name (make-hash)) . body)))

(define-with-hash partitions-list-hash (partitions-list n) (partitions-list* n)
 (define (partitions-list n m)
  (cond
   ((zero? n) '(()))
   ((zero? m) '())
   ((= n 1) '((1)))
   ((= m 1) (list (make-list n 1)))
   ((= n m) (cons (list n) (partitions-list n (sub1 n))))
   (else
    (let loop ((m m))
     (hash-ref! partitions-list-hash (list n m)
      (λ ()
       (cond
        ((zero? m) '())
        (else (define n-m (- n m))
         (append
          (map (λ (p) (cons m p)) (partitions-list n-m (min n-m m)))
          (loop (sub1 m)))))))))))
 (partitions-list n n))

(define-with-hash partitions-stream-hash (partitions-stream n) (partitions-stream* n)
 (define (partitions-stream n m)
  (cond
   ((zero? n) '(()))
   ((zero? m) '())
   ((= n 1) '((1)))
   ((= m 1) (list (make-list n 1)))
   ((= n m) (stream-cons (list n) (partitions-stream n (sub1 n))))
   (else
    (let loop ((m m))
     (hash-ref! partitions-stream-hash (list n m)
      (λ ()
       (cond
        ((zero? m) empty-stream)
        (else (define n-m (- n m))
         (stream-append
          (stream-map (λ (p) (cons m p)) (partitions-stream n-m (min n-m m)))
          (stream-lazy (loop (sub1 m))))))))))))
 (partitions-stream n n))

(define (in-partitions n) (in-stream (partitions-stream n)))
(define (in-partitions* n) (in-stream (partitions-stream* n)))

(define (clear-partition-hashes)
 (hash-clear! partitions-list-hash)
 (hash-clear! partitions-stream-hash))
