" === Theme
if has('nvim')
  Plug 'ishan9299/nvim-solarized-lua'
else
  " For termguicolors
  if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
  Plug 'altercation/vim-colors-solarized'
  "autocmd BufReadPost <buffer> hi MatchParen cterm=bold,underline ctermbg=none ctermfg=red
  " silent! colorscheme solarized
endif

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_extensions = []
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#branch#empty_message='no repo'
let g:airline_theme='solarized'

" https://github.com/vim-airline/vim-airline-themes/issues/180#issue-471090136
let s:saved_theme = []

let g:airline_theme_patch_func = 'AirlineThemePatch'
function! AirlineThemePatch(palette)
  for colors in values(a:palette)
    if has_key(colors, 'airline_c') && len(s:saved_theme) ==# 0
      let s:saved_theme = colors.airline_c
    endif
    if has_key(colors, 'airline_term')
      let colors.airline_term = s:saved_theme
    endif
  endfor
endfunction
" end

"Plug 'TaDaa/vimade'

" === Hooks
if !has('nvim')
  Plug 'airblade/vim-gitgutter'
  let g:gitgutter_realtime = 0
  let g:gitgutter_eager = 0
endif

Plug 'svermeulen/vim-yoink'
nmap <c-n> <plug>(YoinkPostPasteSwapBack)
nmap <c-p> <plug>(YoinkPostPasteSwapForward)
nmap [y <plug>(YoinkRotateBack)
nmap ]y <plug>(YoinkRotateForward)
nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)
" Preserve yank position
nmap y <plug>(YoinkYankPreserveCursorPosition)
xmap y <plug>(YoinkYankPreserveCursorPosition)
" :Yanks
" Consider using 3[y when going back to the third on the list for example

" Highlights current match with ErrorMsg
Plug 'PeterRincker/vim-searchlight'

" From Damian Conway
"Plug 'schoettl/listtrans.vim'
" ;l toggles between bulleted list and text with commas and the last one has
" ', and'
" If there are already commas in our list, use semicolons
" If not using and, but say "but not", then append to penultimate item
" nnoremap ;l   :call ListTrans_toggle_format()<CR>
" vnoremap ;l   :call ListTrans_toggle_format('visual')<CR>

" From Damian Conway
Plug 'nixon/vim-vmath'
vmap <expr>  ++  VMATH_YankAndAnalyse()
nmap         ++  vip++
" Visually select numbers, then press ++
" "ap for average for example (see status line underlines for registers)

Plug 'vifm/vifm.vim'

Plug 'tpope/vim-dispatch'
" Use :Dispatch <run test/build cmd> (or :Make but that's make specific?)
" :Focus <cmd> to pin a command so that you can just call :Dispatch without
" args everytime, :Dispatch! for background running, show output with :Copen

Plug 'tpope/vim-fugitive'
" Move between changes with [c and ]c
" Move files with :Gmove <c-r>%

Plug 'NLKNguyen/pipe.vim'

"Plug 'craigemery/vim-autotag'
" https://github.com/craigemery/vim-autotag/issues/34
let g:autotagStartMethod='fork'
" Requires python support, but refreshes ctags if it's there
" More info on tags generally:
" https://andrew.stwrt.ca/posts/vim-ctags/
" <c-x><c-]> for tag completion
" <c-]> go to first match
" g<c-]> got to match if only one, else, show list
" g] show list of tags

Plug 'tpope/vim-sleuth'
" Indentation detection

function! LoadVimSleuth()
  if b:is_minified_file
    let g:sleuth_heuristics = 0
  endif
endfunction
augroup minifiedSleuthLoad
  autocmd!
  autocmd BufReadPost * call LoadVimSleuth()
augroup END


Plug 'osyo-manga/vim-anzu' " show search progress
" mapping
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
"nmap * <Plug>(anzu-star-with-echo)
"nmap # <Plug>(anzu-sharp-with-echo)
" https://vim.fandom.com/wiki/Searching#Case_sensitivity
nnoremap <silent> <Plug>(StarCaseSensitive) /\<<C-R>=expand('<cword>')<CR>\>\C<CR>
nnoremap <silent> <Plug>(SharpCaseSensitive) ?\<<C-R>=expand('<cword>')<CR>\>\C<CR>
nmap * <Plug>(anzu-star)N<Plug>(StarCaseSensitive)<Plug>(anzu-echo-search-status)
nmap # <Plug>(anzu-sharp)N<Plug>(SharpBackwardsCaseSensitive)<Plug>(anzu-echo-search-status)

" clear status
nmap <Esc><Esc> <Plug>(anzu-clear-search-status)
" Show in search status - will override file name so kinda meh
"let g:airline_section_c='%{anzu#search_status()}'

if !has('nvim') && has('python')
  Plug 'Valloric/MatchTagAlways'
endif
" Show closing tag
let g:mta_filetypes = {
\ 'html' : 1,
\ 'xhtml' : 1,
\ 'xml' : 1,
\ 'jinja' : 1,
\ 'typescript' : 1,
\ 'typescript.tsx' : 1,
\ 'javascript' : 1,
\ 'javascript.jsx' : 1,
\ 'typescriptreact' : 1,
\}
nnoremap <leader>% :MtaJumpToOtherTag<cr>

