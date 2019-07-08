" Ben Lu, vimrc
" :so ~/_vimrc " reloads vimrc, use in vim, not here, or quit and use `vis` if
" you have sessions setup
" Use `vim -u None file.txt` if big
" Use `gq` to format comments at textwidth
" Find and replace: use :%s/regex/replacement/g (or
" :%s#regex/path#replacement#g)
" For practice you may want to run on the current line with :s/ and then run
" g& afterwards when you're sure it's right
" ------------------------------------------------------------Main layout
set sw=2 sts=2 ts=2 "shiftwidth, softtabstop, tabstop
set number et is ai hls ru sc "linenumbers, softtabs, incsearch, autoindent, highlight search, ruler line col number, showcmd
set cursorline mouse=a
set laststatus=2 " Always show a status bar
hi CursorLine   cterm=bold,underline ctermbg=NONE ctermfg=NONE guibg=blue guifg=orange "Set cursor line highlight colours
set splitright splitbelow
set backspace=indent,eol,start "Without this, you can't backspace an indent or line
set scrolloff=1
set smartindent
set lazyredraw "perf
set nobackup " swap files are relatively pointless
set noswapfile " swap files are relatively pointless
set tabpagemax=100 "normally 10
set relativenumber
set autoread "detect if file has changed
set display+=lastline "long lines show to the end instead of @ sign
set complete+=kspell " autocomplete includes the dictionary if enabled
set fdm=manual fdl=4 "foldmethod fdc=1 foldcolumn
set updatetime=1000 "event when cursor stops moving for a second, for swp normally, but now is for checktime call below
" Ignore case except when there atleast one capital
set smartcase

" https://stackoverflow.com/questions/26708822/why-do-vim-experts-prefer-buffers-over-tabs
set hidden " can switch to another buffer when you have unsaved changes

" Tab completion, as much as possible, list options, then tab through each option
set wildmode=longest,list,full
set wildmenu

" Project vimrcs: https://andrew.stwrt.ca/posts/project-specific-vimrc/
set exrc

" Add characters for tabs and spaces on the end of lines
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:·,extends:>,precedes:<,nbsp:+
endif
set list

" Turns off the bell (audible)
set visualbell t_vb=
" sets default font to what is in macos terminal
set guifont=Monaco:h12
" No blinking cursor
set guicursor+=a:blinkon0
" Randomly pulled from https://github.com/lifepillar/vim-solarized8/issues/45
" cause defaults aren't good
let g:terminal_ansi_colors = ['#073642', '#dc322f', '#859900', '#b58900', '#268bd2', '#d33682', '#2aa198', '#eee8d5',
      \ '#002b36', '#cb4b16', '#93a1a1', '#839496', '#657b83', '#6c71c4', '#586e75', '#fdf6e3']

" https://stackoverflow.com/questions/25233859/vimdiff-immediately-becomes-stopped-job-crashes-terminal-when-i-try-to-fg-it-b
" set shell=/bin/zsh\ -l
" Why do I want this?
if &diff == 'nodiff'
    "set shellcmdflag=-ic
endif

let mapleader=" "

"enable's syntax highlighting, corrollary: https://stackoverflow.com/questions/33380451/is-there-a-difference-between-syntax-on-and-syntax-enable-in-vimscript
syntax enable

" https://vi.stackexchange.com/questions/10124/what-is-the-difference-between-filetype-plugin-indent-on-and-filetype-indent
" filetype - detection - detect type of syntax by filetype
" plugin - allow plugins (not sure this is necessary as we use vim-plug)
" indent - indent file helps with indenting
filetype plugin indent on

