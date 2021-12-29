# https://superuser.com/questions/544989/does-tmux-sort-the-path-variable
#if [ -f /etc/profile ]; then
#  PATH=""
#  source /etc/profile
#fi

SHELL_SESSIONS_DISABLE=1
if [ -f ~/preload/.zshrc ]; then
  export ZDOTDIR="$HOME/preload"
fi

