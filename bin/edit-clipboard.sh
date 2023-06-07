#!/bin/zsh

run() {
  set -euo pipefail
  local file="$(mktemp)"
  pbpaste > "$file"
  local before="$(cat "$file")"
  vi "$file"
  # skip if empty file, or no change
  local updated="$(cat "$file")"
  if [ -z "$updated" ] || [ "$before" = "$updated" ]; then
    return
  fi
  echo "Edited: $file"
  echo "$updated" | perl -pe 'chomp if eof' | pbcopy
}
run
