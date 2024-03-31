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
" Gcd helps with the filenames issues if they use full rather than short paths
"
" https://github.com/junegunn/fzf.vim/issues/528#issuecomment-368260699
" cfdo and cdo
" Rg thing
" cdo s/thing/newthing/g | :w
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
runtime vim-repl.vim

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

if !exists('$VIM_VERY_FAST')
  if !exists('$VIM_FAST')
    " Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
    if filereadable(expand('~/.vim/autoload/plug.vim'))
      call plug#begin()
      runtime! vim-plugins.vim
      call plug#end()

      runtime! vim-plugins-after.vim
    endif
  else
    " Copy paste of what's in vim-plugins.vim
    call plug#begin()
    if has('nvim')
      Plug 'ishan9299/nvim-solarized-lua'
    else
      " For termguicolors
      if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
      endif
      Plug 'altercation/vim-colors-solarized'
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
    call plug#end()
  endif
else
  set nocursorline
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
    silent! colorscheme solarized
    " we want vim to follow terminal background
    hi Normal guibg=NONE
  endif
else
  syntax enable

  " Set color scheme
  set background=light
  silent! colorscheme solarized
endif

" we want vim to follow terminal background
hi Normal ctermbg=NONE

if !has('nvim')
  " https://github.com/airblade/vim-gitgutter/issues/696
  hi! link SignColumn LineNr
endif

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

