Bash Configuration
==================

This is just my bashrc configuration, plus some setup scripts

I'd like to setup some curses stuff too cause that's cool stuff! (rather than read or whatever bash runs for waiting for file input)

If you run a `.bash_profile` then you should probably add this:

```bash
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
```

Tmux Setup
----------
This requires TPM:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Vim Setup
---------
Install all these plugins:

Run plug install

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
