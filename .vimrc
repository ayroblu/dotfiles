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
" ----------------------------------------------------------- Personal Help
runtime vim-help.vim

runtime vim-config.vim

" REPL + code execution
runtime vim-repl.vim

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
    set background=light
    silent! colorscheme solarized
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

" Disable unsafe commands in project specific vimrc's
set secure

