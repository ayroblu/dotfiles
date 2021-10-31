set -x
zsh -c "${1:-echo "No command passed"}"
# https://stackoverflow.com/questions/13195655/bash-set-x-without-it-being-printed
{ set +x; } 2>/dev/null
zsh
