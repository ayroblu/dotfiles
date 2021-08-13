#echo "zsh loading..."
# benchmark with: for i in $(seq 1 10); do /usr/bin/time /bin/zsh -d -i -c exit; done
# ----------------------------------------- plugin setup
# man zshoptions - for all the setopt commands
# https://stackoverflow.com/questions/11378607/oh-my-zsh-disable-would-you-like-to-check-for-updates-prompt
#DISABLE_AUTO_UPDATE="true"
#[ -f ~/.zshrc-omz ] && source ~/.zshrc-omz
#unsetopt sharehistory # set by omz
#HIST_STAMPS="yyyy-mm-dd"

# ------------------------------------- History
setopt inc_append_history
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it

# Init setup
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=10000

# -------------------------------------- Directories
setopt auto_pushd # automatically push to stack
setopt pushd_ignore_dups
setopt pushd_minus # + and - are flipped
setopt auto_cd # .. to go up

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias md='mkdir -p'
alias rd=rmdir

# ------------------------------------- functions
# https://stackoverflow.com/a/34143401
exists() {
  command -v "$1" >/dev/null 2>&1
}
# -------------------------------------- Misc
setopt interactive_comments # support # comments
setopt long_list_jobs # todo: not sure yet
setopt multios # support ls -1 > file.txt | less
setopt prompt_subst # todo: prompts?
unsetopt beep

# Makes colourful ls and such from: https://github.com/seebi/dircolors-solarized/issues/10
# Should try find the light theme at some point
export CLICOLOR=1
export LSCOLORS=exfxfeaeBxxehehbadacea
# A lot of new stuff influenced by:
# https://gist.github.com/LukeSmithxyz/e62f26e55ea8b0ed41a65912fbebbe52
autoload -U colors && colors # named colours?

_comp_options+=(globdots)		# Include hidden files.

export PAGER='less'
export LESS='-R'

# -----------vim cursor
# vim mode config
bindkey -v
# So that backspace deletes more things in insert -> normal -> insert mode
bindkey -v '^?' backward-delete-char

# Remove mode switching delay.
export KEYTIMEOUT=1

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

[ -f ~/.zshrc-comp ] && source ~/.zshrc-comp
[ -f ~/.sharedshrc ] && source ~/.sharedshrc
[ -f ~/.zshrc-personal ] && source ~/.zshrc-personal
if exists fzf; then
  [ -f ~/.zshrc-fzf ] && source ~/.zshrc-fzf
  [ -f ~/.zshrc-fzf-completion ] && source ~/.zshrc-fzf-completion
fi
[ -f ~/.zshrc-prompt ] && source ~/.zshrc-prompt
[ -f ~/.zshrc-extras ] && source ~/.zshrc-extras

# Has to be last
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters
[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

