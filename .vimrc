scriptencoding utf-8
" :so ~/_vimrc " reloads vimrc, use in vim, not here, or quit and use `vis` if
" you have sessions setup
" Use `vim -u None file.txt` if big
" Use `gq` to format comments at textwidth
" Find and replace: use :%s/regex/replacement/g (or
" :%s#regex/path#replacement#g)
" For practice you may want to run on the current line with :s/ and then run
" g& afterwards when you're sure it's right
" g; to go to last change in the change list, g, to go to a newer
" gf opens file under cursor
" :X - Use encryption with current file
"
" Thoughts on how to do interactive shell:
" 1. yank current selection to 'interactive' buffer
" 2. run current selection in interactive shell: https://stackoverflow.com/questions/40289706/execute-selection-from-script-in-vim
"   - :'<,'>w !python
" 3. Do a setup in a project vimrc
" 4. Run buffer in interactive shell
" ----------------------------------------------------------- Personal Help
function ShowPersonalHelp()
  echo "<leader>? for this help
    \\n align: <visual> ga=
    \\n Close all buffers: :bufdo bd
    \\n Spelling: <leader>s ]s [s ]S [S
    \\n <insert> <c-u> to undo in insert mode
    \\n <leader>o to open the tagbar
    \\n <leader><leader>f<char> easy motion find (F for reverse)
    \\n <leader>u to open links under the cursor
    \\n :BufDelete to interactively close buffers
    \\n :BufOnly for closing all except current buffer
    \\n
    \\n netrw:
    \\n gn for changing root
    \\n <c-s-6> for returning to writing buffer
    \\n
    \\n fzf:
    \\n <leader>t to fzf show files
    \\n <leader><leader>t to fzf show tags
    \\n <leader><leader>r to fzf show tags in current buffer
    \\n `:Rg query` to search with ripgrep
    \"
  if &filetype ==# 'python'
    echo "\npython:
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
    echo "\nmarkdown:
      \\n Generate markdown: :GenTocGFM
      \"
  endif
endfunction
" ------------------------------------------------------------Main layout
set shiftwidth=2
set softtabstop=2
set tabstop=2

set number
set expandtab
set incsearch
set autoindent
set hlsearch
set ruler
set showcmd

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

set foldmethod=manual
set foldlevel=4

set updatetime=1000 "event when cursor stops moving for a second, for swp normally, but now is for checktime call below
" Ignore case except when there atleast one capital
set ignorecase
set smartcase

" Always report the number of lines changed by a command
set report=0

" Sentances that end in period join with 1 space, not two
set nojoinspaces

" Do not move the cursor to the first non-blank when jumping (ctrl-d etc)
set nostartofline

" Default to 80 so that `gq` doesn't wrap at 79 (haven't tested this)
" Makes markdown auto new line which is kinda annoying
"set textwidth=80

" Display as much as possible of cut off lines rather than truncating
set display=lastline

" https://stackoverflow.com/questions/26708822/why-do-vim-experts-prefer-buffers-over-tabs
set hidden " can switch to another buffer when you have unsaved changes

" Tab completion, as much as possible, list options, then tab through each option
set wildmode=longest,list,full
set wildmenu

" Maintain undo history between sessions
" https://jovicailic.org/2017/04/vim-persistent-undo/
" https://stackoverflow.com/questions/1549263/how-can-i-create-a-folder-if-it-doesnt-exist-from-vimrc
if !isdirectory($HOME.'/.vim/undodir')
  call mkdir($HOME.'/.vim/undodir', 'p')
endif
set undodir=~/.vim/undodir
set undofile

" Set spelling settings, use ]s [s for next previous spelling error, zg to add
" to spellfile, z= to see similar words
" Includes all the regions such as en_us en_nz
set spelllang=en
set spellfile=~/.spellfile.utf-8.add
" set spellsuggest=double " if you want to use a super slow but phoentic
" version v normal just edit distance

" Encryption method, defaults to super weak
set cryptmethod=blowfish2

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
if &diff ==# 'nodiff'
    "set shellcmdflag=-ic
endif

let mapleader=' '

"enable's syntax highlighting, corrollary: https://stackoverflow.com/questions/33380451/is-there-a-difference-between-syntax-on-and-syntax-enable-in-vimscript
syntax enable

" https://vi.stackexchange.com/questions/10124/what-is-the-difference-between-filetype-plugin-indent-on-and-filetype-indent
" filetype - detection - detect type of syntax by filetype
" plugin - allow plugins (not sure this is necessary as we use vim-plug)
" indent - indent file helps with indenting
filetype plugin indent on

" ------------------------------------------------------------- netrw

" netrw is kinda a plugin? Makes it a tree FYI
" https://shapeshed.com/vim-netrw/#nerdtree-like-setup
" Probably can remove vim-vinegar in favour of personalised setup
let g:netrw_liststyle = 3

" https://vi.stackexchange.com/questions/14622/how-can-i-close-the-netrw-buffer
autocmd FileType netrw setl bufhidden=wipe
let g:netrw_fastbrowse = 0
autocmd FileType netrw nmap <buffer> h -
autocmd FileType netrw nmap <buffer> l gn
autocmd FileType netrw nmap <buffer> v :Vifm<cr>

" ------------------------------------------------------------------Mappings
" set spell spelllang=en_nz " ]s [s ]S [S " next spelling error
"nnoremap <Leader>s setl spell!
nnoremap <Leader>s :setl spell!<CR>

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
nmap <C-v><C-v> :call setreg("\"",system("pbpaste"))<CR>P

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

" Window mappings (use alt hjkl)
nnoremap ˙ <C-w>h
nnoremap ∆ <C-w>j
nnoremap ˚ <C-w>k
nnoremap ¬ <C-w>l

" Incrementing and decrementing visual blocks
" https://stackoverflow.com/questions/23481635/how-to-use-vims-normal-mode-ctrl-a-number-increment-in-visual-block-mode
xnoremap <C-a> :<C-u>let vcount = v:count ? v:count : 1 <bar> '<,'>s/\%V\d\+/\=submatch(0) + vcount <cr>gv
xnoremap <C-x> :<C-u>let vcount = v:count ? v:count : 1 <bar> '<,'>s/\%V\d\+/\=submatch(0) - vcount <cr>gv

" show errors if you want (need to work out how to show automatically)
nmap <c-l> :lwindow<cr>

" Move line up or down with alt key not really useful, given to window
" mappings
" <A-j>: ∆, <A-k>: ˚
" nnoremap <A-j> :m .+1<CR>==
" nnoremap <A-k> :m .-2<CR>==
" nnoremap ∆ :m .+1<CR>==
" nnoremap ˚ :m .-2<CR>==
" " inoremap <A-j> <Esc>:m .+1<CR>==gi
" " inoremap <A-k> <Esc>:m .-2<CR>==gi
" vnoremap ∆ :m '>+1<CR>gv=gv
" vnoremap ˚ :m '<-2<CR>gv=gv

" Scroll mappings
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

" This is just annoying
noremap K k
autocmd FileType c,cpp unmap <buffer> K

" nnoremap <C-L> :redraw!

" delete without yanking
"nnoremap d "_d
"vnoremap d "_d
" replace currently selected text with default register
" without yanking it
vnoremap p "_dp

" Moving cursor by display lines
" -  http://vim.wikia.com/wiki/Move_cursor_by_display_lines_when_wrapping
noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj
noremap  <buffer> <silent> 0 g0
noremap  <buffer> <silent> $ g$


" Insert single character
nnoremap s :exec "normal i".nr2char(getchar())."\el"<CR>
nnoremap S :exec "normal a".nr2char(getchar())."\el"<CR>

" https://stackoverflow.com/questions/40289706/execute-selection-from-script-in-vim
"autocmd FileType javascript nnoremap <buffer> <leader>e :w !node<cr>
"autocmd FileType typescript,typescript.tsx,typescriptreact nnoremap <buffer> <leader>e :w !npx ts-node -T<cr>
"autocmd FileType rust xnoremap <buffer> <leader>e :w !echo 'fn main() {' "$(cat)" '}' > __temp.rs && cargo script __temp.rs; \rm __temp.rs<cr>
"autocmd FileType rust xnoremap <buffer> <leader><leader>e :w !echo "$(cat)" > __temp.rs && cargo script __temp.rs; \rm __temp.rs<cr>
" Execute clipboard in node
"autocmd FileType javascript nnoremap <buffer> <leader>e :echo system('node', @")<cr>

