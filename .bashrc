env shellshock="() { :; }; echo 'Shellshockable!'" bash -c "echo -n ''"
export BASH_SILENCE_DEPRECATION_WARNING=1
echo 'Note you are running bash'

# Makes homebrew stuff work first
#export PATH='/usr/local/bin:$PATH'

# Makes colourful ls and such (more impressive stuff is abit further on
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# ASSUMED: sets the size of the history file
HISTFILESIZE=1000000
HISTSIZE=1000000
shopt -s histappend
HISTTIMEFORMAT="%y-%m-%d %T "
HISTCONTROL=ignoredups:erasedups
HISTIGNORE='ls:bg:fg:history'
shopt -s cmdhist # Multiline history editing
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$';'}history -a" # append command to history

# Set view
view () {
  eval "$*" --color | less -RFX
}

# Sets vim shortcuts for bash
set -o vi

# maps the show everything human readable etc...
alias vi='vim'
alias ll='ls -lhaG'
alias fin='find . -name'
alias tree='tree -C'
alias less='less -r'
alias iip='ifconfig | grep inet'
alias exip='curl ipecho.net/plain'
alias vibashrc='vi ~/.profile' # change to bashrc on other computers
alias lbashrc='. ~/.profile'
alias top='top -o cpu'
alias h='history | tail -50'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ..='cd ..'
alias ...='cd ../../'
alias l.='ls -d' ## Show hidden files ##
alias bc='bc -l' #4: Start calculator with math support
alias mkdir='mkdir -pv' #5: Create parent directories on demand
alias j='jobs -l'
#11: Control output ping
alias ping='ping -c 5' # 5 count
# Do not wait interval 1 second, go fast #
alias fastping='ping -c 100 -s.2'
alias header='curl -I'
alias headerc='curl -I --compress' # find out if remote server supports gzip / mod_deflate or not #
alias wget='wget -c' #27 Resume wget by default
alias df='df -H'
alias du='du -ch'
alias gitnearest='git show-branch | grep '"'"'*'"'"' | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -n1 | sed '"'"'s/.*\[\(.*\)\].*/\1/'"'"' | sed '"'"'s/[\^~].*//'"'"''

alias ip="curl ipinfo.io/ip"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"
alias speedtest="wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip"
alias cvim='vi ~/.vimrc'
alias ctmux='vi ~/.tmux.conf'
alias cbash="vi ~/.bashrc*"
alias czsh="vi ~/.zshrc*"

# show epoch time
alias epoch='date +%s'

# Best network monitoring maintenance etc: http://www.cyberciti.biz/faq/what-process-has-open-linux-port/
# netstat -tulpn
# fuser 7000/tcp # get process id
# ls -l /proc/3813/exe #get processname
# ls -l /proc/3813/cwd # get current working dir
# ps aux | grep 3813 # find owner
# lsof -i tcp:80 #what's listening on port 80

# Search for all open devices on ip subnet
#nmap -sn 192.168.1.0/24

#alias addbash='echo "alias thing="\"$(history -p !!)\" >> ~/.bashrc-extras'

# Can't access drive because in use
#sudo lsof | grep /Volumes/myDrive

# z folders
#. `brew --prefix`/etc/profile.d/z.sh

# For find and replace in files, recursive:
# find . -type f -name '*' -exec sed -i '' 's/this/that/' {} +
# Sort files by number of lines:
# find . -type f -exec wc -l {} + | sort -rn

#export LC_CTYPE=C
#export LANG=C
# For find and replace of filenames: - only removes front - look these up
# find . -name '123*.txt' -type f -exec bash -c 'mv "$1" "${1/\/123_//}"' -- {} \;

# Convert crlf to lf
# find ./ -type f -exec dos2unix {} \;

# Delete files older than x days
# find ~/log-20* -mtime +3 -exec rm {} \;

# Inputrc type, Bash completion
if [[ $- = *i* ]]; then
  bind 'set show-all-if-ambiguous on'   # Single tab show all
  #bind 'TAB:menu-complete'             # Tab completes to full possible file name
  #bind 'set completion-ignore-case on' # Ignore case completion
  bind '"\e[Z": menu-complete'          # Shift-Tab menu-complete
  #bind '"\e[Z": "\e-1\C-i"'            # Shift-Tab menu-complete-backwards
fi

# change to existing subdirectory
function cto {
  local results=$(find . -iname "$@" -type d 2>&1 | grep -v 'Permission denied')
  if [ $(echo "$results" | wc -l) == "1" ]; then
    cd $results
  else
    echo "${results}" | head -10
    if [ $(echo "$results" | wc -l) > 10 ]; then
      echo "..."
    fi
  fi
}

function encrypt {
  FNAME=$1

  if [[ -z "$FNAME" ]]; then
      echo "encrypt <name of file>"
      echo "  - encrypt is a script to encrypt files using des3"
      exit;
  fi

  openssl des3 -md sha256 -salt -in "$FNAME" -out "$FNAME.des3"
}
function decrypt {
  FNAME=$1

  if [[ -z "$FNAME" ]]; then
      echo "decrypt <name of file>"
      echo "  - decrypt is a script to decrypt des3 encrypted files"
      exit;
  fi

  openssl des3 -md sha256 -d -salt -in "$FNAME" -out "${FNAME%.[^.]*}"
}

# ----------------------------------------- Macbook
[ -f ~/.bashrc-personal ] && . ~/.bashrc-personal

#------------------------------------------ colors
[ -f ~/.bashrc-colors ] && . ~/.bashrc-colors

# ----------------------------------------- Bash prompt
[ -f ~/.bashrc-prompt ] && . ~/.bashrc-prompt

# ----------------------------------------- bash quick adds
[ -f ~/.bashrc-extras ] && . ~/.bashrc-extras

# ----------------------------------------- bash quick adds
[ -f ~/.sharedrc.sh ] && . ~/.sharedrc.sh

#[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# added by travis gem
#[ -f /Users/blu/.travis/travis.sh ] && source /Users/blu/.travis/travis.sh
