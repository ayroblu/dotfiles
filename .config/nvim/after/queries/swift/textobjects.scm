; extends
; todo: Not correct for default arguments with nil
(init_declaration
  (parameter) @parameter.inner . ",")

; not last outer param
(init_declaration
  (parameter) @_start . "," @_end
    (#make-range! "parameter.outer" @_start @_end))

; inner: all with non nil default value
(init_declaration
  (parameter) @_start . "=" . default_value: (_) @_end
    (#make-range! "parameter.inner" @_start @_end))

; inner: nil default don't have default_value
(init_declaration
  (parameter) @_start . "=" . _ @_end
    (#eq? @_end "nil")
    (#make-range! "parameter.inner" @_start @_end))

; last param outer
(init_declaration
  "," @_start (parameter) . "=" . default_value: (_) @_end . ")"
    (#make-range! "parameter.outer" @_start @_end))

; specifically nil end
(init_declaration
  "," @_start (parameter) . "=" . _ @_end . ")"
    (#eq? @_end "nil")
    (#make-range! "parameter.outer" @_start @_end))


(array_literal (_) @swappable.inner)
