# ------------------- Env
# Somewhat expensive cause it calls the brew executable
#if [ -f /usr/local/bin/brew ]; then
#  eval "$(/usr/local/bin/brew shellenv)"
#fi

# -------------------- Aliases
alias rand='date +%s | shasum -a 256 | base64 | head -c 32 ; echo'
alias random='openssl rand -base64 32'
alias l='ls -A'
alias ls='ls -A'
alias ll='ls -Alh'
# copy on write optimisation.
alias cp='cp -c'
# macos doesn't auto sort by CPU
alias top='top -o cpu'
alias e='emacs'
alias mv='mv -i'
alias vi='nvim'
alias vif='VIM_FAST=1 nvim'
alias viff='VIM_VERY_FAST=1 nvim'
alias nvr='nvr -s'
alias vis='vi -c OpenSession'
alias mvis='mvim -c OpenSession'
alias viallnotes='vi ~/Dropbox/Documents/twitter/notes.md ~/Dropbox/Notes/*.md ~/Dropbox/Documents/ambitus/notes.md'
alias cddropbox='cd ~/Library/CloudStorage/Dropbox'
alias goctave='\octave -q'
[ -x "$(command -v octave)" ] && alias octave='octave -W -q'
[ -x "$(command -v rg)" ] && [ -x "$(command -v ctags)" ] && alias maketags="rg --files | ctags --links=no --excmd=number -L-"
[ -x "$(command -v rg)" ] && alias rg="rg --hidden --glob \"!tags\" --glob \"!.git\" -M 1000"
[ -f /usr/local/bin/less ] && export LESS="$LESS -RF"

# Editing aliases
alias vivim='vi ~/.vimrc'
alias vitmux='vi ~/.tmux.conf'
alias vibash="vi ~/.bashrc*"
alias vizsh="vi ~/.zshrc*"
alias vigit="vi ~/.gitconfig*"
alias reindexspotlight='sudo mdutil -E /'
# https://vi.stackexchange.com/questions/4682/how-can-i-suppress-the-reading-from-stdin-message-from-within-vim
alias vpage="vim -c 'set ft=man ts=8 nomod nolist nonu noma' --not-a-term -"
alias nvpage="nvim -c 'set ft=man ts=8 nomod nolist nonu noma' --headless -"
# https://unix.stackexchange.com/questions/80151/show-path-in-a-human-readable-way
alias echopath='echo -e ${PATH//:/\\n}'
alias apple-enable='xattr -d com.apple.quarantine'
# for sharing clipboard: deprecated, can just use bin/pbcopy with escape codes - keeping around as it might be useful?
# alias sshpb='ssh -R 2324:localhost:2324 -R 2325:localhost:2325'
# exists pbcopy || alias pbcopy='nc -q0 localhost 2324'
# exists pbpaste || alias pbpaste='nc localhost 2325'

# aliases for fzf
alias cdw='cd'
alias cdws='cd'
alias clearall="clear && printf '\e[3J'"

# Rosetta prefix
alias r="arch -arm64"

# https://apple.stackexchange.com/questions/20547/how-do-i-find-my-ip-address-from-the-command-line
alias exip="curl ifconfig.me"
localip() {
  echo "show State:/Network/Interface/$(
    echo 'show State:/Network/Global/IPv4'\
    | scutil \
    | grep 'PrimaryInterface '\
    | sed 's/  PrimaryInterface : //'
  )/IPv4" \
    | scutil \
    | pcregrep -Mo1 " Addresses : <array> {\n    0 : ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})"
}

# https://apple.stackexchange.com/questions/398952/how-to-identify-the-largest-files-in-a-directory-including-in-its-subdirectories
alias list-largest-files="find . -type f -exec stat -f '%z %N' {} + | sort -nr"

# -------------- Misc env vars
# https://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there
pathadd() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1${PATH:+":$PATH"}"
  fi
}

