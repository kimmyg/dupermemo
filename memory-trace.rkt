#lang racket/base
(require racket/contract)

(provide (contract-out
          [struct memory-trace ((strands (listof strand?)))]
          [struct strand ((first-assimilation assimilation?) (repetitions (listof repetition?)))]
          [struct assimilation ((scores (listof (integer-in 0 5))))]
          [struct repetition ((delay exact-positive-integer?) (score (integer-in 0 5)))]))

(struct memory-trace (strands) #:prefab)

(struct strand (first-assimilation repetitions) #:prefab)

(struct assimilation (scores) #:prefab)

(struct repetition (delay score) #:prefab)

; a fact has a prompt, response, list of tags and priority
; it turns into an assimilating fact with a prompt, response, list of tags, and assimilation
; this turns into an assimilated fact with a prompt, response, list of tags, memory trace, last-day-seen, and appointment
