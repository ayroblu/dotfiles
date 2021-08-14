augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END

function! NetrwMapping()
  nnoremap <buffer> _ :echom GetWord()<cr>
endfunction

function! GetWord()
  let snr = matchstr(matchstr(split(execute('scriptnames'), "\n"), 'netrw.vim'), '^\d\+')
  let NetrwGetWord = function('<SNR>'.snr.'_NetrwGetWord')
  let NetrwGetCurdir = function('<SNR>'.snr.'_NetrwGetCurdir')
  let NetrwFullPath = function('<SNR>'.snr.'_NetrwGetCurdir')
  echo substitute(NetrwGetWord(),'^'.fnameescape(NetrwGetCurdir(1)).'/','','')
  return NetrwGetCurdir(1) . NetrwGetWord()
endfunction
