; Adds yaml to gotmpl
((text) @injection.content
 (#set! injection.language "yaml")
 (#set! injection.combined))

; ; No idea but suggested if we use go
; ((action) @injection.content
;  (#set! injection.language "go")
;  (#set! injection.combined))