# /opt/homebrew/bin/brew shellenv
if [ -f /opt/homebrew/bin/brew ]; then
  export HOMEBREW_PREFIX="/opt/homebrew";
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
  export HOMEBREW_REPOSITORY="/opt/homebrew";
  #export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
  pathadd /opt/homebrew/bin
  pathadd /opt/homebrew/sbin
  export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
fi

exists() {
  command -v "$1" >/dev/null 2>&1
}

[ -f /usr/local/opt/libffi/lib/pkgconfig ] && export PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"
[ -d /opt/homebrew/lib/pkgconfig ] && export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:/opt/homebrew/opt/jpeg/lib/pkgconfig"
exists node && export NODE_OPTIONS=--max-old-space-size=8192
#exists brew && export HOMEBREW_NO_AUTO_UPDATE=1
#exists brew && export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1

pathadd ~/.cargo/bin
pathadd ~/.poetry/bin
pathadd /usr/local/opt/mysql-client/bin
pathadd ~/.emacs.d/bin
pathadd ~/.local/bin
pathadd ~/bin
pathadd /usr/local/opt/make/libexec/gnubin
pathadd /opt/homebrew/opt/make/libexec/gnubin
pathadd /opt/homebrew/opt/python/libexec/bin
# qmk_firmware
pathadd "/opt/homebrew/opt/avr-gcc@8/bin"
pathadd "/opt/homebrew/opt/arm-gcc-bin@8/bin"
pathadd "/usr/local/anaconda3/bin"

#
# Checkout bat --list-themes, Light themes: GitHub, Monokai Extended Light, OneHalfLight, ansi-light
exists bat && export BAT_THEME="GitHub"
export VISUAL='nvim'
export EDITOR="$VISUAL"
#export MANPAGER="col -b | nvim -c 'set ft=man ts=8 nomod nolist nonu noma' --headless -"
export MANPAGER="nvim -c 'Man!' -o -"

export GOPATH=~/ws/go
export GOBIN=~/ws/go/bin
pathadd $GOBIN

# ------------- Functions
take() {
  mkdir -p -- "$1" &&
    cd -P -- "$1"
}

worktreeDelete() {
  local dir=$(dirname "$(git rev-parse --git-common-dir)")
  git worktree remove "$(git root)"
  cd "$dir"
}

pls() {
  local current=$(cd "$1"; pwd)

  while [[ $current != '/' ]]; do
    #ls -ld "$current"
    current=$(dirname "$current")
    echo "$current"
  done
}

createRamDisk() {
  # https://superuser.com/a/272148
  ramfs_size_mb=128
  mount_point=~/volatile

  ramfs_size_sectors=$((${ramfs_size_mb}*1024*1024/512))
  ramdisk_dev=`hdid -nomount ram://${ramfs_size_sectors}`
  newfs_hfs -v 'Volatile' ${ramdisk_dev}
  mkdir -p ${mount_point}
  mount -o noatime -t hfs ${ramdisk_dev} ${mount_point}

  echo "remove with:"
  echo "umount ${mount_point}"
  echo "diskutil eject ${ramdisk_dev}"
}

encodeURIComponent(){
  node -e 'console.log(encodeURIComponent('"'$1'"'))'
}

stash(){
  git stash
  "$@"
  git stash pop
}
nohooks(){
  HUSKY_SKIP_HOOKS=1 "$@"
}

copyDockerFile() {
  if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <image-name> <docker-file-path> <output-path>" >&2
    exit 1
  fi
  id=$(docker create $1)
  docker cp $id:$2 - > $3
  docker rm -v $id
}

killport() {
  kill -9 $(lsof -ti "$@")
}

