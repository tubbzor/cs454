(module top (lib "eopl.ss" "eopl")
  
  ;; top level module.  Loads all required pieces.
  ;; Run the test suite with (run-all).

  (require "drscheme-init.scm")
  (require "data-structures.scm")  ; for expval constructors
  (require "lang.scm")             ; for scan&parse
  (require "interp.scm")           ; for value-of-program
  (require "tests.scm")            ; for test-list
  
  (provide run run-all)
  
  ;;;;;;;;;;;;;;;; interface to test harness ;;;;;;;;;;;;;;;;
  
  ;; run : String -> ExpVal
  (define run
    (lambda (string)
      (value-of-program (scan&parse string))))
  
  ;; run-all : () -> Unspecified
  ;; runs all the tests in test-list, comparing the results with
  ;; equal-answer?  
  (define run-all
    (lambda ()
      (run-tests! run equal-answer? test-list)))
  
  (define equal-answer?
    (lambda (ans correct-ans)
      (equal? ans (sloppy->expval correct-ans))))
  
  (define sloppy->expval 
    (lambda (sloppy-val)
      (cond
        ((number? sloppy-val) (num-val sloppy-val))
        ((boolean? sloppy-val) (bool-val sloppy-val))
        (else
         (eopl:error 'sloppy->expval 
                     "Can't convert sloppy value to expval: ~s"
                     sloppy-val)))))
    
  ;; run-one : Sym -> ExpVal
  ;; (run-one sym) runs the test whose name is sym
  (define run-one
    (lambda (test-name)
      (let ((the-test (assoc test-name test-list)))
        (cond
          ((assoc test-name test-list)
           => (lambda (test)
                (run (cadr test))))
          (else (eopl:error 'run-one "no such test: ~s" test-name))))))
 
  ;; (run-all)
  
  ;;; My own tests, added by J. Bieman 4/18/2009:
  (define ptest1
    "let f = proc (x) -(x,11)
     in (f (f 77))" )
  
  (define ptest2
    "(proc (f) (f (f 77))
      proc (x) -(x,11))" )
  
  (define ptest3
    "let makemult = proc (maker)
         proc (x)
           if zero? (x)
             then 0
           else -(((maker maker) -(x,1)), -4)
       in let times4 = proc (x) ((makemult makemult) x)
          in (times4 3)" )
  
  (define ptest4
     "let makemult = proc (maker) proc (x) proc(y)
        if zero?(x) 
          then 0
        else -((((maker maker) -(x, 1)) y), -(0, y))
      in let times = proc(x) proc(y)
        (((makemult makemult) x) y)
      in let f = proc(func) proc(num)
        if zero?(num)
          then 1
        else
          ((times ((func func) -(num, 1))) num)
          in let fact = proc (x) ((f f) x)
      in (fact 6)")
  (define fact
     "let makemult = proc (maker) proc (x) proc(y)
        if zero?(x) 
          then 0
        else -((((maker maker) -(x, 1)) y), -(0, y))
        
      in let times = proc(x) proc(y)
        (((makemult makemult) x) y)
        
      in let funct = proc(z) proc(num)
        if zero?(num)
          then 1
        else ((times ((z z) -(num, 1))) num)

      in let fact = proc (x) ((funct funct) x)      
      in (fact 6)")
)