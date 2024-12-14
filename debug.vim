" vi -u ~/ws/dotfiles/debug.vim file.py
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath

scriptencoding utf-8

call plug#begin()
Plug 'machakann/vim-sandwich'
call plug#end()
