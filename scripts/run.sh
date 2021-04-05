#!/bin/bash
for file in .*; do
  list=". .. .git .DS_Store"
  # https://stackoverflow.com/questions/8063228/check-if-a-variable-exists-in-a-list-in-bash
  if ! [[ $list =~ (^|[[:space:]])$file($|[[:space:]]) ]]; then
    if [ -e ~/"$file" ]; then
      echo ~/"$file" exists
    else
      echo ln -s "$(pwd)/$file" ~/"$file"
      ln -s "$(pwd)/$file" ~/"$file"
    fi
  fi
done
