Dotfiles
========

If you run a `.bash_profile` then you should probably add this:

```bash
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
```

Setting up my mac
-----------------
1. Touchpad
2. Keypress time
3. alt left right spaces
4. screen saver and screen off
5. accessibility drag + reduce motion
6. Download chrome - disable third party cookies

Rust setup
----------
```
# Init
brew install rustup
rustup-init
rmtrash ~/.zprofile
rmtrash ~/.profile
rustup component add rustfmt

# Install racer
rustup toolchain add nightly
cargo +nightly install racer
rustup component add rust-src
racer complete std::io::B

# Install rls (setup in vim)
rustup component add rls
```

Checkout https://crates.io/crates/cargo-outdated for when your packages go out of date

homebrew
--------
Install homebrew

Install the packages that are listed in the brew lists

zsh
---
Install oh my zsh

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

FZF setup
---------
After brew install fzf, make sure you run the key bindings setup

```bash
/usr/local/opt/fzf/install
```

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
