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
zstyle :compinstall filename ~'/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# ---------------------------------------- Custom
# Makes colourful ls and such from: https://github.com/seebi/dircolors-solarized/issues/10
# Should try find the light theme at some point
export CLICOLOR=1
export LSCOLORS=exfxfeaeBxxehehbadacea
# A lot of new stuff influenced by:
# https://gist.github.com/LukeSmithxyz/e62f26e55ea8b0ed41a65912fbebbe52
autoload -U colors && colors # named colours?

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# -----------vim cursor
# vim mode config
bindkey -v
# So that backspace deletes more things in insert -> normal -> insert mode
bindkey -v '^?' backward-delete-char

# Remove mode switching delay.
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
#zle -N zle-keymap-select
#zle-line-init() {
#    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
#    echo -ne "\e[5 q"
#}
#zle -N zle-line-init
#echo -ne '\e[5 q' # Use beam shape cursor on startup.
#preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# ---------------------------------- Other

[ -f .zshrc-personal ] && source .zshrc-personal
[ -f .zshrc-fzf ] && source .zshrc-fzf
[ -f .zshrc-prompt ] && source .zshrc-prompt
[ -f ~/.zshrc-extras ] && source ~/.zshrc-extras

# Has to be last
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters
[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

