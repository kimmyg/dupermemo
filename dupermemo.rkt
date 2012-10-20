#lang racket/base
(require racket/date
         racket/file
         racket/list
         racket/match)

;; useable first!!!

; use:
; I open the page and want facts for today
; facts are available 20 hours after the last time (good trade between flexibility and rigidity)

; when a fact is introduced into the system, it is soft-scheduled according to priority given to be introduced
; once introduced, it is on a hard schedule
; facts on a hard schedule are still ordered by priority
; if facts with low priority are not reached, their schedule will be adjusted

; fact has:
; prompt response priority tags EF n last-reviewed-day

; a review process has
; the time last reviewed

(define (leap-year? year)
  (and (zero? (remainder year 4)) (not (zero? (remainder year 100)))))

(define (days-in-month month year)
  (match month
    [1 31]
    [2 (if (leap-year? year) 29 28)]
    [3 31]
    [4 30]
    [5 31]
    [6 30]
    [7 31]
    [8 31]
    [9 30]
    [10 31]
    [11 30]
    [12 31]))

(define (days-in-year year)
  (for/fold ([days 0])
    ([month (in-range 1 13)])
    (+ days (days-in-month month year))))

(define (days-since-epoch date)
  (+ (date-day date)
     (for/fold ([days-in-months 0])
       ([month (in-range 1 (date-month date))])
       (+ days-in-months (days-in-month month (date-year date))))
     (for/fold ([days-in-years 0])
       ([year (in-range 1970 (date-year date))])
       (+ days-in-years (days-in-year year)))))

; get n=40 new items from the queue
; repeat them until all have 4 or better (multiple strategies to consider)
; find items in db that are due
; review them according to rules

(struct item (item-path prompt response priority tags) #:transparent)

(struct reviewed-item item (EF n day-last-reviewed) #:transparent)

(define (make-item prompt response priority tags)
  (item prompt response priority tags))

(define (random-unif)
  (exact->inexact (/ (random 4294967087) 4294967087)))

(define (random->bucket s [i 0])
  (if (< s 0.5)
      i
      (random->bucket (sub1 (* s 2)) (add1 i))))


(define (priority-first pr)
  (if (empty? pr)
      #\0
      (first pr)))

(define (priority-rest pr)
  (if (empty? pr)
      pr
      (rest pr)))

(define (priority< pr1 pr2)
  (let ([x (priority-first pr1)]
        [y (priority-first pr2)])
    (match (list x y)
      [(list #\1 #\1) (priority< (priority-rest pr1) (priority-rest pr2))]
      [(list #\1 #\0) #f]
      [(list #\0 #\1) #t]
      [(list #\0 #\0) (if (and (empty? pr1)
                               (empty? pr2))
                          #f
                          (priority< (priority-rest pr1) (priority-rest pr2)))]
      [(list _ _) (error "yikes" #\0 x y)])))

(define (buckets-add buckets item)
  (let ([item-priority (item-priority item)])
    (if (empty? buckets)
      (list (list item-priority item))
      (let ([bucket-priority (first (first buckets))])
        (if (priority< item-priority bucket-priority)
            (cons (first buckets) (buckets-add (rest buckets) item))
            (if (priority< bucket-priority item-priority)
                (list (list item-priority item) buckets)
                (cons (list bucket-priority item (rest (first buckets))) (rest buckets))))))))

(define (buckets-remove-random-in-bucket buckets k)
  (if (empty? buckets)
      (error "empty")
      (if (zero? k)
          (let ([bucket (first buckets)])
            (if (= (length bucket) 2)
                (cons (first (rest bucket)) (rest buckets))
                (let* ([k (add1 (random (sub1 (length bucket))))]
                       [item-and-bucket (move-kth-to-front bucket k)])
                  (cons (first item-and-bucket) (cons (rest item-and-bucket) (rest buckets))))))                  
          (let ([item-and-buckets (buckets-remove-random-in-bucket (rest buckets) (sub1 k))])
            (cons (first item-and-buckets) (cons (first buckets) (rest item-and-buckets)))))))
      
(define (read-item item-path)
  (match (file->lines item-path)
    [(list prompt response priority tags)
     (item item-path prompt response (string->list priority) (read (open-input-string tags)))]))

(define (move-kth-to-front xs k)
  (if (empty? xs)
      (error "list not long enough")
      (if (zero? k)
          xs
          (let ([ys (move-kth-to-front (rest xs) (sub1 k))])
            (cons (first ys) (cons (first xs) (rest ys)))))))

(for/fold ([buckets (for/fold ([buckets empty])
                      ([item (in-directory "queue")])
                      (buckets-add buckets (read-item item)))]
           [items empty])
  ([i 40])
  (if (empty? buckets)
      (values buckets items)
      (let ([item-and-buckets (buckets-remove-random-in-bucket buckets (remainder (random->bucket (random-unif)) (length buckets)))])
        (values (rest item-and-buckets) (cons (first item-and-buckets) items)))))


  
