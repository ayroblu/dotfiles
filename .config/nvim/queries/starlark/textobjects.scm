; extends
(argument_list (_) @parameter.inner)
(argument_list (_) @parameter.inner "," @_end
 (#make-range! "parameter.outer" @parameter.inner @_end))
(argument_list "," @_start (_) @_end
 (#make-range! "parameter.outer" @_start @_end))
