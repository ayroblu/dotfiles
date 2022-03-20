#!/bin/bash
mkdir -p ~/bin
mkdir -p ~/.config/nvim
mkdir -p ~/.config/bat
for file in .* bin/* .vim/* .config/nvim/* .config/bat/*; do
  ignorelist=". .. .git .DS_Store .vim .config"
  # https://stackoverflow.com/questions/8063228/check-if-a-variable-exists-in-a-list-in-bash
  if ! [[ $ignorelist =~ (^|[[:space:]])$file($|[[:space:]]) ]]; then
    if [ -e ~/"$file" ]; then
      echo ~/"$file" exists
    else
      echo ln -s "$(pwd)/$file" ~/"$file"
      ln -s "$(pwd)/$file" ~/"$file"
    fi
  fi
done
