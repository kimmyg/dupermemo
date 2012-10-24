#lang racket/base
(require "fact.rkt"
         racket/contract)

(struct queued-fact fact (priority) #:prefab)

(provide
 (contract-out
  [struct queued-fact ([prompt string?]
                       [response string?]
                       [tags (listof symbol?)]
                       [priority number?])]))
