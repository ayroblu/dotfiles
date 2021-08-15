ZPLUG_DIR="$HOME/.zsh-plugins"
zplug-prep() {
  mkdir -p "$ZPLUG_DIR"
}
zplug() {
  local name=$(echo "$1" | awk -F'/' '{print $2}')
  if ! [ -d "$ZPLUG_DIR/$name" ]; then
    git clone https://github.com/"$1" "$ZPLUG_DIR/$name"
  fi
  source "$ZPLUG_DIR/$name"/*.plugin.zsh
}
zplug-prep
