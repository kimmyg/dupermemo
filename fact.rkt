#lang racket/base
(require racket/contract)

(struct fact (prompt response tags) #:prefab)

(provide
 (contract-out
  [struct fact ([prompt string?]
                [response string?]
                [tags (listof symbol?)])]))