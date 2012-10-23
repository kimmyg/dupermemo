#lang racket
(require web-server/servlet
         web-server/servlet-env)

(define (start request)
  (page/add-facts request))

(define (page/main request)
  (response/xexpr
   '(html
     (head
      (title "Dupermemo"))
     (body
      (p (a ([href "#"]) "learn new facts"))
      (p (a ([href "#"]) "review facts"))
      (p (a ([href "#"]) "add facts"))))))

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
