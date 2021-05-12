(module nvim-gehzu.main
  {require {utils utils
            a aniseed.core
            str aniseed.string
            fennel aniseed.fennel
            popup popup
            ts nvim-treesitter}
   require-macros [macros]})



(macro bind-let [binds ...]
  (fn normalize-elem [ident]
    (let [s (tostring ident)]
      (if (= "?" (s:sub 1 1))
        (values false (sym (s:sub 2)))
        (values true ident))))

  (var expr `(do ,...))
  (for [i (- (length binds) 1) 1 -2]
    (let [binding (. binds i)
          value   (. binds (+ i 1))]
      (if
        (sym? binding)
        (let [(should-check name) (normalize-elem binding)]
          (if 
            should-check
            (set expr 
                 `(let [,name ,value] 
                   (if (~= nil ,name) 
                     ,expr 
                     (print ,(.. "Value " (view name) "=" (view value) " was nil")))))

            (set expr `(let [,name ,value] ,expr))))

        (or (list? binding) (table? binding))
        (do
          (var not-nil-list (list `and))
          (var mappings (if (list? binding) (list) []))
          (each [_ sub-binding (ipairs binding)]
            (let [(should-check name) (normalize-elem sub-binding)]
              (table.insert mappings name)
              (when should-check
                (table.insert not-nil-list `(~= nil ,name)))))
          (set expr
               `(let [,mappings ,value] 
                  (if ,not-nil-list 
                    ,expr
                    (print ,(.. "(at least) one of the values of " (view mappings) "=" (view value) " was nil")))))))))
  expr)



