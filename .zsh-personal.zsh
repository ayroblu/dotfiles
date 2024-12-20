# Personal setup
# Also consider reviewing:
# https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html

# ---------- Aliases
# Proxy stuff
alias proxywifion='sudo networksetup -setsocksfirewallproxystate Wi-Fi on' #on / off
alias proxywifioff='sudo networksetup -setsocksfirewallproxystate Wi-Fi off' #on / off
# https://superuser.com/questions/751868/how-to-inactivate-network-service-by-terminal-on-mac-os-x
# sudo networksetup -listallnetworkservices
# networksetup [-setnetworkserviceenabled networkservice on | off]
alias etherneton='sudo networksetup -setnetworkserviceenabled "Thunderbolt Ethernet Slot 1" on' #on / off
alias ethernetoff='sudo networksetup -setnetworkserviceenabled "Thunderbolt Ethernet Slot 1" off' #on / off

alias gulp='TS_NODE_TRANSPILE_ONLY=true npx gulp'

# ------------ Functions
nzproxy() {
  ssh -ND 9876 mezap &
  proxywifion
  # wut: https://superuser.com/questions/555874/zsh-read-command-fails-within-bash-function-read1-p-no-coprocess
  read "?Press enter to turn off proxy: "
  proxywifioff
  fg
}

toggle-ethernet() {
  ethernetoff
  etherneton
}

# Function to show colours
show_colours() {
  for i in {0..255}; do printf "\x1b[38;5;${i}mcolor%-5i\x1b[0m" $i ; if ! (( ($i + 1 ) % 8 )); then echo ; fi ; done
}

zsh_stats() {
  fc -l 1 \
    | awk '{ CMD[$2]++; count++; } END { for (a in CMD) print CMD[a] " " CMD[a]*100/count "% " a }' \
    | grep -v "./" | sort -nr | head -20 | column -c3 -s " " -t | nl
}

# https://superuser.com/questions/561725/put-a-command-in-history-without-executing-it
to-history() { print -S $BUFFER ; BUFFER= }
zle -N to-history
# alt-q macos
bindkey 'œ' to-history

# # https://stackoverflow.com/a/50830617/6725059
# function cd() {
#   builtin cd "$@"

#   if [[ -z "$VIRTUAL_ENV" ]] ; then
#     ## If env folder is found then activate the vitualenv
#       if [[ -d ./env ]] ; then
#         source ./env/bin/activate
#       fi
#   else
#     ## check the current folder belong to earlier VIRTUAL_ENV folder
#     # if yes then do nothing
#     # else deactivate
#       parentdir="$(dirname "$VIRTUAL_ENV")"
#       if [[ "$PWD"/ != "$parentdir"/* ]] ; then
#         deactivate
#       fi
#   fi
# }

# from `conda init zsh`
setup-conda() {
  if [ -f /usr/local/Caskroom/miniconda/base/bin/conda ]; then
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/usr/local/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
            . "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh"
        else
            export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
  fi
}

