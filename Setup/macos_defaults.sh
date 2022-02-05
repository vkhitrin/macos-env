#! /bin/bash

# TODO (vkhitrin): Consider using a generic logic for write and delete

ACTION=$1
if [[ $ACTION == 'install' ]];then
    echo "Writing macOS defaults"
    defaults write com.apple.screencapture disable-shadow -bool true
    defaults write com.apple.finder AppleShowAllFiles true
    defaults write com.apple.desktopservices DSDontWriteNetworkStores true
    defaults write com.apple.Accessibility KeyRepeatDelay "0.25"
    defaults write com.apple.Accessibility KeyRepeatEnabled 1
    defaults write net.tunnelblick.tunnelblick doNotLaunchOnLogin -bool yes
    defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
    defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true
    defaults write -g PMPrintingExpandedStateForPrint -bool true
    defaults write -g PMPrintingExpandedStateForPrint2 -bool true
    defaults write -g WebContinuousSpellCheckingEnabled -boolean true
    defaults import com.if.Amphetamine ./Setup/defaults/com.if.Amphetamine.plist
    defaults import com.if.Amphetamine-Enhancer ./Setup/defaults/com.if.Amphetamine-Enhancer.plist
    echo "Restarting Finder"
    killall Finder
elif [[ $ACTION == 'uninstall' ]]; then
    echo "Deleting macOS defaults"
    defaults delete com.apple.screencapture disable-shadow
    defaults delete com.apple.finder AppleShowAllFiles
    defaults write com.apple.desktopservices DSDontWriteNetworkStores false
    defaults delete net.tunnelblick.tunnelblick doNotLaunchOnLogin
    defaults write -g NSNavPanelExpandedStateForSaveMode -bool false
    defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool false
    defaults write -g PMPrintingExpandedStateForPrint -bool false
    defaults write -g PMPrintingExpandedStateForPrint2 -bool false
    defaults write -g WebContinuousSpellCheckingEnabled -boolean false
    defaults delete com.if.Amphetamine
    defaults delete com.if.Amphetamine-Enhancer
    echo "Restarting Finder"
    killall Finder
else
    echo "Accepted arguments: 'install', 'uninstall'"
fi
