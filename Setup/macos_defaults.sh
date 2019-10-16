#! /bin/bash

# TODO (vkhitrin): Consider using a generic logic for write and delete

ACTION=$1
if [[ $ACTION == 'install' ]];then
    echo "Writing macOS defaults"
    defaults write com.apple.screencapture disable-shadow -bool true
    defaults write com.apple.finder AppleShowAllFiles TRUE
    echo "Restarting Finder"
    killall Finder
elif [[ $ACTION == 'uninstall' ]]; then
    echo "Deleting macOS defaults"
    defaults delete com.apple.screencapture disable-shadow
    defaults delete com.apple.finder AppleShowAllFiles
    echo "Restarting Finder"
    killall Finder
else
    echo "Accepted arguments: 'install', 'uninstall'"
fi
