#!/usr/local/bin/bash

# Example check for existance of a func in bash
has() {
  type "$1" &> /dev/null
}
if has brew; then
  echo 'has brew'
fi
if has code; then
  echo 'has code'
fi

# ----------- Homebrew
# https://stackoverflow.com/questions/41029842/easy-way-to-have-homebrew-list-all-package-dependencies/41029864
if has brew; then
  #brew leaves | xargs brew deps --installed --for-each | sed "s/^.*:/$(tput setaf 4)&$(tput sgr0)/" > brewlist.txt
  brew leaves | xargs brew deps --installed --for-each > brewlist-"$HOSTNAME".txt
  brew cask list > brewcasklist-"$HOSTNAME".txt
fi

# ----------- VSCode extensions
if has code; then
  code --list-extensions > vscode_extensions-"$HOSTNAME".txt
fi
