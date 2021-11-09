set -x
SHELL=/bin/zsh zsh -c "${1:-echo "No command passed"}; zsh"
# https://stackoverflow.com/questions/13195655/bash-set-x-without-it-being-printed
{ set +x; } 2>/dev/null
