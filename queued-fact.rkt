#lang racket/base
(require racket/contract
         "fact.rkt")

(struct queued-fact fact (priority) #:prefab)

(provide
 (contract-out
  [struct queued-fact ([prompt string?]
                       [response string?]
                       [tags (listof symbol?)]
                       [priority number?])]))