" ------------------------------------------------------------------Mappings
" set spell spelllang=en_nz " ]s [s ]S [S " next spelling error
"nnoremap <Leader>s      :setl spell! spelllang=en_nz<CR> " ]s [s ]S [S " next spelling error

" Doesn't do anything for macOS
"imap <S-space> <Esc>
imap jj <Esc>l
imap jk <Esc>l

" movement in insert mode is nice to have
imap <c-l> <right>
imap <c-h> <left>
imap <c-j> <down>
imap <c-k> <up>

" copy and pasting
vmap <C-c> y:call system("pbcopy", getreg("\""))<CR>
nmap <C-v><C-v> :call setreg("\"",system("pbpaste"))<CR>p

" Highlight rows and columns with \l and \c, 'l to move, :match to remove
" highlighting
nnoremap <silent> <Leader>l ml:execute 'match Search /\%'.line('.').'l/'<CR>
nnoremap <silent> <Leader>c :execute 'match Search /\%'.virtcol('.').'v/'<CR>

"Tab mappings
" tab navigation like firefox
nnoremap {         :tabprevious<CR>
nnoremap }         :tabnext<CR>
"nnoremap <C-t>     :tabnew<CR>
"inoremap <C-{>     <Esc>:tabprevious<CR>
"inoremap <C-}>     <Esc>:tabnext<CR>
"inoremap <C-t>     <Esc>:tabnew<CR>
nnoremap (         :tabmove -1<cr>
nnoremap )         :tabmove +1<cr>

" Window mappings
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Move line up or down with alt key
" <A-j>: ∆, <A-k>: ˚
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
nnoremap ∆ :m .+1<CR>==
nnoremap ˚ :m .-2<CR>==
" inoremap <A-j> <Esc>:m .+1<CR>==gi
" inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap ∆ :m '>+1<CR>gv=gv
vnoremap ˚ :m '<-2<CR>gv=gv

" Scroll mappings
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

" This is just annoying
noremap K k

" nnoremap <C-L> :redraw!

" delete without yanking
"nnoremap d "_d
"vnoremap d "_d
" replace currently selected text with default register
" without yanking it
vnoremap p "_dP

" Moving cursor by display lines
" -  http://vim.wikia.com/wiki/Move_cursor_by_display_lines_when_wrapping
noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj
noremap  <buffer> <silent> 0 g0
noremap  <buffer> <silent> $ g$


" Insert single character
nnoremap s :exec "normal i".nr2char(getchar())."\el"<CR>
nnoremap S :exec "normal a".nr2char(getchar())."\el"<CR>

" --------------- from https://sanctum.geek.nz/arabesque/vim-annoyances/
" always middle on next, needs to be remaped as per plugin FYI, see below
" (anzu), but the zz removes the anzu output so this does nothing for now
nnoremap N Nzz
nnoremap n nzz

" Disable Ex mode on Q
nnoremap Q <nop>
"nnoremap K <nop> " already remaped elsewhere

" ----------------------------- Reload page on change
"Before
"au CursorHold * checktime
"After with https://vi.stackexchange.com/questions/14315/how-can-i-tell-if-im-in-the-command-window
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if !bufexists("[Command Line]") | checktime | endif

"-----------------------------Functions and commands
" For profiling:
function Prof()
  profile start profile.log
  profile func *
  profile file *
endfunction

function EndProf()
  profile pause
  noautocmd qall!
endfunction
command! Prof :call Prof()
command! EndProf :call EndProf()

" Delete current file:
command! DeleteFile :call delete(expand('%')) | bdelete!

" Strip file whitespace before saving
autocmd BufWritePre * %s/\s\+$//e

" Switch to last buffer :b#

" Normally you can open a url with gx, doesnt work so use <leader>u
" Hint, can also open files with gf
function! HandleURL()
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;]*')
  echo s:uri
  if s:uri != ""
    silent exec "!open '".s:uri."'"
  else
    echo "No URI found in line."
  endif
endfunction
map <leader>u :call HandleURL()<cr>

