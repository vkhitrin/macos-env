#! /bin/bash

# TODO (vkhitrin): Consider using a generic logic for write and delete

ACTION=$1
if [[ $ACTION == 'install' ]];then
    echo "Writing macOS defaults"
    defaults write com.apple.screencapture disable-shadow -bool true
    defaults write com.apple.finder AppleShowAllFiles TRUE
    defaults write com.apple.desktopservices DSDontWriteNetworkStores true
    defaults write com.apple.Accessibility KeyRepeatDelay "0.25"
    defaults write com.apple.Accessibility KeyRepeatEnabled 1
    defaults write com.apple.Accessibility "0.03333333299999999"
    defaults  write  net.tunnelblick.tunnelblick  doNotLaunchOnLogin  -bool  yes
    echo "Restarting Finder"
    killall Finder
elif [[ $ACTION == 'uninstall' ]]; then
    echo "Deleting macOS defaults"
    defaults delete com.apple.screencapture disable-shadow
    defaults delete com.apple.finder AppleShowAllFiles
    defaults write com.apple.desktopservices DSDontWriteNetworkStores false
    defaults  write  net.tunnelblick.tunnelblick  doNotLaunchOnLogin
    echo "Restarting Finder"
    killall Finder
else
    echo "Accepted arguments: 'install', 'uninstall'"
fi
