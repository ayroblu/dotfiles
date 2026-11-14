ZPLUG_DIR="$HOME/.zsh-plugins"
zplug-prep() {
  [ ! -d "$ZPLUG_DIR" ] && mkdir "$ZPLUG_DIR"
}
zplug() {
  local name="${1#*/}"
  if ! [ -d "$ZPLUG_DIR/$name" ]; then
    git clone https://github.com/"$1" "$ZPLUG_DIR/$name"
  fi
  source "$ZPLUG_DIR/$name"/*.plugin.zsh
}
zplug-prep