regexReplace() {
  # Requires ripgrep: https://github.com/BurntSushi/ripgrep
  BEFORE="$1"
  BEFORE_ESCAPED="$(echo "$1" | sed 's/\//\\\//g')"
  AFTER="$(echo "$2" | sed 's/\//\\\//g')"
  FILEDIR="$3"
  if [ -f "$FILEDIR" ]; then
    perl -i -pe "BEGIN{undef $/;} s/$BEFORE_ESCAPED/$AFTER/gsm" "$FILEDIR"
  elif [ -d "$FILEDIR" ]; then
    rg --pcre2 "$BEFORE" --multiline --multiline-dotall --files-with-matches "$FILEDIR" | xargs perl -i -pe "BEGIN{undef $/;} s/$BEFORE_ESCAPED/$AFTER/gsm"
  fi
}

regexReplaceSingle() {
  # Requires ripgrep: https://github.com/BurntSushi/ripgrep
  BEFORE="$1"
  BEFORE_ESCAPED="$(echo "$1" | sed 's/\//\\\//g')"
  AFTER="$(echo "$2" | sed 's/\//\\\//g')"
  FILEDIR="$3"
  if [ -f "$FILEDIR" ]; then
    perl -i -pe "BEGIN{undef $/;} s/$BEFORE_ESCAPED/$AFTER/gsm" "$FILEDIR"
  elif [ -d "$FILEDIR" ]; then
    # perl: -i: inplace, -p: print each line, -e: execute perlscript
    rg --pcre2 "$BEFORE" --files-with-matches "$FILEDIR" | xargs perl -i -pe "s/$BEFORE_ESCAPED/$AFTER/g"
  fi
}
replace() {
  BEFORE="$1"
  BEFORE_ESCAPED="$(echo "$1" | sed 's/\//\\\//g')"
  AFTER="$(echo "$2" | sed 's/\//\\\//g')"
  FILEDIR="${3:-.}"
  # rg --files-with-matches -FU "$BEFORE" "$FILEDIR" | BEFORE="$1" AFTER="$2" xargs ruby -p -i -e "gsub(ENV['BEFORE'], ENV['AFTER'])"
  # IFS=$'\n' TEMP=( $(rg --files-with-matches "$BEFORE" "$FILEDIR") )
  # rg --files-with-matches -FU "$BEFORE" "$FILEDIR" | xargs AFTER="$2" echo "$AFTER"
  rg -FU "$BEFORE" --files-with-matches -g "**/__tests__/**" "$FILEDIR" | xargs perl -i -pe "BEGIN{undef $/;} s/\\Q$BEFORE_ESCAPED/$AFTER/gsm"
  # rg --files-with-matches -FU "$BEFORE" "$FILEDIR" | while read -r f
  # do
  #   echo "File" "$f"
  #   perl -i -pe "s/\\Q$BEFORE/$AFTER/g" "$f"
  #   # PREV="$BEFORE" AFT="$AFTER" ruby -p -i -e "gsub(ENV['PREV'], ENV['AFT'])" "$f"
  # done
}
#rgr() {
#  local TEMP
#  local TEMPFILE
#  # TEMP="$(rg --files-with-matches "$@")"
#  IFS=$'\n' TEMP=( $(rg --files-with-matches "$@") )
#  for file in "${TEMP[@]}"; do
#    echo "file $file"
#    TEMPFILE="$(rg --passthru "$@" "$file")"
#    echo "$TEMPFILE" > "$file"
#  done
#  # read -r TEMP < <(rg --files-with-matches "$@")
#
#  # rg --files-with-matches "$@" | while read -r f
#  # do
#  #   echo "File" "$f"
#  #   TEMPFILE="$(rg "$@")"
#  #   echo "$TEMPFILE" > "$f"
#  # done
#  # for f in "${TEMP[@]}"; do
#  #   echo "File" "$f"
#  #   #TEMPFILE=$(rg "$@")
#  #   #echo "$TEMPFILE" > "$f"
#  # done
#}
# files: rename 's/^/MyVacation2011_/g' *.jpg
# for f in *.jpg; do mv "$f" "$(echo "$f" | sed s/IMG/VACATION/)"; done

