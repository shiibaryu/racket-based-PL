#lang br/quicklang

(define (read-syntax path port)
  (define src-lines (port->lines port))
  (define src-datums (format-datums '(handle ~a) src-lines))
  (define module-datum `(module stacker-mod "stacker.rkt"
                          ,@src-datums))
  (datum->syntax #f module-datum))
(provide read-syntax)

(define-macro (stacker-module-begin HANDLE-EXPR ...)
  #'(#%module-begin
     HANDLE-EXPR ...
     (display (first stack))))
(provide (rename-out [stacker-module-begin #%module-begin]))

(define stack empty)

(define (stack-pop!)
  (define arg (first stack))
  (set! stack (rest stack))
  arg)

(define (stack-push! arg)
  (set! stack (cons arg stack)))

(define (handle [arg #f])
  (cond
    [(number? arg) (stack-push! arg)]
    [(or (equal? + arg) (equal? * arg))
     (define op-result (arg (stack-pop!) (stack-pop!)))
     (stack-push! op-result)]))
(provide handle)

(provide + *)