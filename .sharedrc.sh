# ------------------- Env
# Somewhat expensive cause it calls the brew executable
if [ -f /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# -------------------- Aliases
alias rand='date +%s | shasum -a 256 | base64 | head -c 32 ; echo'
alias random='openssl rand -base64 32'
alias l='ls -A'
alias ls='ls -A'
alias ll='ls -Al'
# macos doesn't auto sort by CPU
alias top='top -o cpu'
alias e='emacs'
alias mv='mv -i'
alias vi='nvim'
alias vis='vi -c OpenSession'
alias mvis='mvim -c OpenSession'
alias viallnotes='vi ~/Dropbox/Documents/twitter/*.md ~/Dropbox/Notes/*.md'
alias goctave='\octave -q'
[ -x "$(command -v octave)" ] && alias octave='octave -W -q'
[ -x "$(command -v rg)" ] && [ -x "$(command -v ctags)" ] && alias maketags="rg --files | ctags --links=no --excmd=number -L-"
[ -x "$(command -v rg)" ] && alias rg="rg --hidden --glob \"!tags\" --glob \"!.git\" -M 1000"
[ -f "$HOMEBREW_PREFIX"/bin/less ] && export LESS="$LESS -RF"

# Editing aliases
alias vivim='vi ~/.vimrc'
alias vitmux='vi ~/.tmux.conf'
alias vibash="vi ~/.bashrc*"
alias vizsh="vi ~/.zshrc*"
alias vigit="vi ~/.gitconfig*"
alias reindexspotlight='sudo mdutil -E /'
# https://vi.stackexchange.com/questions/4682/how-can-i-suppress-the-reading-from-stdin-message-from-within-vim
alias vpage="vim -c 'set ft=man ts=8 nomod nolist nonu noma' --not-a-term -"
# Used on remote systems to pass through the clipboard
alias sshpb='ssh -R 2324:localhost:2324 -R 2325:localhost:2325'
exists pbcopy || alias pbcopy='nc -q0 localhost 2324'
exists pbpaste || alias pbpaste='nc localhost 2325'

# aliases for fzf
alias cdw='cd'
alias cdws='cd'

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

# -------------- Misc env vars
[ -f "$HOMEBREW_PREFIX"/opt/libffi/lib/pkgconfig ] && export PKG_CONFIG_PATH="$HOMEBREW_PREFIX/opt/libffi/lib/pkgconfig"
exists node && export NODE_OPTIONS=--max-old-space-size=8192
exists brew && export HOMEBREW_NO_AUTO_UPDATE=1
exists brew && export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1

# https://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there
pathadd() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1${PATH:+":$PATH"}"
  fi
}
pathadd ~/.cargo/bin
pathadd ~/.poetry/bin
pathadd "$HOMEBREW_PREFIX"/opt/mysql-client/bin
pathadd ~/.emacs.d/bin
pathadd ~/bin
pathadd "$HOMEBREW_PREFIX"/opt/make/libexec/gnubin
# qmk_firmware
pathadd "$HOMEBREW_PREFIX/opt/avr-gcc@8/bin"
pathadd "$HOMEBREW_PREFIX/opt/arm-gcc-bin@8/bin"
pathadd "$HOMEBREW_PREFIX/anaconda3/bin"

#
# Checkout bat --list-themes, Light themes: GitHub, Monokai Extended Light, OneHalfLight, ansi-light
exists bat && export BAT_THEME="GitHub"
export EDITOR='vi'
export MANPAGER="col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -"

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
    rg --pcre2 "$BEFORE" --files-with-matches "$FILEDIR" | xargs perl -i -pe "s/$BEFORE_ESCAPED/$AFTER/g"
  fi
}
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
videoToGif1280() {
  local filename="$1"
  local new_filename="${filename%.*}.1280.gif"
  # https://engineering.giphy.com/how-to-make-gifs-with-ffmpeg/
  ffmpeg -i "$filename" -filter_complex "[0:v] fps=12,scale=1280:-1,split [a][b];[a] palettegen [p];[b][p] paletteuse" "$new_filename"
}