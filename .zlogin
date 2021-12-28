# https://superuser.com/questions/544989/does-tmux-sort-the-path-variable
#if [ -f /etc/profile ]; then
#  PATH=""
#  source /etc/profile
#fi

if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
if [ -f /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

SHELL_SESSIONS_DISABLE=1
if [ -f ~/preload/.zshrc ]; then
  export ZDOTDIR="$HOME/preload"
fi

# Automatically placed at end of file by MDE. To disable this behavior: touch ~/.no-mde-dotfile. Ideally you do not need to do this. Please contact mde-support@twitter.com to discuss long-term alternatives.
[ -f /opt/twitter_mde/etc/zlogin ] && source /opt/twitter_mde/etc/zlogin
