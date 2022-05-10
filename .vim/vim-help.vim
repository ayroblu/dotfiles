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

function GetPersonalHelpText()
  let l:text = "# <leader>? for this help
    \\n align: <visual> ga=
    \\n Close all buffers: :bufdo bd
    \\n Spelling: <leader>s ]s [s ]S [S
    \\n <insert> <c-u> to undo in insert mode
    \\n <leader>o to open the tagbar
    \\n <leader><leader>f<char> easy motion find (F for reverse)
    \\n <leader>u to open links under the cursor
    \\n :BufDelete to interactively close buffers
    \\n :BufOnly for closing all except current buffer
    \\n <leader>yp for yanking the path
    \\n
    \\n ## Exit
    \\n ZS to save
    \\n ZE to save and quit all
    \\n ZZ to save and quit
    \\n ZX to quit all
    \\n ZC to quit all with exit code
    \\n ZV to force quit all
    \\n
    \\n ## text-obj
    \\n if, af for function
    \\n ci,w for camel case
    \\n cia for argument
    \\n ai,ii,aI, iI for indentation
    \\n
    \\n ## Undo Tree
    \\n g-, g+ to jump between undo tree branches
    \\n :earlier 5s - 5m, 5h, 5d, also :later
    \\n
    \\n ## netrw:
    \\n gn for changing root
    \\n <c-s-6> for returning to writing buffer
    \\n
    \\n ## fzf:
    \\n <leader>t to fzf show files
    \\n <leader><leader>t to fzf show tags
    \\n <leader><leader>r to fzf show tags in current buffer
    \\n `:Rg query` to search with ripgrep
    \\n
    \\n ## repl + code execution:
    \\n <leader>re: Run lines and output (selection or whole file)
    \\n <leader>rw: Run repl and push lines (selection or current line)
    \\n <leader>rq: Close repl
    \\n <leader>rp: Select pane target
    \\n
    \\n ## vim-exchange
    \\n cxc to cancel
    \\n
    \\n ## Abolish
    \\n crs - coerce_snake_case
    \\n crm - MixedCase
    \\n crc - camelCase
    \\n cru - UPPER_CASE
    \\n cr- - dash-case
    \\n cr. - dot.case
    \\n cr<space> - space case
    \\n crt - Title Case
    \\n :%Subvert/facilit{y,ies}/building{,s}/g
    \\n
    \\n ## coc.nvim
    \\n [[ for previous error
    \\n ]] for next error
    \\n gd go definition
    \\n gy go type definition
    \\n gi go implementation
    \\n gr go references
    \\n K Show docs
    \\n <leader>ac action (like imports)
    \\n :call popup_clear()
    \"
  if &filetype ==# 'python'
    let l:shell_command .= "\n## python:
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
    let l:shell_command .= "\n## markdown:
      \\n Generate markdown: :GenTocGFM
      \"
  endif
  return l:text
endfunction

