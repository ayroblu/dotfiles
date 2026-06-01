; ------------------------------------------------------------------ COPY from shared
(class_declaration
  body: (class_body
    .
    "{"
    .
    (_) @_start @_end
    (_)? @_end
    .
    "}"
    (#make-range! "class.inner" @_start @_end))) @class.outer

(class_declaration
  body: (enum_class_body
    .
    "{"
    .
    (_) @_start @_end
    (_)? @_end
    .
    "}"
    (#make-range! "class.inner" @_start @_end))) @class.outer

(function_declaration
  body: (function_body
    .
    "{"
    .
    (_) @_start @_end
    (_)? @_end
    .
    "}"
    (#make-range! "function.inner" @_start @_end))) @function.outer

(lambda_literal
  ("{"
    .
    (_) @_start @_end
    (_)? @_end
    .
    "}"
    (#make-range! "function.inner" @_start @_end))) @function.outer

(call_suffix
  (value_arguments
    .
    "("
    .
    (_) @_start
    (_)? @_end
    .
    ")"
    (#make-range! "call.inner" @_start @_end))) @call.outer

(comment) @comment.outer

(multiline_comment) @comment.outer

; ------------------------------------------------------------------ END COPY


; MyStruct(key: "", value: "")
(value_arguments (value_argument
  (value_argument_label) @assign_left.inner
  value: (_) @assign_right.inner) @assign_left.outer @assign_right.outer)
(value_arguments (value_argument) @parameter.inner)

; func doThing(key: "", value: "")
(function_declaration (parameter
  (simple_identifier) @assign_left.inner
  (user_type) @assign_right.inner) @assign_left.outer @assign_right.outer)
(function_declaration (parameter) @parameter.inner)
(function_declaration
  (parameter) @_start . default_value: (_) @_end
    (#make-range! "parameter.inner" @_start @_end))

; let a: String = ""
(property_declaration
  (value_binding_pattern) @_start name: (_) @_end
    (#make-range! "assign_left.inner" @_start @_end)) @assign_left.outer
(property_declaration
  (value_binding_pattern) @_start (type_annotation) @_end
    (#make-range! "assign_left.inner" @_start @_end))
(property_declaration value: (_) @assign_right.inner) @assign_right.outer
(property_declaration
  (value_binding_pattern) @_start name: (_) . "=" @_end
    (#make-range! "assign_left_outer" @_start @_end)) @assign_left_outer.outer
(property_declaration
  (value_binding_pattern) @_start (type_annotation) . "=" @_end
    (#make-range! "assign_left_outer" @_start @_end)) @assign_left_outer.outer
(property_declaration "=" @_start . value: (_) @_end
  (#make-range! "assign_right_outer" @_start @_end)) @assign_right_outer.outer

; parameter patterns for init (keeping simple inners for now)
(init_declaration (parameter) @parameter.inner)


(array_literal (_) @swappable.inner)

; ========== types
; func f(a: [TYPE])
(parameter name: (_) . name: (_) @type_annotation.inner)
(parameter name: (_) . name: (_) @_start . "..." @_end
  (#make-range! "type_annotation.inner" @_start @_end))

; func f() -> [TYPE]
(function_declaration "->" @_start . (_) @type_annotation.inner
  (#make-range! "type_annotation.outer" @_start @type_annotation.inner))

; let a: [TYPE]
(type_annotation (_) @type_annotation.inner) @type_annotation.outer

