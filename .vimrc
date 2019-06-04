" Ben Lu, vimrc
" :so ~/_vimrc " reloads vimrc, use in vim, not here
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

" Tab completion, as much as possible, list options, then tab through each option
set wildmode=longest,list,full
set wildmenu

" Add characters for tabs and spaces on the end of lines
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif
set list

" https://stackoverflow.com/questions/25233859/vimdiff-immediately-becomes-stopped-job-crashes-terminal-when-i-try-to-fg-it-b
if &diff == 'nodiff'
    set shellcmdflag=-ic
endif


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
imap <S-space> <Esc>
imap jj <Esc>l
imap jk <Esc>

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
nnoremap ∆ :m .+1<CR>==
nnoremap ˚ :m .-2<CR>==
" inoremap <A-j> <Esc>:m .+1<CR>==gi
" inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap ∆ :m '>+1<CR>gv=gv
vnoremap ˚ :m '<-2<CR>gv=gv

" Scroll mappings
:map <ScrollWheelUp> <C-Y>
:map <ScrollWheelDown> <C-E>

" This is just annoying
noremap K k

" ----------------------------- Reload page on change
au CursorHold * checktime

"-----------------------------Functions
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

" Delete current file
command! DeleteFile :call delete(expand('%')) | bdelete!

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

"---------------------------- Moving cursor by display lines
" -  http://vim.wikia.com/wiki/Move_cursor_by_display_lines_when_wrapping
noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj
noremap  <buffer> <silent> 0 g0
noremap  <buffer> <silent> $ g$


" --------------------------------Insert single character
nnoremap s :exec "normal i".nr2char(getchar())."\el"<CR>
nnoremap S :exec "normal a".nr2char(getchar())."\el"<CR>

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
"Plug 'ctrlpvim/ctrlp.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'terryma/vim-multiple-cursors'
"Plug 'tpope/vim-unimpaired'
Plug 'sheerun/vim-polyglot'
"Plug 'junegunn/vim-easy-align'
" vipga= " Visual Inner Paragraph (ga) align =
" gaip= " (ga) align Inner Paragraph =

"Plug 'garbas/vim-snipmate'
"Plug 'honza/vim-snippets'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
"Plug 'tpope/vim-vinegar' " Making file management easier
"Plug 'tpope/vim-speeddating' "Understand dates if you want
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'zeekay/vim-beautify'
Plug 'vim-scripts/ReplaceWithRegister' "griw to replace inner word with register
Plug 'christoomey/vim-sort-motion' "sort with gsip
Plug 'mzlogin/vim-markdown-toc'
"
" New based on: https://statico.github.io/vim3.html
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
Plug 'mileszs/ack.vim'
Plug 'w0rp/ale'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
"Plug 'mhartington/nvim-typescript'
Plug 'Quramy/tsuquyomi'
Plug 'flowtype/vim-flow'

" Initialize plugin system
call plug#end()

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

" Stop tsuquyomi freezing on save, why do this in vim 8 though...
" let g:tsuquyomi_use_vimproc=1
let g:tsuquyomi_single_quote_import=1
let g:tsuquyomi_shortest_import_path = 1

" set rtp+=/usr/local/opt/fzf
" I don't like vim-jsx messing with my indentation in line
autocmd FileType markdown setlocal inde=
autocmd FileType javascript.jsx setlocal inde=
autocmd FileType typescript setlocal inde=
autocmd FileType yaml setlocal inde=
hi Search cterm=NONE ctermfg=grey ctermbg=blue

" fzf
let mapleader=","
" nmap ; :Buffers<CR>
nmap <Leader>t :Files<CR>
nmap <Leader>r :Tags<CR>

" ack -> ag
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

autocmd FileType typescript nmap <buffer> <Leader>, : <C-u>echo tsuquyomi#hint()<CR>
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

let g:prettier#exec_cmd_async = 1
let g:prettier#autoformat = 0

" http://vim.wikia.com/wiki/Project_specific_settings
" function! SetupEnvironment()
"   let l:path = expand('%:p')
"   if l:path =~ 'aiden'
"     autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue PrettierAsync
"   endif
" endfunction
" autocmd! BufReadPost,BufNewFile * call SetupEnvironment()
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync

" --------------- Finally colour scheme
syntax enable
set background=light
colorscheme solarized
hi Normal ctermbg=NONE " we want vim to follow terminal background