# https://askubuntu.com/questions/113544/how-can-i-reduce-the-file-size-of-a-scanned-pdf-file (2nd answer)
shrinkpdf() {
  INPUT="$1"
  OUTPUT="${INPUT:r}-compressed.pdf"
  # -dQUIET
  gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook \
    -dNOPAUSE -dBATCH -sOutputFile="$OUTPUT" "$INPUT"
  ## Much faster
  # ps2pdf -dPDFSETTINGS=/ebook "$INPUT" "$OUTPUT"
  ## Also much faster:
  # gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dDownsampleColorImages=true \
  #   -dColorImageResolution=150 -dNOPAUSE  -dBATCH -sOutputFile="$OUTPUT" "$INPUT"
}

# https://stackoverflow.com/questions/2507766/merge-convert-multiple-pdf-files-into-one-pdf
mergepdf() {
  gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile="${@: -1}" "${@:1:-1}"
}
# Also consider using ocrmypdf if you want to search it
# https://unix.stackexchange.com/questions/301318/how-to-ocr-a-pdf-file-and-get-the-text-stored-within-the-pdf

# instead of fswatch, entr: just do:
# rg --files aoc_2023/day_23 -g '*.rs' | entr cargo build --release --bin day_23p2

videoToGif() {
  local filename="$1"
  local new_filename="${filename%.*}.gif"
  # https://engineering.giphy.com/how-to-make-gifs-with-ffmpeg/
  ffmpeg -i "$filename" -filter_complex "[0:v] fps=12,split [a][b];[a] palettegen [p];[b][p] paletteuse" "$new_filename"
}
videoToGif480() {
  local filename="$1"
  local new_filename="${filename%.*}.480.gif"
  # https://engineering.giphy.com/how-to-make-gifs-with-ffmpeg/
  ffmpeg -i "$filename" -filter_complex "[0:v] fps=12,scale=480:-1,split [a][b];[a] palettegen [p];[b][p] paletteuse" "$new_filename"
}
videoToGif480x4() {
  local filename="$1"
  local new_filename="${filename%.*}.480x4.gif"
  # https://engineering.giphy.com/how-to-make-gifs-with-ffmpeg/
  ffmpeg -i "$filename" -filter_complex "[0:v] fps=12,scale=480:-1,setpts=0.25*PTS,split [a][b];[a] palettegen [p];[b][p] paletteuse" "$new_filename"
}
videoToGif720() {
  local filename="$1"
  local new_filename="${filename%.*}.720.gif"
  # https://engineering.giphy.com/how-to-make-gifs-with-ffmpeg/
  ffmpeg -i "$filename" -filter_complex "[0:v] fps=6,scale=720:-1,split [a][b];[a] palettegen [p];[b][p] paletteuse" "$new_filename"
}
videoToGif1280() {
  local filename="$1"
  local new_filename="${filename%.*}.1280.gif"
  # https://engineering.giphy.com/how-to-make-gifs-with-ffmpeg/
  ffmpeg -i "$filename" -filter_complex "[0:v] fps=12,scale=1280:-1,split [a][b];[a] palettegen [p];[b][p] paletteuse" "$new_filename"
}
videoToGif1280x4() {
  local filename="$1"
  local new_filename="${filename%.*}.1280x4.gif"
  # https://engineering.giphy.com/how-to-make-gifs-with-ffmpeg/
  ffmpeg -i "$filename" -filter_complex "[0:v] fps=12,scale=1280:-1,setpts=0.25*PTS,split [a][b];[a] palettegen [p];[b][p] paletteuse" "$new_filename"
}
video-transcode() {
  # https://unix.stackexchange.com/questions/28803/how-can-i-reduce-a-videos-size-with-ffmpeg
  local filename="$1"
  local new_filename="${filename%.*}.h265.mp4"
  ffmpeg -i "$filename" -vcodec libx265 -crf 28 "$new_filename"
  # ffmpeg -i input.mp4 -c:v libaom-av1 -crf 30 av1_test.mkv - av1
}
video-720p() {
  local filename="$1"
  local new_filename="${filename%.*}.h264.mp4"
  ffmpeg -i "$filename" -filter:v scale=-1:720 "$new_filename"
}