" I think this is still lisp specific
" Plug 'guns/vim-sexp'
" nnoremap <Right> <Plug>(sexp_move_to_next_element_head)
" nnoremap <Left> <Plug>(sexp_move_to_prev_element_head)
" nnoremap <Up> <Plug>(sexp_move_to_prev_top_element)
" nnoremap <Down> <Plug>(sexp_move_to_next_top_element)

Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
let g:session_autosave = 'yes'
let g:session_autoload = 'no'
let g:session_default_overwrite = 1
" Basically you just care about :OpenSession, don't worry about anything else
" Sometimes you need to worry about :DeleteSession

" Too much drawing, a bit slow
" Plug 'RRethy/vim-illuminate'

" === Commands and functions
Plug 'knsh14/vim-github-link'
nnoremap <Leader>yg :GetCommitLink<CR>

" Plug 'PeterRincker/vim-argumentative'
" <, or >, for move argument left or right

" Plug 'terryma/vim-multiple-cursors'

Plug 'junegunn/vim-easy-align'
xmap ga <Plug>(EasyAlign)
" vipga= " Visual Inner Paragraph (ga) align =
" Visually select what you want to align, `g``a``=` to align on equals sign

Plug 'tpope/vim-unimpaired'
" I only download this for the conflict mapping ]n and [n

Plug 'tpope/vim-projectionist'

"Plug 'c-brenn/fuzzy-projectionist.vim'

if !exists('g:projectionist_transformations')
  let g:projectionist_transformations = {}
endif

" function! g:projectionist_transformations.testify(input, o) abort
"   let l:stripped = fnamemodify(a:input, ':r')
"   return l:stripped ==# a:input ? a:input . '.test' : l:stripped
" endfunction
" function! g:projectionist_transformations.testify(input, o) abort
"   if a:input =~# '/__test__/'
"     return substitute(a:input, '/\zs__test__/\|\.\zstest\.', '', 'g')
"   else
"     return substitute(substitute(a:input, '\ze/[^/]*$', '/__test__', ''), '\ze\.[^.]*$', '.test', '')
"   endif
" endfunction
function! g:projectionist_transformations.testify(input, o) abort
  if a:input =~# '/__tests__/'
    return substitute(a:input, '/\zs__tests__/\|\.test', '', 'g')
  else
    return substitute(a:input, '\ze/[^/]*$', '/__tests__', '') . '.test'
  endif
endfunction


function! g:projectionist_transformations.strato_to_scala(input, o) abort
  let strato_spaces_exclude = ['GraphQlQuery']

  let pattern = '\v(.*)/(\w+)(\.(\w+))?'
  let match = matchlist(a:input, pattern)
  let name = substitute(match[2], '\v(^|_)(\a)', '\u\2', 'g')
  let result = match[1] . '/' . name
  return result
endfunction
function! g:projectionist_transformations.strato_to_scala_with_space(input, o) abort
  let strato_spaces_exclude = ['GraphQlQuery']

  let pattern = '\v(.*)/(\w+)(\.(\w+))?'
  let match = matchlist(a:input, pattern)
  let name = substitute(match[2], '\v(^|_)(\a)', '\u\2', 'g')
  let name_prefix = index(strato_spaces_exclude, match[4]) == -1 && len(match[4]) > 0 ? match[4] : ''
  let result = match[1] . '/' . name_prefix . name
  return result
endfunction

function! g:projectionist_transformations.scala_to_strato(input, o) abort
  let strato_spaces_include = ['Tweet', 'User', 'Professional']

  let pattern = '\v(.*)/(Tweet|User|Professional)?(\w+)?'
  let match = matchlist(a:input, pattern)
  let name = substitute(match[3], '\v(^|_)(\a)', '\l\2', 'g')
  let space_suffix = len(match[2]) > 0 ? '.' . match[2] : ''
  let result = match[1] . '/' . name . space_suffix
  return result
endfunction
function! g:projectionist_transformations.scala_to_strato__with_space(input, o) abort
  let strato_spaces_include = ['Tweet', 'User', 'Professional']

  let pattern = '\v(.*)/(Tweet|User|Professional)?(\w+)?'
  let match = matchlist(a:input, pattern)
  let name = substitute(match[3], '\v(^|_)(\a)', '\l\2', 'g')
  let space_suffix = len(match[2]) > 0 ? '.' . match[2] : '.GraphQlQuery'
  let result = match[1] . '/' . name . space_suffix
  return result
endfunction

