#!/usr/bin/env bash
set -eo pipefail

source ./scripts/common.sh

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
print_padded_title "defaults - Quit System Preferences"
osascript -e 'tell application "System Preferences" to quit'

# Install macOS defaults
print_padded_title "defaults - Configure defaults"
defaults -currentHost write -g AppleFontSmoothing -int 0
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write -g PMPrintingExpandedStateForPrint -bool true
defaults write -g PMPrintingExpandedStateForPrint2 -bool true
defaults write -g WebContinuousSpellCheckingEnabled -bool true
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2
defaults write com.apple.Accessibility KeyRepeatDelay "0.25"
defaults write com.apple.Accessibility KeyRepeatEnabled 1
defaults write com.apple.Accessibility KeyRepeatInterval "0.03333333299999999"
defaults write com.apple.TimeMachine "DoNotOfferNewDisksForBackup" -bool "true"
defaults write com.apple.appleseed.FeedbackAssistant "Autogather" -bool "false"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.dock "autohide" -bool "true"
defaults write com.apple.dock "autohide-time-modifier" -float "0"
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"
defaults write com.apple.finder "FXPreferredGroupBy" -string "Date Modified"
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"
defaults write com.apple.finder "ShowPathbar" -bool "true"
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.menuextra.clock "FlashDateSeparators" -bool "false"
defaults write com.apple.menuextra.clock "Show24Hour" -bool "true"
defaults write com.apple.menuextra.clock "ShowDate" -bool "true"
defaults write com.apple.menuextra.clock "ShowDayOfWeek" -bool "true"
defaults write com.apple.menuextra.clock "ShowSeconds" -bool "true"
defaults write com.apple.safari "ShowFullURLInSmartSearchField" -bool "true"
defaults write com.apple.screencapture "include-date" 0
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture location "$HOME/Documents/Screenshots"
defaults write com.apple.screencapture name "screencapture"
defaults write com.knollsoft.Rectangle screenEdgeGapBottom -int 10
defaults write com.knollsoft.Rectangle screenEdgeGapLeft -int 10
defaults write com.knollsoft.Rectangle screenEdgeGapRight -int 10
defaults write com.knollsoft.Rectangle screenEdgeGapTop -int 10
defaults write net.tunnelblick.tunnelblick doNotLaunchOnLogin -bool true
#
# Install macOS defaults
print_padded_title "defaults - Configure Custom Keybindings"
# Command + Shift + 0 to open menu entry `Show Writing Tools`
defaults write -g NSUserKeyEquivalents -dict-add "Show Writing Tools" '@^$0'

print_padded_title "defaults - Kill applications"
killall -q SystemUIServer || true
killall -q Finder || true
killall -q Dock || true
killall -q Safari || true
