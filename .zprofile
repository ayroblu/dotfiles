# https://superuser.com/questions/544989/does-tmux-sort-the-path-variable
if [ -f /etc/profile ]; then
  PATH=""
  source /etc/profile
fi

if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
if [ -f /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

export SHELL_SESSIONS_DISABLE=1
if [ -f ~/preload/.zshrc ]; then
  export ZDOTDIR="$HOME/preload"
fi