let g:projectionist_heuristics = {
  \ 'package.json': {
  \    'src/*.ts': {
  \      'alternate': 'src/{}.module.css',
  \      'type': 'source',
  \    },
  \    'src/*.tsx': {
  \      'alternate': 'src/{}.module.css',
  \      'type': 'source',
  \    },
  \    'src/*.test.ts': {
  \      'type': 'test',
  \    },
  \    'src/*.test.tsx': {
  \      'type': 'test',
  \    },
  \    'src/*.module.css': {
  \      'alternate': 'src/{}.tsx',
  \      'type': 'css',
  \    },
  \  },
  \  '__tests__/': {
  \    '*.js': {
  \      'alternate': '{dirname}/__tests__/{basename}.test.js',
  \      'type': 'source',
  \    },
  \    '__tests__/*.test.js': {
  \      'alternate': '{}.js',
  \      'type': 'test',
  \    },
  \  },
  \  'src/main/&src/test/': {
  \    'src/main/*.scala': {
  \      'alternate': 'src/test/{}Spec.scala',
  \      'type': 'source',
  \    },
  \    'src/test/*Spec.scala': {
  \      'alternate': 'src/main/{}.scala',
  \      'type': 'test',
  \    }
  \  },
  \  'strato/config/': {
  \    'strato/config/columns/*.strato': {
  \      'alternate': [
  \        'strato/config/test/scala/com/twitter/strato/config/columns/{strato_to_scala_with_space}Test.scala',
  \        'strato/config/test/scala/com/twitter/strato/config/columns/{strato_to_scala}Test.scala',
  \      ],
  \      'type': 'source',
  \    },
  \    'strato/config/test/scala/com/twitter/strato/config/columns/*Test.scala': {
  \      'alternate': [
  \        'strato/config/columns/{scala_to_strato_with_space}.strato',
  \        'strato/config/columns/{scala_to_strato}.strato',
  \      ],
  \      'type': 'test',
  \    },
  \  },
  \}

nnoremap <silent> <leader>ps :Esource<cr>
nnoremap <silent> <leader>pt :Etest<cr>
nnoremap <silent> <leader>pc :Ecss<cr>
nnoremap <silent> <leader>pa :A<cr>

Plug 'tpope/vim-abolish'
" crs - coerce_snake_case
" crm - MixedCase
" crc - camelCase
" cru - UPPER_CASE
" cr- - dash-case
" cr. - dot.case
" cr<space> - space case
" crt - Title Case
" :%Subvert/facilit{y,ies}/building{,s}/g

Plug 'FooSoft/vim-argwrap'
" Pointless given prettier, but can be useful?
nnoremap <silent> <leader>aw :ArgWrap<CR>

Plug 'bronson/vim-visual-star-search'
" Use * in visual mode

Plug 'tpope/vim-surround'
" cs'" - for change existing
" dst - for delete surrounding tags
" ysiw] - for insert no space square bracket, use `[` for with space
" ysiw<em> - for insert tags
" <VISUAL> S<p class="important"> - insert p tag around
" See issue: https://github.com/tpope/vim-surround/issues/276
nmap ysa' ys2i'
nmap ysa" ys2i"
nmap ysa` ys2i`

Plug 'machakann/vim-sandwich'
" prefer, vim-surround, use this for:
" saiwffunc<cr> - func, param -> func(param)
"   <visual>saffunc<cr>
"   <visual>saifunc(<cr>)<cr>
"   <visual>saI (repeats previous "instant")
" sdf - delete, func(param) -> param
" sdF - delete surrounding func
" saiwt div.class1 - insert html tag with emmet syntax
"   <visual> sat div.class1

Plug 'tommcdo/vim-exchange'
" visual: X to select text to swap, same on the text to swap with
" https://github.com/tommcdo/vim-exchange/issues/56 - `] to keep cursor loc
vmap X <Plug>(Exchange)`]
" cxc to cancel
" Todo: `] always goes to the end of the selection, want original pos
" https://superuser.com/questions/691130/vim-jump-to-previous-cursor-position-not-edit-point

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
" gc to comment

"Plug 'vim-scripts/ReplaceWithRegister' "griw to replace inner word with register

" Only for when you install locally on remote machine without root
set rtp+=~/ws/fzf
set rtp+=~/workspace/personal/fzf
set rtp+=/usr/local/opt/fzf
set rtp+=/opt/homebrew/opt/fzf
Plug 'junegunn/fzf.vim'
let g:fzf_layout = { 'down': '50%' }
" https://github.com/junegunn/fzf/blob/master/README-VIM.md
noremap <silent> <leader><Tab> :Buffers<CR>
" noremap <silent> <leader><Esc> :GFiles?<CR>
nmap <silent> <Leader>t :Files<CR>
nnoremap <silent> <Leader>e :Files <C-R>=split(expand('%:h'),'/')[0]<CR><CR>
"nmap <Leader><leader>r :BTags<CR>
"nmap <Leader><Leader>t :Tags<CR>
" https://github.com/junegunn/fzf.vim/issues/360
nnoremap <silent> <Leader><Leader>ts :QFiles <C-R>=expand('%:h')<CR><CR>
nnoremap <silent> <Leader><Leader>tr :Files <C-R>=expand('%:h')<CR><CR>
nnoremap <silent> <Leader><Leader>te :Files <C-R>=expand('%:h:h')<CR><CR>
nnoremap <silent> <Leader><Leader>tt :Files <C-R>=trim(system('git rev-parse --show-toplevel'))<CR><CR>
nnoremap <silent> <Leader>/ :Rg <C-R><C-W>
nnoremap <silent> <Leader>* :Rg <C-R><C-W><CR>
vnoremap <silent> <Leader>/ y:Rg \b<C-R>0\b<CR>
nnoremap <silent> <Leader>: :History:<CR>
nnoremap <silent> <Leader>h/ :History/<CR>
nnoremap <silent> <Leader>hh :History<CR>
"nnoremap <silent> <Leader>b :call ErrorWrapMissing("Buffers")<CR>

