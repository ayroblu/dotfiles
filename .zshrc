#echo "zshrc loading..."
# benchmark with: for i in $(seq 1 10); do /usr/bin/time /bin/zsh -d -i -c exit; done
#   -f to run without .zshrc
# OR: Add zmodload zsh/zprof at the top of your ~/.zshrc and zprof at the bottom
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
# https://unix.stackexchange.com/questions/433273/changing-cursor-style-based-on-mode-in-both-zsh-and-vim
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
zle -N zle-keymap-select

_fix_cursor() {
   echo -ne '\e[5 q'
}

precmd_functions+=(_fix_cursor)

# ------------------------------------- functions
# https://stackoverflow.com/a/34143401
exists() {
  command -v "$1" >/dev/null 2>&1
}
source-if-exists() {
  local file="$1"
  [ -f "$file" ] && source "$file"
}

# ----------- other
# homebrew lesspipe.sh
#export LESSOPEN="|/usr/local/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1
[ -d "$HOMEBREW_PREFIX"/share/zsh/site-functions ] && fpath=("$HOMEBREW_PREFIX"/share/zsh/site-functions $fpath)

# ------------------------------------------------------ zsh plugins
# Using personal custom plugin manager
source-if-exists ~/.zshrc-plugin-manager
source-if-exists ~/.zshrc-plugins

# ---------------------------------- dependents

source-if-exists ~/.sharedshrc
source-if-exists ~/.zshrc-personal
if exists fzf; then
  source-if-exists ~/.zshrc-fzf
  source-if-exists ~/.zshrc-fzf-completion
fi
source-if-exists ~/.zshrc-prompt
# Must come after last fpath change
source-if-exists ~/.zshrc-comp
source-if-exists ~/.zshrc-extras

# https://superuser.com/questions/91881/invoke-zsh-having-it-run-a-command-and-then-enter-interactive-mode-instead-of
if [ -n "$RUN" ]; then
  echo "$ $RUN"
  eval "$RUN"
fi
