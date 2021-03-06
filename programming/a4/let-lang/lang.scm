(module lang

  ;; grammar for the LET language

  (lib "eopl.ss" "eopl")                
  
  (require "drscheme-init.scm")
  
  (provide (all-defined-out))

  ;;;;;;;;;;;;;;;; grammatical specification ;;;;;;;;;;;;;;;;
  
  (define the-lexical-spec
    '((whitespace (whitespace) skip)
      (comment ("%" (arbno (not #\newline))) skip)
      (identifier
       (letter (arbno (or letter digit "_" "-" "?")))
       symbol)
      (number (digit (arbno digit)) number)
      (number ("-" digit (arbno digit)) number)
      ))
  
  (define the-grammar
    '((program (expression) a-program)

      (expression (number) const-exp)
      
      (expression
        ("-" "(" expression "," expression ")")
        diff-exp)
      
      ; 3.6: add minus op
      (expression
       ("minus" "(" expression ")")
       minus-exp)
      
      ; 3.7: add +, *, and /
      (expression
        ("+" "(" expression "," expression ")")
        add-exp)
      (expression
        ("*" "(" expression "," expression ")")
        mult-exp)
      (expression
        ("/" "(" expression "," expression ")")
        div-exp)
      
      (expression
       ("zero?" "(" expression ")")
       zero?-exp)
      
      ; 3.8: add equal?, greater?, and less?
      (expression
       ("equal?" "(" expression "," expression ")")
       equal?-exp)
      
      (expression
       ("greater?" "(" expression "," expression ")")
       greater?-exp)
      
      (expression
       ("less?" "(" expression "," expression ")")
       less?-exp)
      
      ; 3.9
      (expression
       ("null?" "(" expression ")")
       null?-exp)
      (expression
       ("emptylist")
       emptylist-exp)
      
      (expression
       ("cons" "(" expression "," expression ")")
       cons-exp)
      (expression
       ("car" "(" expression ")")
       car-exp)
      (expression
       ("cdr" "(" expression ")")
       cdr-exp)
      
      ; 3.12
      (expression
       ("cond" (arbno expression "==>" expression) "end")
       cond-exp)
      
      ; end assignment code

      (expression
       ("if" expression "then" expression "else" expression)
       if-exp)

      (expression (identifier) var-exp)

      (expression
       ("let" identifier "=" expression "in" expression)
       let-exp)   

      ))
  
  ;;;;;;;;;;;;;;;; sllgen boilerplate ;;;;;;;;;;;;;;;;
  
  (sllgen:make-define-datatypes the-lexical-spec the-grammar)
  
  (define show-the-datatypes
    (lambda () (sllgen:list-define-datatypes the-lexical-spec the-grammar)))
  
  (define scan&parse
    (sllgen:make-string-parser the-lexical-spec the-grammar))
  
  (define just-scan
    (sllgen:make-string-scanner the-lexical-spec the-grammar))
  
  )