" Cycle 2 registers: https://vim.fandom.com/wiki/Comfortable_handling_of_registers
" DEPRECATED: Just use vim-yoink
"nnoremap <Leader>j :let @x=@" \| let @"=@a \| let @a=@x<CR>
" nnoremap <Leader>k :let @x=@" \| let @"=@a \| let @a=@b \| let @b=@x \| reg "ab<CR>
" Appending to register
"nnoremap Y :let @C=@" \| let @"=@c<CR>
" Clear
"nnoremap YY :let @c=@"<CR>

" ------ Allow undo in insert mode
inoremap <c-u> <esc>ua
" https://vi.stackexchange.com/questions/16773/how-to-undo-the-deletion-of-characters-in-insert-mode-caused-by-ctrl-u
" Break on cr so that you can undo an enter with indenting
inoremap <cr> <c-g>u<cr>

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
autocmd BufWritePre * :keeppatterns %s/\s\+$//e

" Switch to last buffer :b#

"" Set cursor based on insert v normal mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" optional reset cursor on start:
augroup myCmds
  autocmd!
  autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END

" Normally you can open a url with gx, doesnt work so use <leader>u
" Hint, can also open files with gf
function! HandleURL()
  let s:uri = matchstr(getline('.'), '[a-z]*:\/\/[^ >,;]*')
  echo s:uri
  if s:uri !=# ''
    silent exec "!open '".s:uri."'"
  else
    echo 'No URI found in line.'
  endif
  redraw!
