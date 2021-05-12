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
      (,x ,...)))}

