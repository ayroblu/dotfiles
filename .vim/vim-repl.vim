" Based on https://github.com/NLKNguyen/pipe-mysql.vim/blob/master/plugin/pipe-mysql.vim
autocmd FileType javascript,javascriptreact let b:repl_shell_command = 'node'
autocmd FileType javascript,javascriptreact let b:repl_startup_commands = [
      \'.load ' . expand('%'),
      \'console.clear()',
      \]
" Optional here as a reference
let b:repl_close_command = ''
"autocmd FileType javascript,javascriptreact let b:repl_close_command = '.exit'
autocmd FileType typescript,typescriptreact let b:repl_shell_command = 'npx ts-node -T'
autocmd FileType typescript,typescriptreact let b:repl_startup_commands = [
      \'.load ' . expand('%'),
      \'console.clear()',
      \]
autocmd FileType python let b:repl_shell_command = 'python'
autocmd FileType matlab let b:repl_shell_command = 'octave'
autocmd FileType sh let b:repl_shell_command = 'bash'

fun! RunScript(whole_file) range
  if empty(b:repl_shell_command)
    echo 'No shell command'
    return
  endif
  let s:tempfilename = tempname()
  let l:shell_command = 'cat ' . s:tempfilename . ' | sed ''s/^/> /''' . " && "
  let l:shell_command .= 'echo ''==================''' . " && "
  let l:shell_command .= b:repl_shell_command . ' < ' . s:tempfilename . " && "
  let l:shell_command .= 'echo ''=================='''

  if a:whole_file
    let l:textlist = getline(1, '$')
  else
    let l:textlist = GetSelectedTextAsList()
    if len(l:textlist) == 0
      let l:textlist = getline(1, '$')
    endif
  endif

  let whitespace = matchstr(l:textlist[0], '^\s*')
  call map(l:textlist, 'strpart(v:val, ' . strlen(whitespace) . ')')
  call writefile(l:textlist, s:tempfilename, 's')

  " Depends on the pipe.vim package
  call g:Pipe(l:shell_command)

  call delete(s:tempfilename)
endfun
" @see original solution - http://stackoverflow.com/a/6271254/794380
fun! GetSelectedTextAsList()
  " Why is this not a built-in Vim script function?!
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  if len(lines) == 0
    return []
  endif
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return lines
endfun

" Tmux splitting
function GetActiveTmuxPane()
  let line = system("tmux list-panes | grep \'(active)$'")
  let paneid = matchstr(line, '\v\%\d+ \(active\)')
  if !empty(paneid)
    return matchstr(paneid, '\v^\%\d+')
  else
    return matchstr(line, '\v^\d+')
  endif
endfunction

let g:my_repl_pane = ''

function s:ReplStartTmux()
  " Check if Tmux is running
  if $TMUX == ""
    echohl WarningMsg
    echomsg "Cannot start interpreter because not inside a Tmux session."
    echohl Normal
    return
  endif

  let my_vim_pane = GetActiveTmuxPane()
  let tcmd = "tmux split-window "
  let tcmd .= "-l 15"
  let tcmd .= " " . b:repl_shell_command
  let slog = system(tcmd)
  if v:shell_error
    exe 'echoerr ' . slog
    return
  endif
  let g:my_repl_pane = GetActiveTmuxPane()
  let slog = system("tmux select-pane -t " . my_vim_pane)
  if v:shell_error
    exe 'echoerr ' . slog
    return
  endif
  if exists("b:repl_startup_commands") && len(b:repl_startup_commands) > 0
    call s:ReplSendCmds(b:repl_startup_commands)
  endif
endfunction
function ReplClose()
  if !empty(g:my_repl_pane)
    if !empty(b:repl_close_command)
      call s:ReplSendCmd(b:repl_close_command)
    else
      call s:ReplSendCmd("\<C-D>")
    endif
    let g:my_repl_pane = ''
  endif
endfunction

function s:ReplStartTmuxIfNotFound()
  if empty(g:my_repl_pane)
    call s:ReplStartTmux()
  endif
endfunction
function s:ReplSendCmd(line, ...)
  let str = substitute(a:line, "'", "'\\\\''", "g")
  let scmd = "tmux set-buffer '" . str . "\n' && tmux paste-buffer -t " . g:my_repl_pane
  call system(scmd)
  if v:shell_error
    let g:my_repl_pane = ''
    let callCount = get(a:, 1, 0)
    if callCount == 0
      call s:ReplStartTmuxIfNotFound()
      call s:ReplSendCmd(a:line, 1)
    else
      echohl WarningMsg
      echomsg 'Failed to send command. Is "' . b:repl_shell_command . '" running?'
      echohl Normal
    endif
  endif
endfunction
function s:ReplSendCmds(lines)
  for line in a:lines
    call s:ReplSendCmd(line)
  endfor
endfunction
function ReplSendSelection() range
  let lines = GetSelectedTextAsList()
  let whitespace = matchstr(lines[0], '^\s*')
  call map(lines, 'strpart(v:val, ' . strlen(whitespace) . ')')
  call s:ReplStartTmuxIfNotFound()
  call s:ReplSendCmds(lines)
endfunction
function ReplSendCurrentLine()
  let line = getline(".")
  let whitespace = matchstr(line, '^\s*')
  let line = strpart(line, strlen(whitespace))
  call s:ReplStartTmuxIfNotFound()
  call s:ReplSendCmd(line)
endfunction
function! s:ReplSetPaneTo(line)
  let paneid = matchstr(a:line, '\v\%\d+')
  let g:my_repl_pane = paneid
endfunction
function! ReplSetPane()
  call fzf#run({
        \'source': 'tmux list-panes | grep -v active',
        \'sink': function('s:ReplSetPaneTo'),
        \'down': '40%'
        \})
endfunction

xnoremap <leader>re :call RunScript(0)<cr>
nnoremap <leader>re :call RunScript(1)<cr>
xnoremap <leader>rw :call ReplSendSelection()<cr>
nnoremap <leader>rw :call ReplSendCurrentLine()<cr>j
nnoremap <leader>rq :call ReplClose()<cr>
nnoremap <leader>rp :call ReplSetPane()<cr>
"<leader>e: Run lines and output (selection or whole file)"
"<leader>w: Run repl and push lines (selection or current line)"
"<leader>q: Close repl"
