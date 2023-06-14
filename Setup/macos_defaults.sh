#! /bin/bash

# TODO (vkhitrin): Consider using a generic logic for write and delete

ACTION=$1
if [[ $ACTION == 'install' ]];then
    defaults write com.apple.screencapture disable-shadow -bool true
    defaults write com.apple.finder AppleShowAllFiles -bool true
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.Accessibility KeyRepeatDelay "0.25"
    defaults write com.apple.Accessibility KeyRepeatEnabled 1
    defaults write com.apple.Accessibility KeyRepeatInterval "0.03333333299999999"
    defaults write net.tunnelblick.tunnelblick doNotLaunchOnLogin -bool true
    defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
    defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true
    defaults write -g PMPrintingExpandedStateForPrint -bool true
    defaults write -g PMPrintingExpandedStateForPrint2 -bool true
    defaults write -g WebContinuousSpellCheckingEnabled -bool true
    defaults write com.apple.dock "autohide" -bool "true"
    defaults write com.apple.dock "autohide-time-modifier" -float "0"
    # TODO apply defaults based on file names in ./Setup/defaults/*
    defaults import com.if.Amphetamine ./Setup/defaults/com.if.Amphetamine.plist
    defaults import com.if.Amphetamine-Enhancer ./Setup/defaults/com.if.Amphetamine-Enhancer.plist
    defaults write com.apple.TimeMachine "DoNotOfferNewDisksForBackup" -bool "true"
    defaults write com.apple.safari "ShowFullURLInSmartSearchField" -bool "true"
    defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
    defaults write com.apple.finder "ShowPathbar" -bool "true"
    defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"
    defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"
    defaults write com.apple.finder "FXPreferredGroupBy" -string "Date Modified"
    defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"
    defaults write com.apple.menuextra.clock "FlashDateSeparators" -bool "false"
    defaults write com.apple.menuextra.clock "Show24Hour" -bool "true"
    defaults write com.apple.menuextra.clock "ShowDate" -bool "true"
    defaults write com.apple.menuextra.clock "ShowDayOfWeek" -bool "true"
    defaults write com.apple.menuextra.clock "ShowSeconds" -bool "true"
    defaults write com.apple.appleseed.FeedbackAssistant "Autogather" -bool "false"
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 2
    defaults write com.apple.screencapture location "~/Documents/Screenshots"
    defaults write org.alacritty AppleFontSmoothing -int 0
elif [[ $ACTION == 'uninstall' ]]; then
    defaults delete com.apple.screencapture disable-shadow
    defaults delete com.apple.finder AppleShowAllFiles
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool false
    defaults delete net.tunnelblick.tunnelblick doNotLaunchOnLogin
    defaults write -g NSNavPanelExpandedStateForSaveMode -bool false
    defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool false
    defaults write -g PMPrintingExpandedStateForPrint -bool false
    defaults write -g PMPrintingExpandedStateForPrint2 -bool false
    defaults write -g WebContinuousSpellCheckingEnabled -boolean false
    defaults delete com.apple.dock "autohide-time-modifier"
    defaults delete com.if.Amphetamine
    defaults delete com.if.Amphetamine-Enhancer
    defaults delete com.apple.TimeMachine "DoNotOfferNewDisksForBackup"
    defaults delete com.apple.safari "ShowFullURLInSmartSearchField"
    defaults delete NSGlobalDomain "AppleShowAllExtensions"
    defaults delete com.apple.finder "ShowPathbar"
    defaults delete com.apple.finder "FXPreferredViewStyle"
    defaults delete com.apple.finder "FXDefaultSearchScope"
    defaults delete com.apple.finder "FXPreferredGroupBy"
    defaults delete com.apple.finder "FXEnableExtensionChangeWarning"
    defaults delete com.apple.menuextra.clock "FlashDateSeparators"
    defaults delete com.apple.menuextra.clock "Show24Hour"
    defaults delete com.apple.menuextra.clock "ShowDate"
    defaults delete com.apple.menuextra.clock "ShowDayOfWeek"
    defaults delete com.apple.menuextra.clock "ShowSeconds"
    defaults delete com.apple.appleseed.FeedbackAssistant "Autogather"
    defaults delete NSGlobalDomain AppleKeyboardUIMode
    defaults delete com.apple.screencapture location
    defaults delete org.alacritty AppleFontSmoothing
    defaults write com.apple.dock "autohide" -bool "false"
else
    echo "Accepted arguments: 'install', 'uninstall'"
fi
