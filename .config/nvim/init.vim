" Allows us to split and reuse configs with `runtime filename.vim`
set runtimepath+=~

runtime .vim-help.vim

runtime .vim-config.vim

" REPL + code execution
runtime .vim-repl.vim

" My own links plugin
" Should eventually superseed: knsh14/vim-github-link
runtime .vim-links.vim

" ---------------------------------------- plugin settings
autocmd BufReadPost * if getfsize(@%) > 10000 | execute('NoMatchParen') | endif
"let g:loaded_matchparen=1

if filereadable(expand('~/.local/share/nvim/site/autoload/plug.vim'))
  call plug#begin()
  runtime .vim-plugins.vim
  runtime plug-plugins.vim
  call plug#end()

  runtime plug-plugins-after.vim
endif

" ---------------------------------------- Finally colour scheme
if exists('g:started_by_firenvim')
  set background=dark
  silent! colorscheme tokyonight
else
  set background=light
  silent! colorscheme solarized
endif
hi Normal ctermbg=NONE

" https://github.com/airblade/vim-gitgutter/issues/696
hi! link SignColumn LineNr

" overwrite colour scheme for folds
highlight Folded ctermfg=brown

" Disable unsafe commands in project specific vimrc's
set secure