" augroup fzf
"   autocmd FileType fzf tnoremap <c-h> <Esc>:Files <C-R>=expand('%:h:h')<cr>
" augroup END

" Custom setup for previews on Rg and Files
command! -bang -nargs=* Rg
\ call fzf#vim#grep(
\   'rg --column --line-number --no-heading --color=always '.<q-args>, 1,
\   fzf#vim#with_preview(), <bang>0)

command! -bang -count=1 -nargs=* Rrg
\ call fzf#vim#grep(
\   'rg --column --line-number --no-heading --color=always '.<q-args>.' '.expand('%'.repeat(':h', <count>)), 1,
\   fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* Ripgrep
\ call fzf#vim#grep(
\   'rg --hidden --column --line-number --no-heading --color=always --smart-case --glob "!tags" --glob "!.git" '.<q-args>, 1,
\   fzf#vim#with_preview(), <bang>0)

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)
" Same command just moved q args so that the local file query sticks around
" https://github.com/junegunn/fzf.vim/issues/538
command! -bang -nargs=? -complete=dir QFiles
  \ call fzf#vim#files('', fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline', '--query', <q-args>]}), <bang>0)

function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction
function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction
" https://github.com/junegunn/fzf.vim/pull/733#issuecomment-559720813
command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))
" command! -bang UnlistedBuffers
" \ call fzf#vim#buffers('!i$ '.<q-args>, {
" \   'down': '40%',
" \   'options': '
" \     --with-nth 1,4
" \     --nth 1,2
" \     --delimiter "\t"
" \     --reverse
" \     --preview-window="70%"
" \     --preview "
" \       tail -n +\$(echo {3} | tr -d \";\\\"\") {2} |
" \       head -n 16 |
" \       bat -l '.expand('%:e').' --color=always --decorations=never
" \     "
" \   '
" \ })

" ------ start unlisted buffers
" Copied code from: https://github.com/junegunn/fzf.vim/blob/711fb41e39e2ad3abec1ec9720782acbac6fb6b4/autoload/fzf/vim.vim#L666
" There were some differences between Buffers and this command to fzf#run
" --expect=ctrl-v,ctrl-x,ctrl-t'
" 'sinklist': function('57'),
" '_action': {'ctrl-v': 'vsplit', 'ctrl-x': 'split', 'ctrl-t': 'tab split'}

" function! s:find_open_window(b)
"   let [tcur, tcnt] = [tabpagenr() - 1, tabpagenr('$')]
"   for toff in range(0, tabpagenr('$') - 1)
"     let t = (tcur + toff) % tcnt + 1
"     let buffers = tabpagebuflist(t)
"     for w in range(1, len(buffers))
"       let b = buffers[w - 1]
"       if b == a:b
"         return [t, w]
"       endif
"     endfor
"   endfor
"   return [0, 0]
" endfunction

" function! s:jump(t, w)
"   execute a:t.'tabnext'
"   execute a:w.'wincmd w'
" endfunction

" function! s:bufopen(lines)
"   echom len(a:lines)
"   if len(a:lines) < 2
"     return
"   endif
"   let b = matchstr(a:lines[1], '\[\zs[0-9]*\ze\]')
"   if empty(a:lines[0]) && get(g:, 'fzf_buffers_jump')
"     let [t, w] = s:find_open_window(b)
"     if t
"       call s:jump(t, w)
"       return
"     endif
"   endif
"   echom 'failleeddd'
"   let cmd = s:action_for(a:lines[0])
"   if !empty(cmd)
"     execute 'silent' cmd
"   endif
"   execute 'buffer' b
" endfunction
" " function! s:bufopen(e)
" "   execute 'buffer' matchstr(a:e, '^[ 0-9]*')
" " endfunction
" function! s:sort_buffers(...)
"   let [b1, b2] = map(copy(a:000), 'get(g:fzf#vim#buffers, v:val, v:val)')
"   " Using minus between a float and a number in a sort function causes an error
"   return b1 < b2 ? 1 : -1
" endfunction
" function! s:buflisted()
"   return filter(range(1, bufnr('$')), 'getbufvar(v:val, "&filetype") != "qf"')
" endfunction
" function! s:buflisted_sorted()
"   return sort(s:buflisted(), 's:sort_buffers')
" endfunction
" function! s:buffers(...)
"   let [query, args] = (a:0 && type(a:1) == type('')) ?
"         \ [a:1, a:000[1:]] : ['', a:000]
"   let sorted = s:buflisted_sorted()
"   let header_lines = '--header-lines=' . (bufnr('') == get(sorted, 0, 0) ? 1 : 0)
"   let tabstop = len(max(sorted)) >= 4 ? 9 : 8

"   let opts = {
"   \ 'source':  map(sorted, 'fzf#vim#_format_buffer(v:val)'),
"   \ 'sink*':   function('s:bufopen'),
"   \ 'options': ['+m', '-x', '--tiebreak=index', header_lines, '--ansi', '-d', '\t', '--with-nth', '3..', '-n', '2,1..2', '--prompt', 'Buf> ', '--query', query, '--preview-window', '+{2}-/2', '--tabstop', tabstop]
"   \}
"   echom opts
"   let [extra, bang]  = args
"   let extra = copy(extra)
"   let eopts  = has_key(extra, 'options') ? remove(extra, 'options') : ''
"   let merged = extend(copy(opts), extra)
"   call extend(merged.options, eopts)

