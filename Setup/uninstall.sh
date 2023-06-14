#!/usr/bin/env bash

set -eo pipefail

# Function which prints an error message and then returns exit code 1
function error_exit {
    echo "$1" >&2
    exit "${2:-1}"
}

function print_padded_title {
    termwidth="$(tput cols)"
    padding="$(printf '%0.1s' ={1..500})"
    printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}

# Make sure script isn't executed on non macOS systems
if [[ $(uname) != "Darwin" ]];then
    error_exit "Please make sure you're running on macOS"
fi

print_padded_title "Mackup - Uninstall"
mackup uninstall

print_padded_title "Mackup - Remove Config"
# Remove mackup config file
rm -f ~/.mackup.cfg
# Remove mackup applications config file
rm -rf .mackup ~/.mackup

print_padded_title "Brew"
# Verify brew is installed
which brew > /dev/null 2>/dev/null || error_exit "Brew is not installed, please download from https://brew.sh/"

print_padded_title "Brew - Uninstall"
[ -f ./Setup/Brewfile ] || error_exit "No Brewfile is found"
brew bundle --file=./Setup/Brewfile cleanup --force

print_padded_title "Applications - Uninstall Amphetamine Enhancer"
# Uninstall amphetamine enhancer
if [[ $(ls -l /Applications | grep 'Amphetamine Enhancer') ]]; then
    rm -rf /Applications/Amphetamine\ Enhancer/Amphetamine\ Enhancer.app
fi

print_padded_title "Brew - Cleanup"
brew cleanup;brew autoremove

print_padded_title "Config - Remove Files"
# Restore from backup if exists
[ -f ~/.zshrc.bk ] && mv ~/.zshrc.bk ~/.zshrc
[ -f ~/.tmux.conf.bk ] && mv ~/.tmux.conf.bk ~/.tmux.conf

print_padded_title "defaults - Quit System Preferences"
# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

print_padded_title "defaults - Revert defaults"
bash ./Setup/macos_defaults.sh uninstall

print_padded_title "ssh-agent - Remove Keys"
# Remove keys from SSH agent
ssh-add -D
