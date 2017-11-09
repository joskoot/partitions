#lang scribble/manual

@(require (for-label "partitions.rkt" racket (only-in typed/racket Sequenceof)))
@(require scribble/core scribble/eval "partitions.rkt" racket)
@(require (for-syntax racket))
@title{Partitions}
@author{Jacob J. A. Koot}
@(defmodule "partitions.rkt"  #:packages ())

@defproc*[#:kind "procedures"
 (((partitions-list (n exact-nonnegative-integer?))
   (listof (listof exact-nonnegative-integer?)))
  ((partitions-stream (n exact-nonnegative-integer?))
   (stream/c (listof exact-nonnegative-integer?)))
  ((in-partitions (n exact-nonnegative-integer?))
   (Sequenceof (listof exact-nonnegative-integer?)))
  ((partitions-list* (n exact-nonnegative-integer?))
   (listof (listof exact-nonnegative-integer?)))
  ((partitions-stream* (n exact-nonnegative-integer?))
   (stream/c (listof exact-nonnegative-integer?)))
  ((in-partitions* (n exact-nonnegative-integer?))
   (Sequenceof (listof exact-nonnegative-integer?))))]{

 Procedures @racket[partitions-list] and @racket[partitions-list*]
 return a list of all partitions of argument @racket[n].
 @(linebreak)
 Procedures @racket[partitions-stream] and @racket[partitions-stream*]
 return a lazy stream of all partitions of argument @racket[n].
 @(linebreak)
 Procedures @racket[in-partitions] and @racket[in-partitions*]
 return a lazy sequence of all partitions of argument @racket[n].
 
 The partitions are produced in decreasing order of the first element.
 Partitions with the same first element, are sorted in the same way for their @racket[cdr]s.}

Examples:

@racket[(partitions-list 6)] @(linebreak)
@racket[(stream->list (partitions-stream 6))] @(linebreak)
@racket[(for/list ((p (in-partitions 6))) p)]

Each one of these three examples produces:

@racketblock0[
 ((6)
  (5 1)
  (4 2)
  (4 1 1)
  (3 3)
  (3 2 1)
  (3 1 1 1)
  (2 2 2)
  (2 2 1 1)
  (2 1 1 1 1)
  (1 1 1 1 1 1))]

Procedures @racket[partitions-list] and @racket[partitions-list*]
use a hash for speeding up by avoiding repeated identical computations.
For procedure @racket[partitions-list] the hash is preserved between successive calls.
This has the advantage that subsequent calls do not have to repeat computations already made during
previous calls.
It has the disadvantage that the hash cannot become garbage collectable as long as procedure
@racket[partitions-list] itself is not garbage collectable.
For procedure @racket[partitions-list*] the hash is not preserved between successive calls.
This has the disadvantage that subsequent calls cannot use results obtained during earlier calls.
It has the advantage that the hash becomes garbage collectable after return from procedure
@racket[partitions-list*].

A similar difference exists between @racket[partitions-stream] and @racket[partitions-stream*].
The hash used by @racket[partitions-stream*] becomes garbage collectable after the end of
the stream has been reached or the stream itself becomes garbage collectable.

The same holds for the sequence produced by @racket[in-partitions*].
It uses @racket[partitions-stream*] for the construction of the sequence.

@defproc[(clear-partition-hashes) void?]{
 Empties the hashes used by @racket[partitions-list],
 @racket[partitions-stream] and @racket[in-partitions].}

Example:

@interaction[
 (require racket "partitions.rkt")
 (void (collect-garbage) (collect-garbage) (collect-garbage))
 (void (time (partitions-list 60)))
 (void (time (partitions-list 60)))
 (void (time (partitions-list 30)))
 (clear-partition-hashes)
 (void (collect-garbage) (collect-garbage) (collect-garbage))
 (code:comment "Now the earlier made computations are lost.")
 (void (time (partitions-list 60)))]

@bold{@larger{@larger{The end}}}

