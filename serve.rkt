#lang racket
(require web-server/servlet
         web-server/servlet-env)

(define facts empty)

(define (start request)
  (page/main request))

(define (page/main request)
  (response/xexpr
   '(html
     (head
      (title "Dupermemo"))
     (body
      (p (a ([href "#"]) "learn new facts"))
      (p (a ([href "#"]) "review facts"))
      (p (a ([href "#"]) "add facts"))))))

(define (can-parse-queued-fact? bindings)
  #t)
;  (and (exists-binding? 'prompt bindings)
;       (exists-binding? 'response bindings)
;       (and (exists-binding? 'tags bindings)
;            (for/and ([tag (string-split (extract-binding/single 'tags bindings))])
;              (rexexp-match? #rx"^\\w$" tag)))
;       (and (exists-binding? 'priority bindings)
            
(define (parse-queued-fact bindings)
  (apply queued-fact (for/list ([symbol (list 'prompt 'response)])
                       (extract-binding/single symbol bindings))))
      

(define (fact->id fact)
  (

(if (can-parse-queued-fact? bindings)
    (begin
    (let ([fact (parse-queued-fact bindings)])
      (open-output-file (string-append "queue/" (fact->id fact)

(define (page/add-fact request)
  (send/suspend/dispatch
   (λ (embed/url)
     (response/xexpr
      `(html
        (head
         (title "Add Fact"))
        (body
         (form ([action ,k-url] [method "post"])
               (p "prompt" (input ([type "text"])))
               (p "response" (input ([type "text"])))
               (p "priority" (input ([type "text"])))
               (p "tags" (input ([type "text"])))
               (p (input ([type "submit"] [value "add fact"])))))))))])
(define (page/add-facts request)
  (let ([request2 (send/suspend
                   (λ (k-url)
                     (response/xexpr
                      `(html
                        (head
                         (title "add fact"))
                        (body
                         (form ([action ,k-url] [method "post"])
                               (p "prompt" (input ([type "text"])))
                               (p "response" (input ([type "text"])))
                               (p "priority" (input ([type "text"])))
                               (p "tags" (input ([type "text"])))
                               (p (input ([type "submit"] [value "add fact"])))))))))])
    (begin
      (request-bindings request2)
      
      (redirect-to "/servlets/standalone.rkt"))))

(serve/servlet start
               #:servlet-regexp #rx"\\/"
               #:command-line? #t)