"   return fzf#run(fzf#wrap('buffers', merged, bang))
" endfunction
" command! -bar -bang -nargs=? -complete=buffer UnlistedBuffers call s:buffers(<q-args>, fzf#vim#with_preview({ "placeholder": "{1}" }), <bang>0)

" nnoremap <silent> <Leader><Leader><Tab> :UnlistedBuffers<CR>
" ------ end unlisted buffers

" https://github.com/junegunn/fzf.vim/issues/800#issuecomment-533801609
" Sorting issue: https://github.com/junegunn/fzf.vim/pull/620
" !i$ for imports - mainly python
command! -bang BTags
\ call fzf#vim#buffer_tags('!i$ '.<q-args>, {
\   'down': '40%',
\   'options': '
\     --with-nth 1,4
\     --nth 1,2
\     --delimiter "\t"
\     --reverse
\     --preview-window="70%"
\     --preview "
\       tail -n +\$(echo {3} | tr -d \";\\\"\") {2} |
\       head -n 16 |
\       bat -l '.expand('%:e').' --color=always --decorations=never
\     "
\   '
\ })
command! -bang Tags
\ call fzf#vim#tags(<q-args>, {
\   'down': '40%',
\   'options': '
\     --with-nth 1..2
\     --reverse
\     --preview "
\       tail -n +\$(echo {3} | tr -d \";\\\"\") {2} |
\       head -n 16 |
\       bat -l '.expand('%:e').' --color=always --decorations=never
\     "
\   '
\ })
" Only works in the same mode??? e.g. insert only in insert mode
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
imap <c-x><c-k> <plug>(fzf-complete-word)
" imap <c-x><c-f> <plug>(fzf-complete-path)
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files')
imap <c-x><c-l> <plug>(fzf-complete-line)
" https://github.com/junegunn/fzf
" sbtrkt	fuzzy-match	Items that match sbtrkt
" 'wild	exact-match (quoted)	Items that include wild
" ^music	prefix-exact-match	Items that start with music
" .mp3$	suffix-exact-match	Items that end with .mp3
" !fire	inverse-exact-match	Items that do not include fire
" !^music	inverse-prefix-exact-match	Items that do not start with music
" !.mp3$	inverse-suffix-exact-match	Items that do not end with .mp3

" Plug 'easymotion/vim-easymotion'
" " Mainly use this to search
" " <leader>f<char>
" " <leader><leader>f<char><char>
" map <silent> <Leader>f <Plug>(easymotion-s)
" "map  <Leader>f <Plug>(easymotion-f)
" "nmap <Leader>f <Plug>(easymotion-overwin-f)
" "map  <Leader>F <Plug>(easymotion-F)
" map <silent> <Leader><leader>f <Plug>(easymotion-s2)
" let g:EasyMotion_do_mapping = 0

Plug 'tpope/vim-vinegar' " Making netrw file management easier
"nnoremap - :Tex <cr>
" `-` to jump in
" `y``.` to yank absolute path
" `~` to go home
" `ctrl``shift``6` to go back to editing (doesn't work for me, just use :bd)
" `.` to auto prepopulate `:` command with file, `!` for shell:
" e.g. `!chmod +x` for `:!chmod +x path/to/file`

"Plug 'jalvesaq/vimcmdline'
" vimcmdline mappings (local leader is \\)
" let cmdline_map_start          = '<LocalLeader>s'
" let cmdline_map_send           = '<LocalLeader><Space>'
" let cmdline_map_send_and_stay  = '<LocalLeader><Space>'
" let cmdline_map_source_fun     = '<LocalLeader>f'
" let cmdline_map_send_paragraph = '<LocalLeader>p'
" let cmdline_map_send_block     = '<LocalLeader>b'
" let cmdline_map_quit           = '<LocalLeader>q'
" let cmdline_app = {
"   \  'typescript': 'npx ts-node -T',
"   \}

Plug 'majutsushi/tagbar'
" Kinda works for python, not really working for typescript
" See the following for ctag setups per file type
" https://github.com/majutsushi/tagbar/wiki#typescript
let g:tagbar_type_typescript = {
  \ 'ctagstype': 'typescript',
  \ 'kinds': [
    \ 'c:classes',
    \ 'n:modules',
    \ 'f:functions',
    \ 'v:variables',
    \ 'v:varlambdas',
    \ 'm:members',
    \ 'i:interfaces',
    \ 'e:enums',
  \ ]
\ }
nnoremap <silent> <leader>o :TagbarToggle<cr>
"autocmd VimEnter * nested :call tagbar#autoopen(1)

Plug 'mattn/emmet-vim'
" <c-y>, - perform action under cursor e.g. div>ul.class>li
"   - if you have visually selected normal text then you will get a text
"   prompt to insert with placeholder like Tag: div>*

Plug 'AndrewRadev/linediff.vim'
" Select text then :Linediff to select diff, again to do diff.
" :LinediffReset to reset
vnoremap <Leader>d :Linediff<CR>
nnoremap <Leader><Leader>d :LinediffReset<CR>

