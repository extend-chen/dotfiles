; vim:<% eval: printf("ts=%s:sw=%s:sts=%s:tw=%s:%s", &ts, &sw, &sts, &tw, &expandtab ? "et" : "noet") %>:
;;;
;;; <%filename%> - DESCRIPTION HERE
;;; 
;;; Written By: <%author%> <<%email%>>
;;; Last Change: .


(use srfi-1)
(use slib)
(require 'trace)
(use gauche.interactive)

(define (main args)

    (if (pair? (cdr args))
      (print (cons "args:" (cdr args)) "\n"))


    0)
