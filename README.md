Dotfiles
========

If you run a `.bash_profile` then you should probably add this:

```bash
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
```

Table of Contents
-----------------
<!-- vim-markdown-toc GFM -->

- [Setting up my mac](#setting-up-my-mac)
	- [How to setup packages](#how-to-setup-packages)
	- [Common brew packages](#common-brew-packages)
- [Font](#font)
- [Custom git setup](#custom-git-setup)
- [Custom Caching setup](#custom-caching-setup)
- [Rust setup](#rust-setup)
- [homebrew](#homebrew)
- [zsh](#zsh)
- [Making symlinks](#making-symlinks)
- [Deleting symlinks](#deleting-symlinks)
- [Tmux Setup](#tmux-setup)
- [Vim Setup](#vim-setup)
- [FZF setup](#fzf-setup)
- [VS Code Setup](#vs-code-setup)
	- [History](#history)
- [Vrapper Setup](#vrapper-setup)
- [vifm](#vifm)
- [vimium](#vimium)
	- [Kill sticky and similar bookmarks](#kill-sticky-and-similar-bookmarks)
- [Vimium C](#vimium-c)
	- [Custom CSS](#custom-css)
- [CRKBD Keyboard Layout](#crkbd-keyboard-layout)
	- [Required steps to build](#required-steps-to-build)
	- [OS steps](#os-steps)
	- [2021-03-28 layout](#2021-03-28-layout)
	- [Building a new layout from qmk configurator](#building-a-new-layout-from-qmk-configurator)
- [MacOS Keyboard Layout](#macos-keyboard-layout)
- [Plover](#plover)
- [Emacs](#emacs)
- [Remote pbcopy (deprecated)](#remote-pbcopy-deprecated)
- [Auto Fetch](#auto-fetch)
- [Print to ReMarkable](#print-to-remarkable)

<!-- vim-markdown-toc -->

Setting up my mac
-----------------
1. Touchpad tap to click, keypress repeat time, alt left right to move spaces, don't auto rearrange spaces
2. accessibility drag + reduce motion
3. screen saver and screen off
4. Download chrome - disable third party cookies
5. Show on toolbar - full datetime, bluetooth, sound, battery percentage
6. Adjust all the finder settings
7. Download install packages (see next section)
8. Migrate these changes to `.macos` file
9. system settings -> accessibility -> zoom -> trackpad gestures + advanced (ctrl + option) to zoom
10. Keyboard -> keyboard shortcuts -> services: uncheck all shortcuts with cmd+shift+L etc

### How to setup packages
1. Install [homebrew](https://brew.sh/) `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
3. Install tmux, fzf, ripgrep, zsh, git, node, python
4. Clone dotfiles repo `git clone git@github.com:ayroblu/dotfiles.git` and deps `git clone git@github.com:ayroblu/deps.git`
5. Run the run.sh file to symlink: `bash scripts/run.sh`
6. Install [tpm](https://github.com/tmux-plugins/tpm), `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`, open tmux (you might need `tmux source ~/.tmux.conf`) and run `<prefix> + I`
7. Install vim plug and run `:PlugInstall`
8. Install macvim with `brew install --cask macvim --no-binaries`

### Common brew packages
- brew install vldmrkl/formulae/airdrop-cli
  - Doesn't work?
- python jq fd gitdelta node neovim fzf ripgrep tmux bat tree chafa coursier exiftool extract_url htop less make rustup-init trash urlview
- charles vimmotion keepingyouawake espanso rectangle raycast dbeaver-community docker dropbox fuwari finestructure/Hummingbird/hummingbird imageoptim keycastr visual-studio-code flipper android-studio macvim

Font
----

I like Monaco, I think it's a good fixed width font but it doesn't support bold, italics, and nerd fonts. Clone and add to font book: git@github.com:krfantasy/monego.git (based on git@github.com:cseelus/monego.git)

Custom git setup
----------------
If you need to customise git (email for example), consider using the following gitconfig instead:

```ini
# Make sure include is first
[include]
  path = ws/dotfiles/.gitconfig
# All other settings
[user]
  name = Name Here
  email = email@email.com
```

Custom Caching setup
--------------------
I have a bespoke caching function here. This adds it to your path

```bash
ln -s $(pwd)/scripts/cache_fzf.js ~/bin/cache_fzf.js
```

Rust setup
----------
```bash
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

To remove a package with depedencies:
https://stackoverflow.com/questions/7323261/uninstall-remove-a-homebrew-package-including-all-its-dependencies

```bash
brew tap beeftornado/rmtree
brew rmtree <package>
```

zsh
---
Sometimes terminal is slow, you can use the preload system to quickly quit and drop into a raw
shell with no rcs

```sh
mkdir ~/preload
cat <<EOF > ~/preload/.zshrc
ZDOTDIR="$HOME" PRELOAD=t zsh
exit
EOF
```

I have yet to confirm this is actually useful, may delete if ctrl-c doesn't work as is

Making symlinks
---------------
```bash
bash scripts/run.sh
```

Deleting symlinks
-----------------
> https://stackoverflow.com/questions/22097130/delete-all-broken-symbolic-links-with-a-line

With zsh

```zsh
rm -- *(-@D)
```

Tmux Setup
----------
This requires TPM:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Vim Setup
---------
Install vim-plug: https://github.com/junegunn/vim-plug
Run `:PlugInstall` in vim

Do the same for neovim

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
trash "$HOME/Library/Application Support/Code/User/settings.json"
ln -s "$HOME/ws/dotfiles/vscode_settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
```

### History

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

Vrapper Setup
-------------
In dbeaver, install vrapper: http://vrapper.sourceforge.net/documentation/?topic=basics

> http://vrapper.sourceforge.net/update-site/stable

It should automatically take the .vwrapperrc from home dir

vifm
----
`brew install vifm`

```bash
ln -s ~/ws/dotfiles/vifmrc ~/.config/vifm/vifmrc
ln -s ~/ws/dotfiles/solarized-light.vifm ~/.config/vifm/colors/solarized-light.vifm
```

vimium
------
https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb?hl=en

- vimiumrc
- vimiumsearch

### Kill sticky and similar bookmarks
Because you can trigger bookmarks with `b`, you can trigger these js bookmarks really easily. To make a change to them use:

```js
decodeURIComponent(`(function()%7B(function%20()%20%7Bvar%20i%2C%20elements%20%3D%20document.querySelectorAll('body%20*')%3Bfor%20(i%20%3D%200%3B%20i%20%3C%20elements.length%3B%20i%2B%2B)%20%7Bif%20(%5B'fixed'%2C%20'sticky'%5D.includes(getComputedStyle(elements%5Bi%5D).position))%20%7Belements%5Bi%5D.parentNode.removeChild(elements%5Bi%5D)%3B%7D%7D%7D)()%7D)()`)
```

```js
const a = encodeURIComponent(`(function(){(function () {var i, elements = document.querySelectorAll('body *');for (i = 0; i < elements.length; i++) {if (['fixed', 'sticky'].includes(getComputedStyle(elements[i]).position)) {elements[i].parentNode.removeChild(elements[i]);}}})()})()`);
console.log(`javascript:${a}`);
```

Vimium C
--------
This works better than vimium because of it's better support for jumping in and out of insert mode, better support in GMail.

1. Disable smooth scrolling
2. set link hints as home row

### Custom CSS

```css
.LH {font-size: 1.2rem}
```

CRKBD Keyboard Layout
---------------------
This is for the Corne keyboard, you need qmk_firmware (github), and QMK Toolbox (cask) to flash it.

After cloning qmk_firmware, run: `make crkbd:default` to build the default firmware, run through the steps provided to download dependencies etc.

To play around with the layout, consider using this tool: https://config.qmk.fm/#/crkbd/rev1/common/LAYOUT_split_3x6_3

### Required steps to build

See the qmk fork for my keymap

Convert the json file to a keymap and install it with `make crkbd:ayroblu`.

### OS steps

- Terminal requires disabling the numpad emulation
- Function keys need to be normal function (not media) (done with karabiner)

### 2021-03-28 layout

Note to generate these, take a full screen snapshot with chrome, then run this script to get the cropped version for dotfiles:

```bash
convert ayroblu-corne-layout-tmp.png -crop 1387x4312+745+782 ayroblu-corne-layout.png

# Make side by side
convert ayroblu-corne-layout-tmp.png -crop 1387x2156+745+782 ayroblu-corne-layout-cropped-0-3.png
convert ayroblu-corne-layout-tmp.png -crop 1387x2156+745+2938 ayroblu-corne-layout-cropped-4-7.png
convert +append ayroblu-corne-layout-cropped-* ayroblu-corne-layout-side.png
```

![QMK layers](ayroblu-corne-layout.png)

### Building a new layout from qmk configurator

```sh
cd ~/ws/dotfiles
mv ~/Downloads/crkbd_rev1_common_layout_split_3x6_3_mine.json .
qmk json2c crkbd_rev1_common_layout_split_3x6_3_mine.json | pbcopy
cd ~/ws/qmk_firmware
vi keyboards/crkbd/keymaps/ayroblu/keymap.c
make crkbd:ayroblu:dfu
```

MacOS Keyboard Layout
---------------------
I wrote my own custom keyboard layout (ayro). Checkout workman's keyboard for more info and thoughts, but my reasoning was that COLEMAK has an extremely terrible vim (hjkl) layout, (dvorak is fine, but all the symbols are messed up), and I was annoyed at the seemingly useless key moves. My goal was to keep as many keys in the same place as possible while keeping similar performance numbers as colemak and workman. Another reason for this was that I hypothesised that I was likely to use a qwerty layout quite a lot so it would be good to maintain the skills.

Consider: http://patorjk.com/keyboard-layout-analyzer/ as a way to test out a keyboard layout + project gutenburg raw text

Theoretically I want to keylog my computer in the future.

```bash
cp -a ayrokeyboard/ayro.bundle '/Library/Keyboard Layouts/'
```

Plover
------
In setting up plover, point at the dictionaries in the plover folder. Note that specifically, UK order must go first, others do not matter as much

Emacs
-----
I followed the [doom emacs setup docs](https://github.com/hlissner/doom-emacs). Check there for the latest instructions:

``` bash
brew cask install emacs
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install
# y to envvar and fonts
# Add ~/.emacs.d/bin to path
doom sync
```

Doom emacs files are in the `.doom.d` directory

Add to your root dir like so (you may need to delete your existing one generated automatically)

``` bash
# cp -a ~/.doom.d .doom.d
# rmtrash ~/.doom.d
ln -s ~/ws/dotfiles/.doom.d ~/.doom.d
```

Remote pbcopy (deprecated)
-------------
Deprecated in favour of bin/pbcopy

> From https://gist.github.com/burke/5960455
>
> macOS opens inetd which pipes socket info to pbcopy and pbpaste and relies on netcat on the remote
>
> ```sh
> set -x
> ln -s "$(pwd)/remote-pbcopy/pbcopy.plist" ~/Library/LaunchAgents/pbcopy.plist
> ln -s "$(pwd)/remote-pbcopy/pbpaste.plist" ~/Library/LaunchAgents/pbpaste.plist
> launchctl load ~/Library/LaunchAgents/pbcopy.plist
> launchctl load ~/Library/LaunchAgents/pbpaste.plist
> ```
>
> Example ssh config, probably want to use `sshpb` alias to pass through ports by connection
>
> ```sshconfig
> Host myhost
>     HostName 192.168.1.123
>     User myname
>     RemoteForward 2324 127.0.0.1:2324
>     RemoteForward 2325 127.0.0.1:2325
> ```

Auto Fetch
----------

Regularly update your git repos with this launchctl command.

```sh
ln -s "$(pwd)/auto-fetch.plist" ~/Library/LaunchAgents/auto-fetch.plist
launchctl load ~/Library/LaunchAgents/auto-fetch.plist
```

> (thanks to this comment which was super helpful)
> https://stackoverflow.com/questions/47582989/launchd-not-able-to-access-mac-os-keychains#comment117557839_49288984

Note that you can view the logs of the runs defined in the StandardOutPath etc in the plist

Then your `~/bin/auto-fetch.sh` might look something like:

```sh
#!/bin/bash
set -euxo pipefail

echo "============"
date

sourcerepos=(
  ~/ws/source
)
for i in "${sourcerepos[@]}"; do
  cd "$i"
  git fetch origin
done
```

You can run it manually with

```sh
launchctl start local.autoFetch
```

Print to ReMarkable
-------------------
> https://github.com/juruen/rmapi/blob/master/docs/tutorial-print-macosx.md

See the `~/Library/PDF Services` directory for the workflow. Note I couldn't make any logs

1. Download and setup rmapi
2. Automator
3. PDF Plugin
4. Code and save ⌘s

```sh
cd ws
mkdir rmapi
cd rmapi
curl -L  https://github.com/juruen/rmapi/releases/download/v0.0.24/rmapi-macosx.zip -o rmapi.zip -o rmapi.zip
unzip rmapi.zip
./rmapi
```

Script to go in automator

```sh
for f in "$@"
do
  /Users/blu/ws/rmapi/rmapi put "$f" "To read"
done
```
