if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
export SHELL_SESSIONS_DISABLE=1
if [ -f ~/preload/.zshrc ]; then
  export ZDOTDIR="$HOME/preload"
fi
