#lang racket/base
(require racket/contract
         "fact.rkt")

(struct queued-fact fact (priority) #:prefab)

(provide
 (contract-out
  [struct queued-fact ([priority number?])]))
