; extends
; assign_left: const a = something()
; [const a] - inner
; [const a =] - outer
(lexical_declaration
  _ @_start . (variable_declarator name: (_) @_end)
  (#make-range! "assign_left.inner" @_start @_end)) @assign_left.outer
(variable_declaration
  _ @_start . (variable_declarator name: (_) @_end)
  (#make-range! "assign_left.inner" @_start @_end)) @assign_left.outer
(lexical_declaration
  _ @_start . (variable_declarator  _ _ @_end . value: _)
  (#make-range! "assign_left_outer" @_start @_end)) @assign_left_outer.outer
(variable_declaration
  _ @_start . (variable_declarator  _ _ @_end . value: _)
  (#make-range! "assign_left_outer" @_start @_end)) @assign_left_outer.outer
(expression_statement
  (assignment_expression
    left: (_) @assign_left.inner
    right: (_) @assign_right.inner)) @assign_left.outer
(expression_statement
  (assignment_expression
    left: (_) @_start _ @_end)
  (#make-range! "assign_left_outer" @_start @_end)) @assign_left_outer.outer

(lexical_declaration
  (variable_declarator value: _ @_start) _ @_end
  (#make-range! "assign_right.inner" @_start @_end))
(variable_declaration
  (variable_declarator value: _ @_start) _ @_end
  (#make-range! "assign_right.inner" @_start @_end))
(lexical_declaration
  (variable_declarator (_) _ @_start value: (_)) _ @_end
  (#make-range! "assign_right_outer" @_start @_end))
(expression_statement
  (assignment_expression
    _ @_start right: (_) @_end)
  (#make-range! "assign_right_outer" @_start @_end)) @assign_right_outer.outer

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
(object (pair) @assign.outer)

; types
(object_type
  (property_signature
    name: (_) @assign_left.inner @assignment.inner
    type: (_) @assign_right.inner))
(object_type (property_signature) @assign_left.outer @assign_right.outer)
(object_type (property_signature name: (_) @_start _ @_end type: (_)) @assign_left_outer.outer
  (#make-range! "assign_left_outer" @_start @_end))
(object_type (property_signature name: (_) _ @_start type: (_) @_end) @assign_right_outer.outer
  (#make-range! "assign_right_outer" @_start @_end))
(object_type (property_signature) @_start @_end [";" ","]? @_end
  (#make-range! "assign.outer" @_start @_end))

(lexical_declaration) @assign.outer @assign_left.outer @assign_right.outer @assign_left_outer.outer @assign_right_outer.outer
(variable_declaration) @assign.outer @assign_left.outer @assign_right.outer @assign_left_outer.outer @assign_right_outer.outer

; import_specifier: import {a, b} from '123';
; [a] - import_specifier
(import_specifier) @parameter.inner
(named_imports (import_specifier) @parameter.inner)
(named_imports (import_specifier) @parameter.inner "," @_end
 (#make-range! "parameter.outer" @parameter.inner @_end))
(named_imports "," @_start (import_specifier) @_end
 (#make-range! "parameter.outer" @_start @_end))

(required_parameter) @parameter.inner

; const { a, b } = value;
; [a] - param
(object_pattern (_) @parameter.inner)

; array items
(array (_) @parameter.inner)
(array (_) @_start "," @_end
 (#make-range! "parameter.outer" @_start @_end))
(array "," @_start (_) @_end
 (#make-range! "parameter.outer" @_start @_end))

; object items
(object (_) @parameter.inner)

; expressions, just the ones we care about
(binary_expression (_) @expression.inner) @expression.outer
(type_annotation (_) @expression.inner) @expression.outer
(pair_pattern _ @_start value: (_) @expression.inner
  (#make-range! "expression.outer" @_start @expression.inner))

; objects (structs)
(object) @struct.inner
(object_pattern) @struct.inner

; function call name
(call_expression function: (_) @call_name.inner) @call_name.outer

; function declaration name
(function_declaration name: (_) @func_decl_name.inner) @func_decl_name.outer
(lexical_declaration (variable_declarator (_) @func_decl_name.inner value: (arrow_function))) @func_decl_name.outer
(variable_declaration (variable_declarator (_) @func_decl_name.inner value: (arrow_function))) @func_decl_name.outer

; function parameters
(arrow_function parameters: (_) @func_params.inner) @func_params.outer
(function_declaration parameters: (_) @func_params.inner) @func_params.outer

; exports
(export_statement) @export.outer
