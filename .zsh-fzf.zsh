# Checkout the .fzf.zsh -> /usr/local/opt/fzf/shell/key-bindings.zsh for more info
# https://feltrac.co/environment/2020/01/18/build-your-own-shell-completion.html
# Downfalls - can't do context aware (how do I figure out the cmd line? Perhaps $@?

# More in the .zshrc-fzf

## Completion triggers with ^F
# This removes the ** requirement, so can tab on random space to get auto complete
#export FZF_COMPLETION_TRIGGER=''
# If you've ever set the trigger in the past, just removing it is not enough, need to unset
unset FZF_COMPLETION_TRIGGER
fzf-completion-notrigger() {
  FZF_COMPLETION_TRIGGER='' fzf-completion
}
zle -N fzf-completion-notrigger
bindkey '^F' fzf-completion-notrigger
_fzf_complete_git_notrigger() {
    FZF_COMPLETION_TRIGGER='' _fzf_complete_ssh
}
#bindkey '^I' $fzf_default_completion
#bindkey '^I' expand-or-complete
#### supported command prefixes: ####
# Most commands: files
# cd: directories
# kill: processes
# ssh, telnet: hosts
# unset, export: env vars
# unalias: aliases
## For files and directories
_fzf_compgen_path() {
  #fd --hidden --follow --exclude ".git" . "$1"
  rg --files --hidden --glob "!.git" "$1"
}
# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

## FZF setup variables - use git ls-files cause it's way faster
git-ls-files() {
  git ls-files 2> /dev/null || rg --files --hidden --glob "!.git" -M 200 2> /dev/null
}
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#Can't use default-fzf-cmd because no functions in vim
#export FZF_DEFAULT_COMMAND='default-fzf-cmd'
exists rg && export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
#export FZF_CTRL_T_COMMAND='default-fzf-cmd'
export FZF_DEFAULT_OPTS="--height 60% --reverse --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --preview-window down:60%:wrap --bind 'up:preview-up,down:preview-down,ctrl-d:preview-page-down,ctrl-u:preview-page-up,ctrl-f:half-page-down,ctrl-b:half-page-up,ctrl-e:toggle-preview'"
export FZF_CTRL_T_OPTS="--preview 'preview-unknown {}'"
export FZF_COMPLETION_OPTS="$FZF_CTRL_T_OPTS"
# Support alt-c for changing directory
bindkey "ç" fzf-cd-widget

fzf-dir() {
  _fzf_compgen_dir . |
    fzf-down --ansi --multi --no-sort --preview-window down:50% \
      --preview 'tree -C {} | head -'$LINES
}
fzf-dir-widget() {
  local result=$(fzf-dir | join-lines)
  zle reset-prompt
  LBUFFER+=$result
}
zle -N fzf-dir-widget
bindkey '^e^e' fzf-dir-widget
bindkey -r "^E"

fzf-git-ls-files() {
  git ls-files | fzf
}
fzf-git-ls-files-widget() {
  local result=$(fzf-git-ls-files | join-lines)
  zle reset-prompt
  LBUFFER+=$result
}
zle -N fzf-git-ls-files-widget
bindkey '^e^s' fzf-git-ls-files-widget

fzf-yank-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=( $(fc -rl 1 |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
  local ret=$?
  echo ${selected:1} | pbcopy
  echo yanked "'"${selected:1}"'"
  # if [ -n "$selected" ]; then
  #   num=$selected[1]
  #   if [ -n "$num" ]; then
  #     zle vi-fetch-history -n $num
  #   fi
  # fi
  zle reset-prompt
  return $ret
}
zle     -N   fzf-yank-history-widget
bindkey '^Y' fzf-yank-history-widget



# (EXPERIMENTAL) Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    # I tried aliases, didn't seem to work, not sure why - guessing it's not pulling the context (subshell?)
    *)            fzf "$@" ;;
  esac
}


## Git shortcuts
# Initial copy from:
# https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236
# https://junegunn.kr/2016/07/fzf-git/

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
  fzf --height 50% "$@" --border
}

fzf_gf() {
  is_in_git_repo || return
  git -c color.status=always status --short 2> /dev/null |
    fzf-down -m --ansi --nth 2..,.. \
      --preview '(git diff --color=always -- {-1} 2> /dev/null | sed 1,4d; cat {-1}) | head -500' |
    cut -c4- | sed 's/.* -> //'
}

# same as gf, but with files changed since merge-base
fzf_gg() {
  is_in_git_repo || return
  git du --name-only 2> /dev/null |
    fzf-down -m --ansi \
      --preview '(git diff --color=always -- {-1} 2> /dev/null | sed 1,4d; cat {-1}) | head -500'
}

fzf_gb() {
  is_in_git_repo || return
  git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short)' |
    fzf-down --ansi --multi --no-sort --preview-window right:70% \
      --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" {} | head -'$LINES |
    sed 's#^remotes/##'
}

fzf_gm() {
  is_in_git_repo || return
  git for-each-ref --sort=-committerdate refs/{heads,remotes} --format='%(refname:short)' |
    fzf-down --ansi --multi --no-sort --preview-window right:70% \
      --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" {} | head -'$LINES |
    sed 's#^remotes/##'
}

fzf_gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
    fzf-down --multi --preview-window right:70% \
      --preview 'git show --color=always {} | head -'$LINES
}

fzf_gh() {
  is_in_git_repo || return
  # --graph is slow on large repos
  # git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --color=always |
    fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
      --header 'Press CTRL-S to toggle sort' \
      --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
    grep -o "[a-f0-9]\{7,\}"
}

fzf_gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
    fzf-down --tac \
      --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
    cut -d$'\t' -f1
}
join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

bind-git-helper() {
  local c
  for c in $@; do
    eval "fzf-g$c-widget() { local result=\$(fzf_g$c | join-lines); zle reset-prompt; LBUFFER+=\$result }"
    eval "zle -N fzf-g$c-widget"
    eval "bindkey '^g^$c' fzf-g$c-widget"
  done
}
# Remove default
bindkey -r "^G"
# Files, with Untracked files, merGebase diff files, Branches, reMote branches, Tags, Remotes, commit Hashes
bind-git-helper f g b m t r h
unset -f bind-git-helper
