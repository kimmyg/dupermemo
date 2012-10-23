#lang racket/base
(require racket/contract
         "fact.rkt"
         "memory-trace.rkt")

(struct scheduled-fact fact (trace last next) #:prefab)

(provide
 (contract-out
  [struct scheduled-fact ([trace memory-trace?]
                          [last exact-positive-integer?]
                          [next exact-positive-integer?])]))
