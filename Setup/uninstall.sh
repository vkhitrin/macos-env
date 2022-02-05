#!/usr/bin/env bash

set -eo pipefail

# Function which prints an error message and then returns exit code 1
function error_exit {
    echo "$1" >&2
    exit "${2:-1}"
}

# Make sure script isn't executed on non macOS systems
if [[ $(uname) != "Darwin" ]];then
    error_exit "Please make sure you're running on macOS"
fi

# Verify brew is installed
which brew > /dev/null 2>/dev/null || error_exit "Brew is not installed, please download from https://brew.sh/"

# Verify existence of Brewfile
[ -f ./Setup/Brewfile ] || error_exit "No Brewfile is found"
echo "Uninstalling brew taps/casks/apps:"
brew bundle --file=./Setup/Brewfile cleanup --force

# Uninstall amphetamine enhancer
if [[ $(ls -l /Applications | grep 'Amphetamine Enhancer') ]]; then
    rm -rf /Applications/Amphetamine\ Enhancer/Amphetamine\ Enhancer.app
fi


# Restore from backup if exists
[ -f ~/.zshrc.bk ] && mv ~/.zshrc.bk ~/.zshrc
[ -f ~/.tmux.conf.bk ] && mv ~/.tmux.conf.bk ~/.tmux.conf

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Uninstall defaults
bash ./Setup/macos_defaults.sh uninstall

# Execute apple script
bash ./Setup/apple_script.sh uninstall

# Remove mackup config file
rm -f ~/.mackup.cfg

# Remove mackup applications config file
rm -rf .mackup ~/.mackup
