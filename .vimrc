" Allows us to split and reuse configs with `runtime filename.vim`
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
" :cq - quit mergetool with failure
" Test colours: :source $VIMRUNTIME/syntax/colortest.vim
"
" Thoughts on how to do interactive shell:
" 1. yank current selection to 'interactive' buffer
" 2. run current selection in interactive shell: https://stackoverflow.com/questions/40289706/execute-selection-from-script-in-vim
"   - :'<,'>w !python
" 3. Do a setup in a project vimrc
" 4. Run buffer in interactive shell
"
" Normal mode in command line:
" https://stackoverflow.com/questions/7186880/using-normal-mode-motions-in-command-line-mode-in-vim
" C-f to open (set cedit=C-f)
" Enter to run the command and C-c will go back to standard cmd line
" <Tab> or C-X C-V will open auto complete
" :help c_ctrl-f
" ----------------------------------------------------------- Personal Help
runtime vim-help.vim

runtime vim-config.vim

" REPL + code execution
if !has('nvim')
  runtime vim-repl.vim
endif

" Checkbox helper for markdown
runtime vim-checkbox.vim

" My own links plugin
" Should eventually superseed: knsh14/vim-github-link
runtime vim-links.vim

"" --------------------------plugin settings
if has('nvim')
  autocmd BufReadPost * if getfsize(@%) > 10000 | execute('NoMatchParen') | endif
else
  runtime macros/matchit.vim
endif

" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
if filereadable(expand('~/.vim/autoload/plug.vim'))
  call plug#begin()
  runtime! vim-plugins.vim
  call plug#end()

  runtime! vim-plugins-after.vim
endif

" --------------- Finally colour scheme
if has('nvim')
  if exists('g:started_by_firenvim')
    set background=dark
    silent! colorscheme tokyonight
  else
    if has("termguicolors")
      set termguicolors
    endif
    set background=light
    silent! colorscheme NeoSolarized
  endif
else
  syntax enable

  " Set color scheme
  set background=light
  silent! colorscheme solarized
endif

" we want vim to follow terminal background
hi Normal ctermbg=NONE

" https://github.com/airblade/vim-gitgutter/issues/696
hi! link SignColumn LineNr

" overwrite colour scheme for folds
highlight Folded ctermfg=brown

" for MacVim, env vars
if $BAT_THEME == ""
  " Normally use "GitHub" theme but since it doesn't support markdown, and
  " macvim's primary purpose is to review markdown, use a different theme:
  " https://github.com/sharkdp/bat/issues/1153
  let $BAT_THEME = 'Monokai Extended Light'
endif

" Disable unsafe commands in project specific vimrc's
set secure

