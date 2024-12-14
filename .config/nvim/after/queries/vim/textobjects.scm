; extends
(call_expression function: (_) (_) @parameter.inner)
(call_expression function: (_) (_) @parameter.inner "," @_end
 (#make-range! "parameter.outer" @parameter.inner @_end))
(call_expression function: (_) (_) "," @_start (_) @_end
 (#make-range! "parameter.outer" @_start @_end))
