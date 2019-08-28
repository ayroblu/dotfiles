Dotfiles
========

If you run a `.bash_profile` then you should probably add this:

```bash
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
```

Making symlinks
---------------
```bash
ln -s ~/ws/dotfiles/.bashrc ~/.bashrc
```

Write some code to do this:
```bash
for file in .*; do
  if [[ -f $file ]]; then
    echo ln -s $(pwd)/$file ~/$file
    ln -s $(pwd)/$file ~/$file
  fi
done
```

Tmux Setup
----------
This requires TPM:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Vim Setup
---------
Install plugins with vim-plug then run `:PlugInstall`

VS Code Setup
-------------
First create symlink to the settings file
```bash
# https://code.visualstudio.com/docs/getstarted/settings#_settings-file-locations
# ln -s <dest> <link-file-name>
rmtrash $HOME/Library/Application Support/Code/User/settings.json
ln -s vscode_settings.json $HOME/Library/Application Support/Code/User/settings.json
```

```bash
~/ws/aiden:$ code --list-extensions
adamwalzer.scss-lint
amatiasq.sort-imports
eamodio.gitlens
eg2.tslint
esbenp.prettier-vscode
GrapeCity.gc-excelviewer
Gruntfuggly.shifter
mechatroner.rainbow-csv
mrmlnc.vscode-scss
ms-python.python
PeterJausovec.vscode-docker
RoscoP.ActiveFileInStatusBar
vscodevim.vim
```

```sh
cp "$HOME/Library/Application Support/Code/User/settings.json" vscode_settings.json
```
