Bash Configuration
==================

This is just my bashrc configuration, plus some setup scripts

I'd like to setup some curses stuff too cause that's cool stuff! (rather than read or whatever bash runs for waiting for file input)

If you run a `.bash_profile` then you should probably add this:

```bash
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi 
```

Tmux Setup
----------
This requires TPM:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Vim Setup
---------
Install all these plugins:

### Looks
* vim-airline
* vim-gitgutter
* tmuxline.vim 

### Functions
* ctrlp.vim 
* nerdtree 
* syntastic - off by default...
* vim-argumentative - >,
* vim-fugitive - I only use it for gitgutter and git blame
* vim-surround - so many shortcuts - cs'"

### Languages
* vim-jade 
* vim-javascript 
* vim-markdown
* vim-stylus

### Syntax Completion
* YouCompleteMe
* tern_for_vim - tied together
