#lang racket/base
(require file/md5
         racket/file
         racket/string)

(let loop ()
  (begin
    (let ([prompt (begin (display "prompt ") (read-line))]
          [response (begin (display "response ") (read-line))]
          [priority (begin (display "priority ") (read-line))]
          [tags (begin (display "tags ") (read-line))])
      (let ([out-port (open-output-file (string-append "queue/" (bytes->string/utf-8 (md5 (string-append prompt response)))))])
        (begin
          (display prompt out-port)
          (newline out-port)
          (display response out-port)
          (newline out-port)
          (display priority out-port)
          (newline out-port)
          (write (map string->symbol (string-split tags)) out-port)
          (newline out-port)
          (close-output-port out-port))))
    (loop)))
