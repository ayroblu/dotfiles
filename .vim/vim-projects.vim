" Define a function to detect the Git root
function! s:FindGitRoot()
  " Use system() to run 'git rev-parse --show-toplevel' and trim newline
  let l:git_root = system('git rev-parse --show-toplevel 2>/dev/null')
  if v:shell_error
    return ''
  endif
  return substitute(l:git_root, '\n$', '', '')
endfunction

function! s:GetRelativeFilePath()
  let l:git_root = s:FindGitRoot()
  if l:git_root == ''
    return ''
  endif
  let l:absolute_file_path = expand('%:p') " Get the absolute path of the current file
  return substitute(l:absolute_file_path, l:git_root . '/', '', '')
endfunction

" Autocommand to apply settings when editing files in a Git repository
augroup s:ProjectSettings
  autocmd!
  autocmd VimEnter * call s:ApplyProjectSettings()
augroup END

function! s:ApplyProjectSettings()
  let l:git_root = s:FindGitRoot()
  let b:git_root = l:git_root
  if l:git_root != ''
    let l:basename = fnamemodify(l:git_root, ':t')
    if l:basename == "bazel-demo"
      "autocmd BufWritePost BUILD.bazel,*.bzl silent execute '!bazel run //:format ' . s:GetRelativeFilePath() | edit
      autocmd BufWritePost BUILD.bazel,*.bzl silent execute '!buildifier %' | edit
    elseif l:basename == "advent-of-code"
      let $PATH = $PATH . ':' . l:git_root . '/.venv/bin'
    endif
  endif
endfunction