killport() {
  lsof -nti:"$1" | xargs kill -9
}

portscan() {
  local IP_ADDRESS="$1"
  local MIN_PORT="${2:-1}"
  local MAX_PORT="${3:-65536}"
  for PORT in {$MIN_PORT..$MAX_PORT}; do
    echo -ne "Scanning port: $PORT\r"
    timeout 1 bash -c "</dev/tcp/$IP_ADDRESS/$PORT &>/dev/null" &&  echo "port $PORT is open"
  done
}

setup-pythonpath() {
  # uses legacy distutils: https://stackoverflow.com/questions/4757178/how-do-you-set-your-pythonpath-in-an-already-created-virtualenv/47184788#47184788
  # with updated sysconfig: https://stackoverflow.com/questions/122327/how-do-i-find-the-location-of-my-python-site-packages-directory/52638888#52638888
  local current_path="$(pwd)"
  cd $(python -c "from sysconfig import get_path; print(get_path('purelib'))")
  echo "$current_path" > pypath.pth
  cd -
}

tmpl-tool() {
  # https://stackoverflow.com/questions/2013547/assigning-default-values-to-shell-variables-with-a-single-command-in-bash
  : "${TMPL_HOME:=$HOME/ws/deps/code-templates}"

  if [ $# -lt 3 ]; then
    echo 'tmpl-tool <template-name> <component-name> <destination>'
    echo '  existing templates: '"$(ls "$TMPL_HOME")"
    return 1
  fi

  if [ -e "$TMPL_HOME/$1/build.ts" ]; then
    bun "$TMPL_HOME/$1/build.ts" "$2" "$3"
  else
    cp -a "$TMPL_HOME"/"$1"/* "$3"

    regexReplaceSingle __NAME__ "$2" "$3"
  fi
}

generate-favicons-svg() {
  if [ $# -ne 2 ]; then
    echo 'generate-favicons-svg <svg-file> <destination>'
    exit 1
  fi
  inkscape -w 128 -h 128 "$1" -o favicon.png
}

fsremove() {
  local fsname="$1"
  rg "$fsname" --files-with-matches -g '*.js' | xargs tools/code-mods/feature-switches/run.js --fsname "$1" --isTrue="$2"
  sed -i '' -e "/$fsname/d" src/app/featureSwitches.js
}

makedir() {
  local dir="$1"
  # remove first param from "$@"
  shift
  (cd "$dir" && gmake "$@")
}

cdgitroot() {
  cd "$(git root)" || return
}

llamachat() {
  (cd ~/ws/llama.cpp && ./main -m models/codellama-${1}b-instruct.Q5_K_M.gguf -e -c 5000 --temp 0.7 --color -p "$2" 2> /dev/null)
}
chat-basic() {
  local PROMPT="<s>[INST] <<SYS>>
Provide answers in TypeScript
<</SYS>>

$2 [/INST]"
  llamachat $1 "$PROMPT"
}
chat7() {
  chat-basic 7 "$1"
}
chat13() {
  chat-basic 13 "$1"
}
chat() {
  chat7 "$1"
}

llamainfill() {
  (cd ~/ws/llama.cpp && ./main -m models/codellama-${1}b.Q5_K_M.gguf -e -c 10000 --temp 0.7 --color -p "$2" 2> /dev/null)
}
infill-basic() {
  local PROMPT="<PRE> $2 <SUF>$3 <MID>"
  llamainfill $1 "$PROMPT"
}
infill7() {
  infill-basic 7 "$1"
}
infill13() {
  infill-basic 13 "$1"
}
infill() {
  infill7 "$1"
}
