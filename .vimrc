" Ben Lu, vimrc
" :so ~/_vimrc " reloads vimrc, use in vim, not here
" ------------------------------------------------------------Main layout
set sw=2 sts=2 ts=2 number et is ai hls ru sc cursorline mouse=a laststatus=2 "shiftwidth, softtabstop, tabstop, linenumbers, softtabs, incsearch, autoindent, highlight search, ruler line col number, showcmd
hi CursorLine   cterm=bold,underline ctermbg=NONE ctermfg=NONE guibg=blue guifg=orange "Set cursor line highlight colours
set splitright splitbelow
set backspace=indent,eol,start "Without this, you can't backspace an indent or line
set scrolloff=1
set smartindent
set lazyredraw
set nobackup
set noswapfile
set tabpagemax=100
"au BufNewFile,BufRead * if &syntax == '' | setf java | endif "Set syntax to java if none set initially

" Tab completion, as much as possible, list options, then tab through each
" option
set wildmode=longest,list,full
set wildmenu

" ------------------------------------------------------------------Mappings
syntax on
set fdm=manual fdl=4 "foldmethod fdc=1 foldcolumn
"set shellcmdflag=-ic " Makes shell interactive, :! now runs all system calls
" set spell spelllang=en_nz " ]s [s ]S [S " next spelling error
nnoremap <Leader>s      :setl spell! spelllang=en_nz<CR> " ]s [s ]S [S " next spelling error
imap <S-space> <Esc>
imap jj <Esc>l
imap jk <Esc>
nnoremap <C-a> ggVG

"xnoremap p pgvy
xnoremap <silent> p p:let @"=@0<CR>

filetype plugin on
filetype plugin indent on
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

" Scroll mappings
:map <ScrollWheelUp> <C-Y>
:map <ScrollWheelDown> <C-E>

" set directory=~/tmp//,.,/var/tmp//,/tmp//
if &diff == 'nodiff'
    set shellcmdflag=-ic
endif

" This is just annoying
noremap K k

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

" --------------------------------Reload on focus
au FocusGained,BufEnter * :silent! !

" -------------------------------Extras
"/[^\x00-\x7F]
"p`[
noremap p p`[
nnoremap å <C-a>
nnoremap ≈ <C-x>

" ---------------------------------------------Stuff I don't really understand
"  Cursor Color
" if &term =~ "xterm\\|rxvt"
"   " use an orange cursor in insert mode
"   let &t_SI = "\<Esc>]12;orange\x7"
"   " use a red cursor otherwise
"   let &t_EI = "\<Esc>]12;red\x7"
"   silent !echo -ne "\033]12;red\007"
"   " reset cursor when vim exits
"   autocmd VimLeave * silent !echo -ne "\033]112\007"
"   " use \003]12;gray\007 for gnome-terminal
" endif

" When editing a file, always jump to the last cursor position
autocmd BufReadPost *
\ if ! exists("g:leave_my_cursor_position_alone") |
\ if line("'\"") > 0 && line ("'\"") <= line("$") |
\ exe "normal g'\"" |
\ endif |
\ endif

" Default mapping for mutli cursor (change at will)
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" This watches for changes and reloads vimrc where are changes
" augroup myvimrc
"     au!
"     au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
" augroup END

" Pathogen
" let g:pathogen_disabled = ['syntastic','vim-gitgutter','vim-jade','vim-javascript','vim-markdown','vim-stylus','vim-surround']
"let g:pathogen_disabled = ['syntastic']
"execute pathogen#infect()
"
"" Enable a blacklisted plugin.
"fun! s:loadPlugin(plugin_name)
"  " Remove the plugin from Pathogen's blacklist
"  call filter(g:pathogen_disabled, "v:val !=? '" . a:plugin_name ."'")
"  " Update runtimepath
"  call pathogen#surround($HOME . "/.vim/bundle/" . tolower(a:plugin_name))
"  " Load the plugin
"  " Note that this loads only one file (which is usually fine):
"  runtime plugin/*.vim
"  " Note that this uses the plugin name as typed by the user:
"  execute 'runtime! after/plugin/**/' . a:plugin_name . '.vim'
"  " Plugin-specific activation
"  if tolower(a:plugin_name) == 'youcompleteme'
"    call youcompleteme#Enable()
"  endif
"endf

" See h :command
"fun! s:loadPluginCompletion(argLead, cmdLine, cursorPos)
"  return filter(copy(g:pathogen_disabled), "v:val =~? '^" . a:argLead . "'")
"endf

"command! -nargs=1 -complete=customlist,s:loadPluginCompletion LoadPlugin call <sid>loadPlugin(<q-args>)
"
"" --------------------------plugin settings
runtime macros/matchit.vim


autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4
autocmd FileType markdown setlocal expandtab shiftwidth=4 softtabstop=4
"autocmd FileType tex :SyntasticToggleMode " disable syntastic for tex (slow)
"au FileType tex setlocal nocursorline

"augroup markdown
"    au!
"    au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
"augroup END




" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.vim/plugged')

Plug 'altercation/vim-colors-solarized'
" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'PeterRincker/vim-argumentative'
Plug 'airblade/vim-gitgutter'
"Plug 'ctrlpvim/ctrlp.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-unimpaired'
"Plug 'junegunn/vim-easy-align'
" vipga= " Visual Inner Paragraph (ga) align =
" gaip= " (ga) align Inner Paragraph =

"Plug 'keith/swift.vim'

"Plug 'tomtom/tlib_vim'
"Plug 'MarcWeber/vim-addon-mw-utils'
"Plug 'garbas/vim-snipmate'
"Plug 'honza/vim-snippets'

Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
"Plug 'plasticboy/vim-markdown'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
""Plug 'vim-syntastic/syntastic'
"Plug 'wavded/vim-stylus'
Plug 'zeekay/vim-beautify'
Plug 'mzlogin/vim-markdown-toc'
"
" New based on: https://statico.github.io/vim3.html
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

Plug 'prettier/vim-prettier', {
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue'] }
Plug 'mileszs/ack.vim'
Plug 'w0rp/ale'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
"Plug 'mhartington/nvim-typescript'
Plug 'Quramy/tsuquyomi'
Plug 'flowtype/vim-flow'

" Initialize plugin system
call plug#end()


let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0

let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<2-LeftMouse>'],
    \ 'AcceptSelection("t")': ['<cr>'],
    \ }

" Syntastic settings
nnoremap <C-w>E :SyntasticCheck<CR> :SyntasticToggleMode<CR>
let g:syntastic_mode_map = { 'mode': 'passive',
                            \ 'active_filetypes': [],
                            \ 'passive_filetypes': [] }

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']

let g:jsx_ext_required = 0

map <C-n> :NERDTreeToggle<CR>
let NERDTreeMapOpenInTab='<ENTER>'

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
autocmd FileType javascript.jsx setlocal inde=
autocmd FileType typescript setlocal inde=
autocmd FileType yaml setlocal inde=
hi Search cterm=NONE ctermfg=grey ctermbg=blue

" fzf
let mapleader=","
nmap ; :Buffers<CR>
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
function! SetupEnvironment()
  let l:path = expand('%:p')
  if l:path =~ 'aiden'
    autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue PrettierAsync
  endif
endfunction
autocmd! BufReadPost,BufNewFile * call SetupEnvironment()

syntax enable
set background=light
colorscheme solarized
