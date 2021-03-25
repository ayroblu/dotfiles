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
    \\n <leader>yp for yanking the path
    \\n
    \\n text-obj
    \\n if, af for function
    \\n ci,w for camel case
    \\n cia for argument
    \\n ai,ii,aI, iI for indentation
    \\n
    \\n Undo Tree
    \\n g-, g+ to jump between undo tree branches
    \\n :earlier 5s - 5m, 5h, 5d, also :later
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
    \\n
    \\n repl + code execution:
    \\n <leader>e: Run lines and output (selection or whole file)
    \\n <leader>w: Run repl and push lines (selection or current line)
    \\n <leader>q: Close repl
    \\n <leader>p: Select pane target
    \\n
    \\n vim-exchange
    \\n cxc to cancel
    \\n
    \\n Abolish
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
    \\n coc.nvim
    \\n <leader>[j for previous error
    \\n <leader>]j for next error
    \\n <leader>gd go definition
    \\n <leader>gy go type definition
    \\n <leader>gi go implementation
    \\n <leader>gr go references
    \\n K Show docs
    \\n <leader>ac action (like imports)
    \\n :call popup_clear()
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
" help foldtext, disable and `set fillchars?` to see default
set fillchars=vert:\|
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
set synmaxcol=200 " Stop trying to syntax highlight after 200 characters. Vim is very slow with syntax highlighting

set foldmethod=syntax
set foldlevel=20

set updatetime=1000 "event when cursor stops moving for a second, for swp normally, but now is for checktime call below
" Ignore case except when there atleast one capital (disabled, prefer to use
" \c prefix instead)
"set ignorecase
"set smartcase

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
nnoremap <Leader>s :setl spell!<CR>

imap jj <Esc>l
imap jk <Esc>l

" movement in insert mode is nice to have
imap <c-l> <right>
imap <c-h> <left>
imap <c-j> <down>
imap <c-k> <up>

" https://stackoverflow.com/questions/15808767/vimrc-to-detect-remote-connection
let g:localSession = ($SSH_CLIENT == "")

" HOC for calling system with interactive flags which have the shell rc files
function Isystem(a, ...)
  if !g:localSession
    set shellcmdflag=-ic
  endif
  let l:res = ""

  if a:0 == 1
    let l:res = system(a:a, a:1)
  else
    let l:res = system(a:a)
  endif
  if !g:localSession
    set shellcmdflag=-c
  endif
  return l:res
endfunction

" copy and pasting
vnoremap <C-c> y:call Isystem("pbcopy", getreg("\""))<CR>
nnoremap <C-v><C-v> :call setreg("\"", Isystem("pbpaste"))<CR>p

" Highlight rows and columns with \l and \c, 'l to move, :match to remove
" highlighting
"nnoremap <silent> <Leader>l ml:execute 'match Search /\%'.line('.').'l/'<CR>
"nnoremap <silent> <Leader>c :execute 'match Search /\%'.virtcol('.').'v/'<CR>

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

" Scroll mappings
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

" This is just annoying
noremap K k
"autocmd FileType c,cpp nunmap <buffer> K

" Disable smart indenting for these langauges
autocmd FileType yaml setl indentexpr=
autocmd FileType html setl indentexpr=
autocmd FileType make setl indentexpr=
autocmd FileType sh setl indentexpr=
autocmd FileType scala setl indentexpr=

" Handle special file types: https://vim.fandom.com/wiki/Forcing_Syntax_Coloring_for_files_with_odd_extensions
"autocmd BufNewFile,BufRead PROJECT set syntax=yaml

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

" diffget for mergetool left and right is also local and remote
nnoremap <buffer> dgl :diffget LO<cr>
nnoremap <buffer> dgr :diffget RE<cr>

" Yank current file path
nnoremap yp :let @" = expand("%:p")<CR>

" Insert single character
nnoremap s :exec "normal i".nr2char(getchar())."\el"<CR>
nnoremap S :exec "normal a".nr2char(getchar())."\el"<CR>

" https://stackoverflow.com/questions/40289706/execute-selection-from-script-in-vim
"autocmd FileType rust xnoremap <buffer> <leader>e :w !echo 'fn main() {' "$(cat)" '}' > __temp.rs && cargo script __temp.rs; \rm __temp.rs<cr>
"autocmd FileType rust xnoremap <buffer> <leader><leader>e :w !echo "$(cat)" > __temp.rs && cargo script __temp.rs; \rm __temp.rs<cr>

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

function! s:CopyGitPath() range
  execute 'silent !printf "\%s\#n' . a:firstline . '" "$(git ls-tree --name-only --full-name HEAD %)" | pbcopy'
  redraw!
endfunction

nnoremap <Leader>ygp :call <SID>CopyGitPath()<CR>

" Search open buffers: https://vi.stackexchange.com/questions/2904/how-to-show-search-results-for-all-open-buffers
function! BuffersList()
  let all = range(0, bufnr('$'))
  let res = []
  for b in all
    if buflisted(b)
      call add(res, bufname(b))
    endif
  endfor
  return res
endfunction

function! GrepBuffers (expression)
  exec 'vimgrep/'.a:expression.'/ '.join(BuffersList())
  " https://stackoverflow.com/questions/1747091/how-do-you-use-vims-quickfix-feature
  copen
endfunction

command! -nargs=+ GrepBufs call GrepBuffers(<q-args>)

" -------------------------------- REPL + code execution
if !empty(glob("~/.vimrc-repl"))
  so ~/.vimrc-repl
endif

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

" ---------------------------------------------From Damian Conway
" https://github.com/ninrod/damian_conway_oscon_2013_tarball
" Color column 80th column
"highlight ColorColumn ctermbg=magenta
"call matchadd('ColorColumn', '\%81v', 100)

" EITHER the entire 81st column, full-screen...
highlight ColorColumn ctermbg=magenta
set colorcolumn=+1


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
if !empty(glob("~/.vimrc-plugins"))
  so ~/.vimrc-plugins
endif

" --------------- Finally colour scheme
syntax enable

set background=light
" Set color scheme
try
  colorscheme solarized
catch /^Vim(colorscheme):/
endtry
" https://github.com/airblade/vim-gitgutter/issues/696
highlight! link SignColumn LineNr

hi Normal ctermbg=NONE " we want vim to follow terminal background

" Have to set this last
nnoremap <leader>? :call ShowPersonalHelp()<cr>

" Disable unsafe commands in project specific vimrc's
set secure
