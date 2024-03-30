; extends
; assign_left: const a = something()
; [const a] - inner
; [const a =] - outer
(lexical_declaration
  _ @_start . (variable_declarator name: (_) @_end)
  (#make-range! "assign_left.inner" @_start @_end))
(variable_declaration
  _ @_start . (variable_declarator name: (_) @_end)
  (#make-range! "assign_left.inner" @_start @_end))
(lexical_declaration
  _ @_start . (variable_declarator  _ _ @_end . value: _)
  (#make-range! "assign_left_outer" @_start @_end))
(variable_declaration
  _ @_start . (variable_declarator  _ _ @_end . value: _)
  (#make-range! "assign_left_outer" @_start @_end))

(lexical_declaration
  (variable_declarator value: _ @_start) _ @_end
  (#make-range! "assign_right.inner" @_start @_end))
(variable_declaration
  (variable_declarator value: _ @_start) _ @_end
  (#make-range! "assign_right.inner" @_start @_end))
(lexical_declaration
  (variable_declarator (_) _ @_start value: (_)) _ @_end
  (#make-range! "assign_right_outer" @_start @_end))

; { key: value }
; [key] - left
(object
  (pair
    key: (_) @assign_left.inner @assignment.inner
    value: (_) @assign_right.inner))
(object (pair) @assign_left.outer @assign_right.outer)
(object (pair key: (_) @_start _ @_end value: (_)) @assign_left_outer.outer
  (#make-range! "assign_left_outer" @_start @_end))
(object (pair key: (_) _ @_start value: (_) @_end) @assign_right_outer.outer
  (#make-range! "assign_right_outer" @_start @_end))

(lexical_declaration) @assign.outer @assign_left.outer @assign_right.outer @assign_left_outer.outer @assign_right_outer.outer
(variable_declaration) @assign.outer @assign_left.outer @assign_right.outer @assign_left_outer.outer @assign_right_outer.outer

; import_specifier: import {a, b} from '123';
; [a] - import_specifier
(import_specifier) @swappable.inner

; array items
(array (_) @swappable.inner)

; object items
(object (_) @swappable.inner)

; expressions, just the ones we care about
(binary_expression (_) @expression.inner) @expression.outer
(type_annotation (_) @expression.inner) @expression.outer

; objects (structs)
(object) @struct.inner
(object_pattern) @struct.inner

; function call name
(call_expression function: (_) @call_name.inner) @call_name.outer

; function declaration name
(function_declaration name: (_) @func_decl_name.inner) @func_decl_name.outer
(lexical_declaration (variable_declarator (_) @func_decl_name.inner value: (arrow_function))) @func_decl_name.outer
(variable_declaration (variable_declarator (_) @func_decl_name.inner value: (arrow_function))) @func_decl_name.outer

; exports
(export_statement) @export.outer
