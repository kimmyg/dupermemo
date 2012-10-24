#lang racket
(require web-server/dispatch
         web-server/servlet
         web-server/servlet-env)

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

(define (page/add request)
  (send/suspend
   (λ (k-url)
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
               (p (input ([type "submit"] [value "add fact"]))))))))))

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
               #:extra-files-paths (list (build-path "/Users/kimballg/Development/dupermemo/htdocs")))