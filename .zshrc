# ----------------------------------------- plugin setup
#https://stackoverflow.com/questions/11378607/oh-my-zsh-disable-would-you-like-to-check-for-updates-prompt
DISABLE_AUTO_UPDATE="true"
[ -f ~/.zshrc-omz ] && source ~/.zshrc-omz

# Init setup
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
unsetopt beep
unsetopt sharehistory # set by omz
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/blu/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# ---------------------------------------- Custom
# Makes colourful ls and such from: https://github.com/seebi/dircolors-solarized/issues/10
# Should try find the light theme at some point
export CLICOLOR=1
export LSCOLORS=exfxfeaeBxxehehbadacea

# -----------vim cursor
# vim mode config
bindkey -v
# So that backspace deletes more things in insert -> normal -> insert mode
bindkey -v '^?' backward-delete-char

# Remove mode switching delay.
KEYTIMEOUT=5
# ---------------------------------- Other

[ -f ~/.zshrc-personal ] && source ~/.zshrc-personal
[ -f ~/.zshrc-prompt ] && source ~/.zshrc-prompt

function show_colours {
  for i in {0..255}; do printf "\x1b[38;5;${i}mcolor%-5i\x1b[0m" $i ; if ! (( ($i + 1 ) % 8 )); then echo ; fi ; done
}