" === Text objects
" Plug 'wellle/targets.vim'
" changes behaviour to also perform seeking so you don't need to wory as much about cursor
" placement. Doesn't work in comments
" da, - delete in comma
" daa - delete in argument
" cin) - change in next parens, doesn't need to be inside
" cil) - change in last parens, doesn't need to be inside

Plug 'bkad/CamelCaseMotion'
" Use , as camel case word object: i.e. ci,w
" let g:camelcasemotion_key = ','
nnoremap <silent> ∑ <Plug>CamelCaseMotion_w
nnoremap <silent> ∫ <Plug>CamelCaseMotion_b
vnoremap <silent> ∑ <Plug>CamelCaseMotion_w
vnoremap <silent> ∫ <Plug>CamelCaseMotion_b
nnoremap <silent> ´ <Plug>CamelCaseMotion_e
nnoremap <silent> ©´ <Plug>CamelCaseMotion_ge
vnoremap <silent> ´ <Plug>CamelCaseMotion_e
vnoremap <silent> ©´ <Plug>CamelCaseMotion_ge

"Plug 'vim-scripts/argtextobj.vim'
" Adds argument (a) so caa, cia
" func(a, b[asdf]) -> func(a, .) or -> func(a) (inner or outer)

Plug 'michaeljsmith/vim-indent-object'
" Key bindings	Description
" <count>ai	An Indentation level and line above.
" <count>ii	Inner Indentation level (no line above).
" <count>aI	An Indentation level and lines above/below.
" <count>iI	Inner Indentation level (no lines above/below).

"Plug 'christoomey/vim-sort-motion' "sort with gsip

" === Language specific
" Before polyglot overrides it
Plug 'nkouevda/vim-thrift-syntax'
Plug 'ayroblu/vim-strato-syntax'
if !has('nvim')
  Plug 'sheerun/vim-polyglot'
  let g:polyglot_disabled = ['mathematica', 'sh']
endif
" autocmd chaining: https://vi.stackexchange.com/questions/3968/is-there-a-way-to-and-events-in-the-autocmd
"autocmd FileType markdown autocmd BufReadPost,CursorHold <buffer> set conceallevel=0
let g:vim_markdown_new_list_item_indent = 0
" Shrink :Toc to size
let g:vim_markdown_toc_autofit = 1
" Don't do more than one line emphasis (in review)
let g:vim_markdown_emphasis_multiline = 0
" Because python inside triggers conceallevel 2 - jedi sets conceal level, so set it back for markdown files
let g:vim_markdown_conceal = 0
" Use "ge" for following links
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_anchorexpr = 'substitute(v:anchor, "-", " ", "g")'
" <leader>o for show toc
autocmd FileType markdown nnoremap <buffer> <leader>o :Toc<cr>
autocmd BufNewFile,BufRead *.plist set syntax=xml
autocmd BufNewFile,BufRead *.sharedshrc set ft=sh
" https://superuser.com/questions/489135/vim-does-not-detect-syntax-of-ssh-config
autocmd BufNewFile,BufRead */.ssh/config  setf sshconfig

Plug 'dbridges/vim-markdown-runner'
autocmd FileType markdown nnoremap <buffer> <Leader>r :MarkdownRunner<CR>
autocmd FileType markdown nnoremap <buffer> <Leader>R :MarkdownRunnerInsert<CR>

Plug 'godlygeek/tabular'
" Necessary for vim-markdown TableFormat

"Plug 'dhruvasagar/vim-table-mode'
" :TableModeToggle - ,tm
" :TableModeRealign - ,tr
" || for horizontal rule
" :Tableize - <Leader>tt to convert csv to table (:Tableize/\t for tsv)
" [|, ]|, {| & }| for moving left right up down
" <Leader>tdc delete column
" <Leader>tic or <Leader>tiC to insert a column
" :TableAddFormula or <Leader>tfa
" :TableEvalFormulaLine or <Leader>tfe or <Leader>t? for eval
let g:table_mode_map_prefix = ',t'

" Plugins for org mode (disabled cause GetOrgFolding() is extremely slow)
Plug 'inkarkat/vim-SyntaxRange'
Plug 'tpope/vim-speeddating'
Plug 'jceb/vim-orgmode'

" Plug 'arecarn/vim-fold-cycle'
"Current mappings
"nmap <CR> <Plug>(fold-cycle-open)
"nmap <BS> <Plug>(fold-cycle-close)

Plug 'mzlogin/vim-markdown-toc'
let g:vmt_list_item_char='-'
" :GenTocGFM

"Plug 'romainl/vim-devdocs'
" :DD source name
" If not for the language

"Plug 'davidhalter/jedi-vim'
"silent! python3 1==1 # Random hack that makes python3 work
"" We change these to be similar to tsuquyomi
"let g:jedi#goto_command = '<C-]>'
""let g:jedi#goto_assignments_command = ""
"let g:jedi#goto_definitions_command = '<C-}>'
"let g:jedi#documentation_command = 'K'
"let g:jedi#usages_command = '<leader>n'
"let g:jedi#completions_command = '<C-x><C-o>'
"let g:jedi#rename_command = '<leader>r'
"let g:jedi#popup_select_first = 0
"autocmd FileType python nnoremap <buffer><silent> <leader>b :cclose<cr>

