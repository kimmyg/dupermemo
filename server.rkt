#lang racket
(require file/md5
         web-server/dispatch
         web-server/servlet
         web-server/servlet-env
         "fact.rkt")
;"queued-fact.rkt")

(define (page/main request)
  (response/xexpr
   '(html
     (head
      (title "Dupermemo")
      (link ([rel "stylesheet"] [href "/style.css"])))
     (body
      (ul
       (li (a ([href "learn"]) "learn"))
       (li (a ([href "review"]) "review"))
       (li (a ([href "add"]) "add"))
       (li (a ([href "stats"]) "stats")))))))

(define (fact-signature fact)
  (md5 (string-append (fact-prompt fact) (fact-response fact))))

(define (write-fact fact)
  (cond
    [else;(queued-fact? fact)
     (with-output-to-file (string-append "queue/" (bytes->string/utf-8 (fact-signature fact)))
       (λ ()
         (write (fact-prompt fact))
         (write (fact-response fact))
         (write (fact-tags fact))))]))
         ;(write (queued-fact-priority fact))))]))

(define (page/add request)
  (let ([request (send/suspend
                  (λ (k-url)
                    (response/xexpr
                     `(html
                       (head
                        (title "Add Fact")
                        (link ([rel "stylesheet"] [href "/style.css"])))
                       (body
                        (form ([action ,k-url] [method "post"])
                              (p "prompt" (input ([name "prompt"] [type "text"])))
                              (p "response" (input ([name "response"] [type "text"])))
                              (p "priority" (input ([name "priority"] [type "text"])))
                              (p "tags" (input ([name "tags"] [type "text"])))
                              (p
                               (a ([href "/"]) "back to main")
                               (input ([type "submit"] [value "add fact"])))))))))])
    (let ([bindings (request-bindings request)])
      (let ([prompt (extract-binding/single 'prompt bindings)]
            [response (extract-binding/single 'prompt bindings)]
            [tags (extract-binding/single 'prompt bindings)]
            [priority (extract-binding/single 'prompt bindings)])
        (begin
          ;(write-fact (queued-fact prompt response (map string->symbol (string-split tags)) (or (string->number priority) 1)))
          (write-fact (fact prompt response (map string->symbol (string-split tags))))
          (redirect-to "/add"))))))

(define (page/not-found request)
  (response/xexpr
   '(html
     (body
      (p "Not found!")))))

(define-values (app-dispatch app-url)
  (dispatch-rules
   [("") page/main]
   [("add") page/add]))

(serve/servlet app-dispatch
               #:servlet-regexp #rx""
               #:command-line? #t
               #:extra-files-paths (list (build-path "htdocs")))