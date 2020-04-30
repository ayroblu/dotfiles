let g:ale_python_flake8_options = '--config='.fnamemodify('flake8.ini', ':p')
" Give black some more room
let g:ale_python_black_options = '-l 100'
" Follow black style when sorting imports with vim-isort
let g:vim_isort_config_overrides = {
  \  'multi_line_output': 3,
  \  'known_first_party': ['aipy'],
  \  'line_length': 100,
  \  'sections': ['FUTURE','STDLIB','THIRDPARTY','FIRSTPARTY','LOCALFOLDER'],
  \}

" Still needs env vars
autocmd FileType typescript,typescript.tsx xnoremap <buffer> <leader>e :w !npx ts-node -P ./typescript/tsconfig.base.json -r ./scripts/loadEnv.js -r ./typescript/setup.ts -T<cr>

" From https://github.com/python/mypy/blob/master/scripts/find_type.py
function RevealType()
  " Set this to the command you use to run mypy on your project.  Include the mypy invocation.
  let mypycmd = 'mypy --config-file=mypy.ini %'
  let [startline, startcol] = getpos("'<")[1:2]
  let [endline, endcol] = getpos("'>")[1:2]
  " Convert to 0-based column offsets
  let startcol = startcol - 1
  " Change this line to point to the find_type.py script.
  execute '!python3 aipy/lib/find_type.py % ' . startline .
    \ ' ' . startcol . ' ' . endline . ' ' . endcol . ' ' . mypycmd
endfunction
autocmd FileType python vnoremap <buffer> <Leader>t :call RevealType()<CR>
