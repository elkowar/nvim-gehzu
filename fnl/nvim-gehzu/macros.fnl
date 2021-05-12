{ :dbg
  (fn [x]
    `(let [view# (. (require "aniseed.fennel") :view)]
      (print (.. `,(tostring x) " => " (view# ,x)))
      ,x))
 
  :dbg-call
  (fn [x ...]
    `(do
      (let [a# (require "aniseed.core")]
        (a#.println ,...))
      (,x ,...)))

  :bind-let-opt-error
  (fn [binds should-err ...]
    (var expr (do ...))
    (for [i (- (length binds) 1) 1 -2]
      (let [name  (. binds i)
            value (. binds (+ i 1))]
        (set expr 
             `(let [,name ,value] 
                (if (~= nil ,name) 
                  ,expr
                  ,(when should-err `(print ,(.. "value " (tostring name) " was nil"))))))))
    expr)

  :bind-let-err
  (fn [binds ...]
    `(bind-let-opt-error ,binds true ,...))

  :bind-let
  (fn [binds ...]
    `(bind-let-opt-error ,binds false ,...))}
