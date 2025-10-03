#!/bin/bash
mkdir -p ~/bin
mkdir -p ~/.vim
for file in .* bin/* .vim/* .config/*; do
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