"Plug 'tell-k/vim-autoflake'
"" :Autoflake to remove unused imports
"let g:autoflake_remove_unused_variables=0
"let g:autoflake_remove_all_unused_imports=1
""autocmd FileType python autocmd BufWritePre <buffer> Autoflake
"let g:autoflake_disable_show_diff=1
"command! Aflake :call Autoflake() | redraw!

" Warning, need to use Augroup soon
" https://stackoverflow.com/questions/10969366/vim-automatically-formatting-golang-source-code-when-saving/10969574

"Plug 'ayroblu/python-imports.vim'
" Use :ImportName, also ~/.vim/python-imports.cfg
"autocmd FileType python nnoremap <buffer> <leader>i :ImportName<cr>

" Plug 'w0rp/ale'
"autocmd FileType typescript,typescript.jsx let g:ale_linters = findfile('.eslintrc', '.;') != '' ? {'typescript': ['eslint']} : {'typescript': []}
autocmd FileType javascript,typescript,typescriptreact let b:ale_linters = []
autocmd FileType javascript let b:ale_linters_ignore = ['tsserver']
autocmd FileType swift let b:ale_linters_ignore = ['apple-swift-format', 'swiftlint']
" Enable ale for things coc doesn't support yet
autocmd FileType vim,javascript nmap <silent> ]j :ALENextWrap<cr>
autocmd FileType vim,javascript nmap <silent> [j :ALEPreviousWrap<cr>
"\ 'typescript': ['tslint', 'eslint', 'prettier'],
"\ 'typescriptreact': ['tslint', 'eslint', 'prettier'],
"\ 'javascript': ['eslint', 'prettier'],
"\ 'css': ['prettier'],
"\ 'json': ['prettier'],
"\ 'scala': ['scalafmt'],
"\ 'markdown': ['prettier'],
" Still use ale for python
" ALE Fixers are slow compared to Coc, use sparingly
let g:ale_fixers = {
\ 'python': ['black', 'isort']
\}
" \   '.*\.json$': {'ale_enabled': 0},
" \   '.*\.graphql$': {'ale_enabled': 0},
let g:ale_pattern_options = {
\   '.*\.py$': {'ale_enabled': 1},
\}
let g:ale_enabled = 0
let g:ale_fix_on_save = 1
"let g:ale_javascript_prettier_use_local_config = 1
" Disable the loclist (just annoying right now) can be opened with :lopen
let g:ale_open_list=0

"au BufNewFile,BufReadPost *.md set filetype=markdown

"Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
"" Due to a bug in colorscheme and lack of releases, use master
""-Plug 'neoclide/coc.nvim', {'branch': 'release'}
"" Hopefully this will replace ale and some of the others
"
"" All extensions, see: https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
"" Plug 'amiralies/coc-flow', {'do': 'yarn install --frozen-lockfile'}
"" Plug 'iamcco/coc-vimlsp', {'do': 'yarn install --frozen-lockfile'}
"" Plug 'josa42/coc-go', {'do': 'yarn install --frozen-lockfile'}
"" Plug 'klaaspieter/coc-sourcekit', {'do': 'yarn install --frozen-lockfile'}
"" Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
"" Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
"" Plug 'neoclide/coc-prettier', {'do': 'yarn install --frozen-lockfile'}
"" Plug 'neoclide/coc-rls', {'do': 'yarn install --frozen-lockfile'}
"" Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
"" Plug 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}
"" Plug 'scalameta/coc-metals', {'do': 'yarn install --frozen-lockfile'}
"
"" I think I prefer this, it's just easier
""\  'coc-metals',
"let g:coc_global_extensions = [
"\  'coc-eslint',
"\  'coc-tsserver',
"\  'coc-prettier',
"\  'coc-json',
"\  'coc-vimlsp',
"\  'coc-flow',
"\  'coc-rls',
"\  'coc-go',
"\  'coc-sourcekit',
"\  'coc-yaml',
"\  'coc-css'
"\]
"      "\'coc-graphql',
"      "\"coc-python',
"" vscode + coc config uses jsonc
"" https://github.com/neoclide/coc.nvim/wiki/Using-the-configuration-file
"autocmd FileType json syntax match Comment +\/\/.\+$+
"" https://github.com/neoclide/coc-json/issues/11
"" tsconfig.json is actually jsonc, help TypeScript set the correct filetype
"autocmd BufRead,BufNewFile tsconfig.json set filetype=jsonc
"
"function! s:prettier()
"  call coc#config('prettier.onlyUseLocalVersion', v:false)
"  execute 'CocCommand prettier.forceFormatDocument'
"endfunction
"command! -nargs=0 Prettier :call s:prettier()
"
"" Make <CR> to accept selected completion item or notify coc.nvim to format
"" <C-g>u breaks current undo, please make your own choice
"if exists('coc#pum#visible')
"  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
"                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
"endif
"
"inoremap <silent><expr> <c-x><c-o> coc#refresh()
"" Checkout the following as <c-space> is interpreted as <c-@>
"" https://stackoverflow.com/questions/24983372/what-does-ctrlspace-do-in-vim
"inoremap <silent><expr> <c-@> coc#refresh()
"inoremap <silent><expr> <c-space> coc#refresh()
"" Use `[[` and `]]` to navigate diagnostics
"nmap <silent> [[ <Plug>(coc-diagnostic-prev)
"nmap <silent> ]] <Plug>(coc-diagnostic-next)
"
"" GoTo code navigation.
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> <c-w>gd :call CocAction('jumpDefinition', 'drop')<CR>
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)
"
"" Use K to show documentation in preview window.
"nnoremap <silent> K :call <SID>show_documentation()<CR>
"
"" Applying codeAction to the selected region.
"" Example: `<leader>aap` for current paragraph
""xmap <leader>a  <Plug>(coc-codeaction-selected)
""nmap <leader>a  <Plug>(coc-codeaction-selected)
"
"" Remap keys for applying codeAction to the current buffer.
"nmap <leader>ac  <Plug>(coc-codeaction)
"" Apply AutoFix to problem on the current line.
"nmap <leader>qf  <Plug>(coc-fix-current)
"" Run the Code Lens action on the current line.
"nmap <leader>cl  <Plug>(coc-codelens-action)
"
"command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
"
"function! s:show_documentation()
"  if (index(['vim','help'], &filetype) >= 0)
"    execute 'h '.expand('<cword>')
"  elseif (coc#rpc#ready())
"    call CocActionAsync('doHover')
"  else
"    execute '!' . &keywordprg . " " . expand('<cword>')
"  endif
"endfunction
"
"" Highlight the symbol and its references when holding the cursor.
"if exists("*CocActionAsync")
"  autocmd CursorHold * silent call CocActionAsync('highlight')
"endif
"
"" Symbol renaming.
"nmap <leader>rn <Plug>(coc-rename)
"
"augroup supporteddefs
"  autocmd!
"  " "Workspaces for different file types, defaults to []
"  autocmd FileType scala let b:coc_root_patterns = [".git"]
"
"  " Update signature help on jump placeholder. - have no clue what this does
"  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
"augroup END
"
"" Introduce function and class text objects
"" " NOTE: Requires 'textDocument.documentSymbol' support from the language
"" server.
"xmap if <Plug>(coc-funcobj-i)
"xmap af <Plug>(coc-funcobj-a)
"omap if <Plug>(coc-funcobj-i)
"omap af <Plug>(coc-funcobj-a)
"xmap ic <Plug>(coc-classobj-i)
"omap ic <Plug>(coc-classobj-i)
"xmap ac <Plug>(coc-classobj-a)
"omap ac <Plug>(coc-classobj-a)
"
"" Remap <C-f> and <C-b> for scroll float windows/popups.
"if has('nvim-0.4.0') || has('patch-8.2.0750')
"  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"endif
"
"" https://github.com/neoclide/coc.nvim/issues/349
"if has('nvim')
"  let s:coc_denylist = ['markdown', 'scala']
"else
"  let s:coc_denylist = ['markdown']
"endif
"
"function! s:disable_coc_for_type()
"  if index(s:coc_denylist, &filetype) != -1
"    let b:coc_enabled = 0
"  endif
"endfunction
"augroup CocGroup
"  autocmd!
"  autocmd BufNew,BufEnter * call s:disable_coc_for_type()
"augroup end