" Restore cursor position horizontally when switching buffer
autocmd BufEnter * silent! normal! g`"

" A few personal aliases that make editing certain files easier
command Cvim :n ~/.vimrc
command Czsh :n ~/.zshrc*
command Cbash :n ~/.bashrc*
command Ctmux :n ~/.tmux.conf
command Cnotes :n ~/Dropbox/Notes.md ~/Dropbox/Notes/*

" clear auto commands with !au (if you want) and reload vim, can use RestartVim in MacVim?
command Reload :so ~/.vimrc

" Displays buffer list, prompts for buffer numbers and ranges and deletes
" associated buffers. Example input: 2 5,9 12
" Hit Enter alone to exit.
function! InteractiveBufDelete()
  let l:prompt = "Specify buffers to delete: "

  ls | let bufnums = input(l:prompt)
  while strlen(bufnums)
    echo "\n"
    let buflist = split(bufnums)
    for bufitem in buflist
      if match(bufitem, '^\d\+,\d\+$') >= 0
        exec ':' . bufitem . 'bd'
      elseif match(bufitem, '^\d\+$') >= 0
        exec ':bd ' . bufitem
      else
        echohl ErrorMsg | echo 'Not a number or range: ' . bufitem | echohl None
      endif
    endfor
    ls | let bufnums = input(l:prompt)
  endwhile
endfunction
nnoremap <silent> <leader>bd :call InteractiveBufDelete()<CR>

" Close all except current buffer
" https://stackoverflow.com/questions/4545275/vim-close-all-buffers-but-this-one
command BufOnly :%bd|e#

"-----------------------------Set pasting to automatically go paste mode
" - https://coderwall.com/p/if9mda
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction
" ---------------------------------------------Stuff I don't really understand

" When editing a file, always jump to the last cursor position
autocmd BufReadPost *
\ if ! exists("g:leave_my_cursor_position_alone") |
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \ exe "normal g'\"" |
  \ endif |
\ endif

" Comparing the file with what's saved on disk for conflicts
" From https://www.reddit.com/r/vim/comments/2rnraa/indicator_if_a_saved_file_has_changed/
" Press \d to diff buffer with saved file
" Not used:
" - https://vi.stackexchange.com/questions/1971/is-it-possible-to-have-the-output-of-a-command-in-a-split-rather-than-the-who
"   - creates a command RSplit with explicit commands
" - https://stackoverflow.com/questions/3619146/vimdiff-two-subroutines-in-same-file
"   - Diff two buffers
" - https://github.com/AndrewRadev/linediff.vim
"   - Specify two blocks to diff
function! s:DiffGitWithSaved()
  " Current file full path, see :help filename-modifiers
  let filename = expand('%:p')
  let diffname = tempname()
  execute 'silent w! '.diffname
  " Horizontal split (perhaps quickfix window is better?)
  new
  " No more "+" on the file name, won't ask for saving on exit
  setlocal buftype=nowrite
  " eval a string as vimscript, '0read' reads the following command, '!' runs
  " shell, git diff no index -- does a diff (not sure why git, doesn't need
  " it, then the two files, one is saved as a temporary file, then || true
  " makes the exit code 0 so that it doesn't print a weird thing
  execute '0read !git diff --no-index -- '.shellescape(filename).' '.diffname.' || true'
  setf diff
endfunction
com! DiffGitSaved call s:DiffGitWithSaved()
nmap <leader>d :DiffGitSaved<CR>

"" --------------------------plugin settings
runtime macros/matchit.vim
"autocmd FileType markdown setlocal expandtab shiftwidth=4 softtabstop=4

" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.vim/plugged')

Plug 'altercation/vim-colors-solarized'
" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'PeterRincker/vim-argumentative'
Plug 'airblade/vim-gitgutter'
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
Plug 'edkolev/tmuxline.vim'
Plug 'terryma/vim-multiple-cursors'
" I only download this for the conflict mapping ]n and [n
Plug 'tpope/vim-unimpaired'
Plug 'sheerun/vim-polyglot'
"au BufNewFile,BufReadPost *.md set filetype=markdown
let g:vim_markdown_new_list_item_indent = 0

"Plug 'junegunn/vim-easy-align'
" vipga= " Visual Inner Paragraph (ga) align =
" gaip= " (ga) align Inner Paragraph =

"Plug 'garbas/vim-snipmate'
"Plug 'honza/vim-snippets'

Plug 'tpope/vim-fugitive'
" Move between changes with [c and ]c
Plug 'tpope/vim-surround'
" cs'" - for change existing
" dst - for delete surrounding tags
" ysiw] - for insert no space square bracket, use `[` for with space
" ysiw<em> - for insert tags
" <VISUAL> S<p class="important"> - insert p tag around
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
" gc to comment
"Plug 'tpope/vim-vinegar' " Making file management easier
"Plug 'tpope/vim-speeddating' "Understand dates if you want
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'zeekay/vim-beautify'
Plug 'vim-scripts/ReplaceWithRegister' "griw to replace inner word with register
Plug 'christoomey/vim-sort-motion' "sort with gsip
Plug 'mzlogin/vim-markdown-toc'
Plug 'davidhalter/jedi-vim'
" We change these to be similar to tsuquyomi
let g:jedi#goto_command = "<C-]>"
let g:jedi#goto_assignments_command = ""
let g:jedi#goto_definitions_command = "<C-}>"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<C-x><C-o>"
let g:jedi#rename_command = "<leader>r"

Plug 'edkolev/tmuxline.vim'
let g:airline#extensions#tmuxline#enabled = 0

Plug 'osyo-manga/vim-anzu' " show search progress
" mapping
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)

" clear status
nmap <Esc><Esc> <Plug>(anzu-clear-search-status)
"
" Show in search status - will override file name so kinda meh
"let g:airline_section_c='%{anzu#search_status()}'
"
" New based on: https://statico.github.io/vim3.html
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
noremap <leader><Tab> :Buffers<CR>
" https://github.com/junegunn/fzf
" sbtrkt	fuzzy-match	Items that match sbtrkt
" 'wild	exact-match (quoted)	Items that include wild
" ^music	prefix-exact-match	Items that start with music
" .mp3$	suffix-exact-match	Items that end with .mp3
" !fire	inverse-exact-match	Items that do not include fire
" !^music	inverse-prefix-exact-match	Items that do not start with music
" !.mp3$	inverse-suffix-exact-match	Items that do not end with .mp3

Plug 'mileszs/ack.vim'
Plug 'w0rp/ale'
"autocmd! FileType typescript,typescript.jsx let g:ale_linters = findfile('.eslintrc', '.;') != '' ? {'typescript': ['eslint']} : {'typescript': []}
"autocmd! FileType typescript,typescript.tsx let g:ale_linters = {'typescript': ['eslint']}
nmap <silent> ]j :ALENextWrap<cr>
nmap <silent> [j :ALEPreviousWrap<cr>


let g:ale_fixers = {
\ 'typescript': ['tslint', 'prettier'],
\ 'javascript': ['eslint', 'prettier'],
\ 'python': ['black'],
\}
let g:ale_fix_on_save = 1
let g:ale_javascript_prettier_use_local_config = 1

"Plug 'peitalin/vim-jsx-typescript'
Plug 'Quramy/tsuquyomi'
let g:tsuquyomi_single_quote_import=1
let g:tsuquyomi_shortest_import_path = 1
" Stop tsuquyomi freezing on save, why do this in vim 8 though...
let g:tsuquyomi_disable_quickfix = 1
autocmd! FileType typescript,typescript.tsx nmap <buffer> <Leader><space> : <C-u>echo tsuquyomi#hint()<CR>
" It takes like 30+ seconds gets kinda pointless
" autocmd FileType typescript
"     \ autocmd BufWritePost <buffer> :TsuquyomiAsyncGeterr

Plug 'flowtype/vim-flow'


Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
let g:session_autosave = 'yes'
let g:session_autoload = 'no'
let g:session_default_overwrite = 1
" Basically you just care about :OpenSession, don't worry about anything else

Plug 'bkad/CamelCaseMotion'
let g:camelcasemotion_key = '<leader>'
" Use leader as camel case word object: i.e. ci,w

Plug 'vim-scripts/argtextobj.vim'
" Adds argument (a) so caa, cia
" func(a, b[asdf]) -> func(a, .) or -> func(a) (inner or outer)

Plug 'michaeljsmith/vim-indent-object'
" Key bindings	Description
" <count>ai	An Indentation level and line above.
" <count>ii	Inner Indentation level (no line above).
" <count>aI	An Indentation level and lines above/below.
" <count>iI	Inner Indentation level (no lines above/below).

" Initialize plugin system
call plug#end()

" --------------------------------- Old extension config (to clean)
let g:airline_extensions = []
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#branch#empty_message='no repo'
let g:airline_theme='solarized'

let g:tmuxline_powerline_separators = 0
let g:tmuxline_preset = {
  \'a'       : '#S:#I',
  \'b disabled'       : '',
  \'c disabled'       : '',
  \'win'     : ['#I', '#W'],
  \'cwin'    : ['#I', '#W'],
  \'x disabled'       : '',
  \'y'       : ['%a', '%Y-%m-%d', '%l:%M%p'],
  \'z'       : ['#(whoami)'],
  \'options' : {'status-justify': 'left'}}


" set rtp+=/usr/local/opt/fzf
" I don't like vim-jsx messing with my indentation in line
"autocmd FileType markdown setlocal inde=
"autocmd FileType javascript.jsx setlocal inde=
"autocmd FileType typescript setlocal inde=
"autocmd FileType yaml setlocal inde=
hi Search cterm=NONE ctermfg=grey ctermbg=blue

" fzf
" nmap ; :Buffers<CR>
nmap <Leader>t :Files<CR>
" Don't really use this
nmap <Leader>r :Tags<CR>

"Use locally installed flow
let local_flow = finddir('node_modules', '.;') . '/.bin/flow'
if matchstr(local_flow, "^\/\\w") == ''
    let local_flow= getcwd() . "/" . local_flow
endif
if executable(local_flow)
  let g:flow#flowpath = local_flow
endif
let g:flow#enable = 0
autocmd FileType javascript nmap <buffer> <Leader>, :FlowType<CR>

" --------------- Finally colour scheme
syntax enable
set background=light
colorscheme solarized
hi Normal ctermbg=NONE " we want vim to follow terminal background

" Disable unsafe commands in project specific vimrc's
set secure
