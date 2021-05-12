(module nvim-gehzu
  {require {fennel aniseed.fennel
            main nvim-gehzu.main
            utils nvim-gehzu.utils}})

(defn go_to_definition [w]
  "Find the definition of the given or currently hovered word and move to it"
  (xpcall
    (fn []
      (let [word (or w (main.get-current-word))
            segs (utils.split-last word ".")]
        (match segs
          [mod ident]
          (main.goto-definition ident mod)
                  

          [ident] 
          (main.goto-definition ident))))
    #(print (.. "Error executing go_to_definition: " (fennel.traceback $1)))))

(defn show_definition [w]
  "Find the definition of the given or currently hovered word show it in a popup"
  (xpcall
    (fn []
      (let [word (or w (main.get-current-word))
            segs (utils.split-last word ".")]
        (match segs
          [mod ident]
          (main.gib-definition ident mod)
                  

          [ident] 
          (main.gib-definition ident))))
    #(print (.. "Error executing show_definition: " (fennel.traceback $1)))))
