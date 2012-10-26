#lang racket/base
(require racket/contract
         ;"fact.rkt"
         "memory-trace.rkt")

(struct scheduled-fact (prompt response tags trace last next) #:prefab)

(provide
 (contract-out
  [struct scheduled-fact ([prompt string?]
                          [response string?]
                          [tags (listof symbol?)]
                          [trace memory-trace?]
                          [last exact-positive-integer?]
                          [next exact-positive-integer?])]))