(def- query-module-header
  (vim.treesitter.parse_query
    "fennel"
    "(function_call 
      name: (identifier) @module-header-name (#eq? @module-header-name \"module\")
      [(identifier) (field_expression)] @module-name
      (table ((identifier) @import-type
              (table ((identifier) @key (_) @value)*)
             )*
      )
     )"))



(defn read-module-imports-fnl [bufnr]
  "returns two values: the name of the current module, and a map of imports"
  (bind-let [parser   (vim.treesitter.get_parser bufnr "fennel")
             [tstree] (parser:parse)
             tsnode   (tstree:root)]
    (var last-module nil)
    (var modules {})
    (var current-module-name nil)
    (each [id node metadata (query-module-header:iter_captures tsnode bufnr 0 -1)]
      (bind-let [name          (. query-module-header.captures id)
                 (r1 c1 r2 c2) (node:range)
                 node-text     (vim.treesitter.get_node_text node 0)]
        (match name
          :module-name (set current-module-name node-text)
          :key         (set last-module node-text)
          :value       (tset modules last-module node-text))))
    (values current-module-name modules)))

(defn get-current-word []
  (let [col  (. (vim.api.nvim_win_get_cursor 0) 2)
        line (vim.api.nvim_get_current_line)]
    (.. (vim.fn.matchstr (line:sub 1 (+ col 1)) 
                         "\\k*$")
        (string.sub (vim.fn.matchstr (line:sub (+ col 1))
                                     "^\\k*")
                    2))))

(defn pop [text ft]
  "Open a popup with the given text and filetype"
  (var width 20)
  (each [_ line (ipairs text)]
    (set width (math.max width (length line))))
  (let [bufnr (vim.api.nvim_create_buf false true)]
    (vim.api.nvim_buf_set_option bufnr :bufhidden "wipe")
    (vim.api.nvim_buf_set_option bufnr :filetype ft)
    (vim.api.nvim_buf_set_lines bufnr 0 -1 true text)
    (popup.create bufnr {:padding [1 1 1 1] :width width})))


(def all-module-paths
  (do
    (var paths (str.split package.path ";"))
    (each [_ path (ipairs (str.split vim.o.runtimepath ","))]
      (table.insert paths (.. path "/fnl/?.fnl"))
      (table.insert paths (.. path "/fnl/?/init.fnl"))
      (table.insert paths (.. path "/lua/?.lua"))
      (table.insert paths (.. path "/lua/?/init.lua")))
    paths))


(defn file-exists? [path]
  (let [file (io.open path :r)]
    (if (~= nil file)
      (do (io.close file)
        true)
      false)))

(defn find-module-path [module-name]
  (let [module-name (module-name:gsub "%." "/")]
    (utils.find-map #(utils.keep-if file-exists? ($1:gsub "?" module-name))
                    all-module-paths)))


(defn get-filetype [filename]
  "Return the filetype given a files name"
  (match (utils.split-last filename ".")
    [_ :fnl] "fennel"
    [_ :lua] "lua"))

(defn read-file-to-lines [path]
  "read a file into a list of lines"
  (icollect [line _ (io.lines path)] line))

(defn read-module-file [module-name]
  "Given the name of a module, returns two values: 
   the lines of the file that matched a given module
     and the filetype of that module"
  (bind-let [path   (find-module-path module-name)
             ft     (get-filetype path)
             result (read-file-to-lines path)]
    (values result ft)))


;(defn make-def-query [symbol])
  ;(vim.treesitter.parse_query 
    ;"fennel"
    ;(.. "(function_call
          ;name: (identifier) @fn-name (#eq? @fn-name \"defn\")
          ;(identifier) @symbol-name (#contains? @symbol-name \"" symbol "\"))")))
(defn make-def-query [symbol]
  (vim.treesitter.parse_query 
    "fennel"
    (.. "(function_call
          name: (identifier)
          (identifier) @symbol-name (#contains? @symbol-name \"" symbol "\"))")))


(defn create-buf-with [lines visible]
  "create a buffer and fill it with the given lines"
  (assert (a.table? lines) "text must be given as list of lines")
  (let [bufnr (vim.api.nvim_create_buf visible true)]
    (vim.api.nvim_buf_set_lines bufnr 0 -1 true lines)
    bufnr))

(defn find-definition-node-fnl [lines symbol]
  (assert (a.table? lines) "text must be given as list of lines")
  (bind-let [query    (make-def-query symbol)
             bufnr    (create-buf-with lines false)
             parser   (vim.treesitter.get_parser bufnr "fennel")
             [tstree] (parser:parse)
             tsnode   (tstree:root)]
    (each [id node metadata (query:iter_captures tsnode bufnr 0 -1)]
      (let [name (. query.captures id)]
        (when (= name "symbol-name")
          (lua "return node"))))))

(defn find-definition-str-fnl [lines symbol]
  (bind-let [node         (find-definition-node-fnl lines symbol)
             parent       (node:parent)
             (r1 c1 r2 c2) (parent:range)]
    (var code-lines [])
    (for [i (+ r1 1) r2]
      (table.insert code-lines (. lines i)))
    code-lines))



; TODO make this handle absence of mod
(defn goto-definition [word mod]
  (when (not mod)
    (error "Current module goto definition not yet implemented"))
  (bind-let [(cur-mod-name imports)   (read-module-imports-fnl 0)
             actual-mod               (dbg (or (. imports mod) mod))
             module-file-path         (find-module-path actual-mod)
             (module-lines module-ft) (read-module-file actual-mod)
             node                     (find-definition-node-fnl module-lines word)
             parent                  (node:parent)
             bufnr                   (create-buf-with module-lines true)
             (r1 c1 r2 c2)           (parent:range)]
    (vim.api.nvim_buf_set_option bufnr :filetype module-ft)
    (vim.cmd (.. "buffer " bufnr))
    (vim.fn.cursor (+ r1 1) c1)))


(defn gib-definition [word mod]
  (if mod
    (bind-let [(cur-mod-name imports)   (read-module-imports-fnl 0)
               actual-mod               (or (. imports mod) mod)
               (module-lines module-ft) (read-module-file actual-mod)
               definition-lines         (find-definition-str-fnl module-lines word)]
      (pop definition-lines module-ft))
    
    (bind-let [current-file-lines (read-file-to-lines (vim.fn.expand "%"))
               definition-lines (find-definition-str-fnl current-file-lines word)]
      (pop definition-lines vim.bo.filetype))))


(fn _G.gib_def [goto]
  (xpcall
    (fn []
      (let [word (get-current-word)
            segs (utils.split-last word ".")]
        (match segs
          [mod ident]
          (if goto 
            (goto-definition ident mod)
            (gib-definition ident mod))
                  

          [ident] 
          (if goto 
            (goto-definition ident)
            (gib-definition ident)))))
    #(print (fennel.traceback $1))))


  ;(gib-definition "help-thingy" (ident)))

(vim.api.nvim_set_keymap :n :MM ":call v:lua.gib_def(v:false)<CR>" {:noremap true})
(vim.api.nvim_set_keymap :n :MN ":call v:lua.gib_def(v:true)<CR>" {:noremap true})

; vim.api.nvim_buf_get_name
; vim.api.nvim_buf_call
; vim.api.nvim_buf_set_text
; vim.api.nvim_buf_set_var
; vim.fn.bufnr
