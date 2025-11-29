#!/bin/zsh
mkdir -p ~/bin
mkdir -p ~/.vim
for file in .* bin/* .vim/* .config/* Library/Application\ Support/*; do
  ignorelist=". .. .git .DS_Store .vim .config Library/Application\ Support"
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