"Plug 'antoinemadec/coc-fzf'
"" :CocFzfList
"" :CocFzfList diagnostics
"" :CocFzfListResume (same as last fzf)
"" Mappings for CoCList
"" Show all diagnostics.
"nnoremap <silent><nowait> <Leader>aa  :<C-u>CocDiagnostics<cr>
"nnoremap <silent><nowait> <Leader>ca  :<C-u>CocFzfList diagnostics<cr>
"" Manage extensions.
"nnoremap <silent><nowait> <Leader>ce  :<C-u>CocFzfList extensions<cr>
"" Show commands.
"nnoremap <silent><nowait> <Leader>cd  :<C-u>CocFzfList commands<cr>
"" Find symbol of current document.
"nnoremap <silent><nowait> <Leader>co  :<C-u>CocFzfList outline<cr>
"" Search workspace symbols.
"nnoremap <silent><nowait> <Leader>cs  :<C-u>CocList -I symbols<cr>
"" Do default action for next item.
""nnoremap <silent><nowait> <Leader>cj  :<C-u>CocNext<CR>
"" Do default action for previous item.
""nnoremap <silent><nowait> <Leader>ck  :<C-u>CocPrev<CR>
"" Resume latest coc list.
"nnoremap <silent><nowait> <Leader>cr  :<C-u>CocFzfListResume<CR>

" Twitter specific
"Plug 'jrozner/vim-antlr'
"Plug 'pantsbuild/vim-pants'

" included in polyglot
"Plug 'othree/html5.vim'
"Plug 'pangloss/vim-javascript'
Plug 'evanleck/vim-svelte', {'branch': 'main'}
let g:svelte_preprocessors = ['typescript']
" Remove indents if you want
" let g:svelte_indent_script = 0
" let g:svelte_indent_style = 0

" === old

"Plug 'garbas/vim-snipmate'
"Plug 'honza/vim-snippets'

"Plug 'tpope/vim-speeddating' "Understand dates if you want
"Plug 'zeekay/vim-beautify'

" Initialize plugin system

