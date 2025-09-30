;extends
;https://www.reddit.com/r/neovim/comments/zquevp/how_to_set_aliasshorthand_for_treesitter/
;Reached via: :TSEditQueryUserAfter injections markdown

(fenced_code_block
  ((info_string) @_lang
    (#match? @_lang "(js)"))
  (code_fence_content) @javascript
)
(fenced_code_block
  ((info_string) @_lang
    (#match? @_lang "(ts)"))
  (code_fence_content) @typescript
)
(fenced_code_block
  ((info_string) @_lang
    (#match? @_lang "(zsh)"))
  (code_fence_content) @bash
)
(fenced_code_block
  ((info_string) @_lang
    (#match? @_lang "(sh)"))
  (code_fence_content) @bash
)
