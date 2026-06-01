; extends

; func a(p1 string, p2 int) {
(parameter_list (parameter_declaration) @parameter.inner)
; func a(p1 string, rest ...int) {
(parameter_list (variadic_parameter_declaration) @parameter.inner)
; f(a1, a2) {
(argument_list (_) @parameter.inner)
; const (a = 0\n  b = 1)
(const_declaration (const_spec) @swappable.inner)
; var (a = 0\n  b = 1)
(var_spec_list (var_spec) @swappable.inner)
; mystruct{a: 1, b: 2}
(keyed_element) @parameter.inner
; mystruct{a, b}
(composite_literal (literal_value (literal_element) @parameter.inner))
; generally applies for example a, b = b, a
(expression_list (_) @swappable.inner)
; type ex[A any, B any] struct {
(type_parameter_list (type_parameter_declaration) @parameter.inner)
; ex[string, int]{}
(type_arguments (type_elem) @parameter.inner)

; don't need to swap imports, always one line each, no methods / destructuring etc
; (import_spec_list (import_spec) @swappable.inner)
; same with field declarations
; (field_declaration_list (field_declaration) @parameter.inner)