" ---------------------------------------- Personal Help
function ShowPersonalHelp()
  let l:text = GetPersonalHelpText()

  vnew
  0pu=l:text
  setlocal buftype=nowrite
  setlocal nomodifiable
  set ft=markdown
  execute 0
endfunction

let s:dir = expand('<sfile>:p:h')
function GetPersonalHelpText()
  let l:text = join(readfile(s:dir . "/help.md"), "\n")
  if &filetype ==# 'python'
    let l:text .= "\n\n## python:
      \\n <leader>r to rename
      \\n <c-}> to go to definition
      \\n K to show documentation
      \\n <leader>i to try auto imports
      \\n <leader>n to show usages (<leader>b to close)
      \\n <leader>g to go to assignment (low use)
      \\n :AFlake to remove unused imports (requires autoflake)
      \"
  endif
  if &filetype ==# 'markdown'
    let l:text .= "\n\n## markdown:
      \\n Generate markdown: :GenTocGFM
      \"
  endif
  return l:text
endfunction

