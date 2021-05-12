(module nvim-gehzu.utils
  {autoload {a aniseed.core
             fennel aniseed.fennel
             nvim aniseed.nvim
             str aniseed.string}})

(defn split-last [s sep]
  "split a string at the last occurrence of a separator"
  (for [i (length s) 1 -1]
    (let [c (s:sub i i)]
      (when (= sep c)
        (let [left (s:sub 1 (- i 1))
              right (s:sub (+ i 1))]
          (lua "return { left, right }")))))
  [s])

(defn find-where [pred xs]
  (each [_ x (ipairs xs)]
    (when (pred x)
      (lua "return x"))))

(defn find-map [f xs]
  (each [_ x (ipairs xs)]
    (let [res (f x)]
      (when (~= nil res)
        (lua "return res")))))

(defn keep-if [f x]
  (when (f x) x))


