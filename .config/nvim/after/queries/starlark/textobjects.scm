(argument_list (_) @parameter.inner)
(argument_list (_) @_start "," @_end
 (#make-range! "parameter.outer" @_start @_end))
(argument_list "," @_start (_) @_end
 (#make-range! "parameter.outer" @_start @_end))
