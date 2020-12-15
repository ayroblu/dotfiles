#!/bin/bash
set -x
ln -s "$(pwd)/remote-pbcopy/pbcopy.plist" ~/Library/LaunchAgents/pbcopy.plist
ln -s "$(pwd)/remote-pbcopy/pbpaste.plist" ~/Library/LaunchAgents/pbpaste.plist
launchctl load ~/Library/LaunchAgents/pbcopy.plist
launchctl load ~/Library/LaunchAgents/pbpaste.plist

