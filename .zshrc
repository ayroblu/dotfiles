# ----------------------------------------- plugin setup
[ -f ~/.zshrc-omz ] && source ~/.zshrc-omz

# Init setup
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
unsetopt beep
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/blu/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# ---------------------------------------- Custom
bindkey -v

[ -f ~/.zshrc-personal ] && source ~/.zshrc-personal
[ -f ~/.zshrc-prompt ] && source ~/.zshrc-prompt
function show_colours {
  for i in {0..255}; do printf "\x1b[38;5;${i}mcolor%-5i\x1b[0m" $i ; if ! (( ($i + 1 ) % 8 )); then echo ; fi ; done
}
alias cvim='vi ~/.vimrc'
alias ctmux='vi ~/.tmux.conf'
alias cbash="vi ~/.bashrc*"
alias czsh="vi ~/.zshrc*"