endfunction
map <leader>u :call HandleURL()<cr>

" Restore cursor position horizontally when switching buffer
" Switching tabs this is weird??
"autocmd BufEnter * silent! normal! g`"

" A few personal aliases that make editing certain files easier
command Cvim :n ~/.vimrc
command Czsh :n ~/.zshrc*
command Cbash :n ~/.bashrc*
command Ctmux :n ~/.tmux.conf
command Cnotes :n ~/Dropbox/Notes/*

" clear auto commands with !au (if you want) and reload vim, can use RestartVim in MacVim?
command Reload :au! | so ~/.vimrc

command NoUndo :silent exec "!rmtrash ~/.vim/undodir" | redraw!

" Displays buffer list, prompts for buffer numbers and ranges and deletes
" associated buffers. Example input: 2 5,9 12
" Hit Enter alone to exit.
function! InteractiveBufDelete()
  let l:prompt = 'Specify buffers to delete: '

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
command! BufDelete :call InteractiveBufDelete()

" Close all except current buffer
" https://stackoverflow.com/questions/4545275/vim-close-all-buffers-but-this-one
command BufOnly :%bd|e#

" https://stackoverflow.com/questions/19430200/how-to-clear-vim-registers-effectively
function ClearReg()
  let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
  for r in regs
    call setreg(r, [])
  endfor
endfunction
command! ClearReg :call ClearReg()

" Based on https://github.com/NLKNguyen/pipe-mysql.vim/blob/master/plugin/pipe-mysql.vim
autocmd FileType javascript,javascriptreact let b:pipe_shell_command = 'node'
autocmd FileType typescript,typescriptreact let b:pipe_shell_command = 'npx ts-node -T'
autocmd FileType python let b:pipe_shell_command = 'python'
autocmd FileType matlab let b:pipe_shell_command = 'octave'
autocmd FileType sh let b:pipe_shell_command = 'bash'
fun! RunScript() range
  if empty(b:pipe_shell_command)
    echo 'No shell command'
    return
  endif
  let s:tempfilename = tempname()
  let l:shell_command = 'cat ' . s:tempfilename . ' | sed ''s/^/> /''' . " && "
  let l:shell_command .= 'echo ''==================''' . " && "
  let l:shell_command .= b:pipe_shell_command . ' < ' . s:tempfilename . " && "
  let l:shell_command .= 'echo ''=================='''

  let l:textlist = g:PipeGetSelectedTextAsList()
  if len(l:textlist) == 0
    let l:textlist = getline(1, '$')
  endif
  call writefile(l:textlist, s:tempfilename, 's')

  call g:Pipe(l:shell_command)

  call delete(s:tempfilename)
endfun
xnoremap <leader>e :call RunScript()<cr>
nnoremap <leader>e :call RunScript()<cr>

"-----------------------------Set pasting to automatically go paste mode
" - https://coderwall.com/p/if9mda
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ''
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
if filereadable(expand('~/.vim/autoload/plug.vim'))
  call plug#begin('~/.vim/plugged')

  " === Theme
  Plug 'altercation/vim-colors-solarized'
  "Plug 'edkolev/tmuxline.vim'
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
  let g:airline#extensions#tmuxline#enabled = 0

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  let g:airline_extensions = []
  let g:airline#extensions#branch#enabled=1
  let g:airline#extensions#branch#empty_message='no repo'
  let g:airline_theme='solarized'

  " === Hooks
  Plug 'airblade/vim-gitgutter'
  let g:gitgutter_realtime = 0
  let g:gitgutter_eager = 0

  Plug 'svermeulen/vim-yoink'
  nmap <c-n> <plug>(YoinkPostPasteSwapBack)
  nmap <c-p> <plug>(YoinkPostPasteSwapForward)
  nmap [y <plug>(YoinkRotateBack)
  nmap ]y <plug>(YoinkRotateForward)
  nmap p <plug>(YoinkPaste_p)
  nmap P <plug>(YoinkPaste_P)
  " :Yanks

  Plug 'vifm/vifm.vim'

  Plug 'tpope/vim-dispatch'
  " Use :Dispatch <run test/build cmd> (or :Make but that's make specific?)
  " :Focus <cmd> to pin a command so that you can just call :Dispatch without
  " args everytime

  Plug 'tpope/vim-fugitive'
  " Move between changes with [c and ]c
  " Move files with :Gmove <c-r>%

  Plug 'NLKNguyen/pipe.vim'

  Plug 'craigemery/vim-autotag'
  " Requires python support, but refreshes ctags if it's there
  " More info on tags generally:
  " https://andrew.stwrt.ca/posts/vim-ctags/
  " <c-x><c-]> for tag completion
  " <c-]> go to first match
  " g<c-]> got to match if only one, else, show list
  " g] show list of tags

  Plug 'tpope/vim-sleuth'
  " Indentation detection

  Plug 'osyo-manga/vim-anzu' " show search progress
  " mapping
  nmap n <Plug>(anzu-n-with-echo)
  nmap N <Plug>(anzu-N-with-echo)
  nmap * <Plug>(anzu-star-with-echo)
  nmap # <Plug>(anzu-sharp-with-echo)

  " clear status
  nmap <Esc><Esc> <Plug>(anzu-clear-search-status)
  " Show in search status - will override file name so kinda meh
  "let g:airline_section_c='%{anzu#search_status()}'

  Plug 'Valloric/MatchTagAlways'
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

  Plug 'xolox/vim-misc'
  Plug 'xolox/vim-session'
  let g:session_autosave = 'yes'
  let g:session_autoload = 'no'
  let g:session_default_overwrite = 1
  " Basically you just care about :OpenSession, don't worry about anything else
  " Sometimes you need to worry about :DeleteSession

  " === Commands and functions
  Plug 'PeterRincker/vim-argumentative'
  " <, or >, for move argument left or right

  " Plug 'terryma/vim-multiple-cursors'

  Plug 'junegunn/vim-easy-align'
  xmap ga <Plug>(EasyAlign)
  " vipga= " Visual Inner Paragraph (ga) align =
  " Visually select what you want to align, `g``a``=` to align on equals sign

  Plug 'tpope/vim-unimpaired'
  " I only download this for the conflict mapping ]n and [n

  Plug 'tpope/vim-abolish'
  " Press crs (coerce to snake_case). MixedCase (crm), camelCase (crc),
  " snake_case (crs), UPPER_CASE (cru), dash-case (cr-), dot.case (cr.), space
  " case (cr<space>), and Title Case (crt)

  Plug 'FooSoft/vim-argwrap'
  " Pointless given prettier, but can be useful?
  nnoremap <silent> <leader>a :ArgWrap<CR>

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

  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-commentary'
  " gc to comment

  "Plug 'vim-scripts/ReplaceWithRegister' "griw to replace inner word with register
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'
  noremap <leader><Tab> :Buffers<CR>
  nmap <Leader>t :Files<CR>
  nmap <Leader><leader>r :BTags<CR>
  nmap <Leader><Leader>t :Tags<CR>
  " Custom setup for previews on Rg and Files
  command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)
  command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)
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
  " https://github.com/junegunn/fzf
  " sbtrkt	fuzzy-match	Items that match sbtrkt
  " 'wild	exact-match (quoted)	Items that include wild
  " ^music	prefix-exact-match	Items that start with music
  " .mp3$	suffix-exact-match	Items that end with .mp3
  " !fire	inverse-exact-match	Items that do not include fire
  " !^music	inverse-prefix-exact-match	Items that do not start with music
  " !.mp3$	inverse-suffix-exact-match	Items that do not end with .mp3

  Plug 'easymotion/vim-easymotion'
  " Mainly use this to search
  " <leader><leader>f<char>
  " <leader><leader>F<char>

  Plug 'tpope/vim-vinegar' " Making netrw file management easier
  " `-` to jump in
  " `y``.` to yank absolute path
  " `~` to go home
  " `ctrl``shift``6` to go back to editing (doesn't work for me, just use :bd)
  " `.` to auto prepopulate `:` command with file, `!` for shell:
  " e.g. `!chmod +x` for `:!chmod +x path/to/file`

  Plug 'jalvesaq/vimcmdline'
  " vimcmdline mappings (local leader is \\)
  " let cmdline_map_start          = '<LocalLeader>s'
  let cmdline_map_send           = '<LocalLeader><Space>'
  " let cmdline_map_send_and_stay  = '<LocalLeader><Space>'
  " let cmdline_map_source_fun     = '<LocalLeader>f'
  " let cmdline_map_send_paragraph = '<LocalLeader>p'
  " let cmdline_map_send_block     = '<LocalLeader>b'
  " let cmdline_map_quit           = '<LocalLeader>q'
  let cmdline_app = {
    \  'typescript': 'npx ts-node -T',
    \}

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
  nnoremap <leader>o :TagbarToggle<cr>
  "autocmd VimEnter * nested :call tagbar#autoopen(1)

  " === Text objects
  "Plug 'wellle/targets.vim'
  " Doesn't work for me
  " Has lots of text object things for brackets, quotes, commas arguments
  " daa - delete argument with comma
  " cIa - change in comma

  Plug 'bkad/CamelCaseMotion'
  let g:camelcasemotion_key = ','
  " Use , as camel case word object: i.e. ci,w

  Plug 'vim-scripts/argtextobj.vim'
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
  Plug 'sheerun/vim-polyglot'
  " autocmd chaining: https://vi.stackexchange.com/questions/3968/is-there-a-way-to-and-events-in-the-autocmd
  " jedi sets conceal level, so set it back for markdown files
  autocmd FileType markdown autocmd BufReadPost,CursorHold <buffer> set conceallevel=0

  Plug 'mzlogin/vim-markdown-toc'
  let g:vmt_list_item_char='-'
  " :GenTocGFM

  Plug 'romainl/vim-devdocs'
  " :DD source name
  " If not for the language

  Plug 'davidhalter/jedi-vim'
  " We change these to be similar to tsuquyomi
  let g:jedi#goto_command = '<C-]>'
  "let g:jedi#goto_assignments_command = ""
  let g:jedi#goto_definitions_command = '<C-}>'
  let g:jedi#documentation_command = 'K'
  let g:jedi#usages_command = '<leader>n'
  let g:jedi#completions_command = '<C-x><C-o>'
  let g:jedi#rename_command = '<leader>r'
  let g:jedi#popup_select_first = 0
  autocmd FileType python nnoremap <buffer> <leader>b :cclose<cr>

  Plug 'tell-k/vim-autoflake'
  " :Autoflake to remove unused imports
  let g:autoflake_remove_unused_variables=0
  let g:autoflake_remove_all_unused_imports=1
  "autocmd FileType python autocmd BufWritePre <buffer> Autoflake
  let g:autoflake_disable_show_diff=1
  command! Aflake :call Autoflake() | redraw!

  " Warning, need to use Augroup soon
  " https://stackoverflow.com/questions/10969366/vim-automatically-formatting-golang-source-code-when-saving/10969574

  Plug 'ayroblu/python-imports.vim'
  " Use :ImportName, also ~/.vim/python-imports.cfg
  autocmd FileType python nnoremap <buffer> <leader>i :ImportName<cr>

  Plug 'w0rp/ale'
  "autocmd FileType typescript,typescript.jsx let g:ale_linters = findfile('.eslintrc', '.;') != '' ? {'typescript': ['eslint']} : {'typescript': []}
  autocmd FileType javascript,javascriptreact,typescript,typescriptreact let b:ale_linters = []
  autocmd FileType javascript let b:ale_linters_ignore = ['tsserver']
  " Enable ale for things coc doesn't support yet
  autocmd FileType vim nmap <silent> ]j :ALENextWrap<cr>
  autocmd FileType vim nmap <silent> [j :ALEPreviousWrap<cr>
  "\ 'typescript': ['tslint', 'eslint', 'prettier'],
  "\ 'typescript.tsx': ['tslint', 'eslint', 'prettier'],
  "\ 'typescriptreact': ['tslint', 'eslint', 'prettier'],
  "\ 'javascript': ['eslint', 'prettier'],
  "\ 'css': ['prettier'],
  "\ 'json': ['prettier'],
  "\ 'scala': ['scalafmt'],
  " Still use ale for python
  " ALE uses prettier only if it's installed - preferred for markdown
  let g:ale_fixers = {
  \ 'python': ['isort'],
  \ 'markdown': ['prettier'],
  \}
  let g:ale_pattern_options = {
  \   '.*\.json$': {'ale_enabled': 0},
  \}
  let g:ale_fix_on_save = 1
  "let g:ale_javascript_prettier_use_local_config = 1
  let g:vim_markdown_new_list_item_indent = 0
  " Disable the loclist (just annoying right now) can be opened with :lopen
  let g:ale_open_list=0

  " Rust vim specific
  " http://seenaburns.com/vim-setup-for-rust/
  "  - Cleaner
  " https://about.okhin.fr/2018/08/03/my-vim-setup-with-some-rust-specifities/
  "  - more ide
  " https://asquera.de/blog/2017-03-03/setting-up-a-rust-devenv/
  "  - vscode
  let g:rustfmt_autosave = 1
  autocmd FileType rust let b:ale_linters = {'rust': ['rls']}
  autocmd FileType rust nnoremap <buffer> <leader>e :RustRun<cr>
  "au BufNewFile,BufReadPost *.md set filetype=markdown

  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " Hopefully this will replace ale and some of the others
  let g:coc_global_extensions = [
        \'coc-metals',
        \'coc-tsserver',
        \'coc-prettier',
        \'coc-tslint',
        \'coc-eslint',
        \'coc-json',
        \'coc-vimlsp',
        \'coc-css'
        \]
  " vscode + coc config uses jsonc
  " https://github.com/neoclide/coc.nvim/wiki/Using-the-configuration-file
  autocmd FileType json syntax match Comment +\/\/.\+$+
  inoremap <silent><expr> <c-x><c-o> coc#refresh()
  " Checkout the following as <c-space> is interpreted as <c-@>
  " https://stackoverflow.com/questions/24983372/what-does-ctrlspace-do-in-vim
  inoremap <silent><expr> <c-@> coc#refresh()
  inoremap <silent><expr> <c-space> coc#refresh()
  " Use `[g` and `]g` to navigate diagnostics
  nmap <silent> [j <Plug>(coc-diagnostic-prev)
  nmap <silent> ]j <Plug>(coc-diagnostic-next)

  " GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Use K to show documentation in preview window.
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  " Remap keys for applying codeAction to the current line.
  nmap <leader>ac  <Plug>(coc-codeaction)

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  augroup typescript
    au!
    " Tag like go to definition
    autocmd FileType typescript,javascript,typescriptreact,javascriptreact nmap <silent> <c-]> <Plug>(coc-definition)

    " Symbol renaming.
    autocmd FileType typescript,javascript,typescriptreact,javascriptreact nmap <leader>r <Plug>(coc-rename)
  augroup END

  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Introduce function text object
  " " NOTE: Requires 'textDocument.documentSymbol' support from the language
  " server.
  xmap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap if <Plug>(coc-funcobj-i)
  omap af <Plug>(coc-funcobj-a)

  "Plug 'racer-rust/vim-racer'
  let g:racer_experimental_completer = 1
  let g:racer_insert_paren = 1
  " au FileType rust nmap <leader>k <Plug>(rust-def)
  au FileType rust nmap <leader><leader>k <Plug>(rust-def-split)
  " au FileType rust nmap gx <Plug>(rust-def-vertical)
  au FileType rust nmap <leader>k <Plug>(rust-doc)
  "au FileType rust au User ALELint lwindow
  "au FileType rust au FocusGained,BufEnter,CursorHold,CursorHoldI * lwindow

  "Plug 'Quramy/tsuquyomi'
  let g:tsuquyomi_single_quote_import=1
  let g:tsuquyomi_shortest_import_path = 1
  " Stop tsuquyomi freezing on save, why do this in vim 8 though...
  let g:tsuquyomi_disable_quickfix = 1
  autocmd FileType typescript,typescript.tsx,typescriptreact nmap <buffer> <Leader>k : <C-u>echo tsuquyomi#hint()<CR>
  " It takes like 30+ seconds gets kinda pointless
  " autocmd FileType typescript
  "     \ autocmd BufWritePost <buffer> :TsuquyomiAsyncGeterr
  " vim8.2 uses typescriptreact, not typescript.tsx
  augroup typescriptreact
    au!
    autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx
  augroup END

  " Twitter specific
  "Plug 'jrozner/vim-antlr'
  Plug 'pantsbuild/vim-pants'

  " === old

  "Plug 'garbas/vim-snipmate'
  "Plug 'honza/vim-snippets'

  "Plug 'tpope/vim-speeddating' "Understand dates if you want
  "Plug 'zeekay/vim-beautify'

  " Initialize plugin system
  call plug#end()
endif

" --------------- Finally colour scheme
syntax enable

set background=light
" Set color scheme
try
  colorscheme solarized
catch /^Vim(colorscheme):/
endtry
hi Normal ctermbg=NONE " we want vim to follow terminal background

" Have to set this last
nnoremap <leader>? :call ShowPersonalHelp()<cr>

" Disable unsafe commands in project specific vimrc's
set secure
