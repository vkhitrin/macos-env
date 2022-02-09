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
echo "Installing brew taps/casks/apps:"
brew bundle --file=./Setup/Brewfile

# Install libguestfs from local Formula
# [ -f ./Setup/homebrew/libguestfs.rb ] || error_exit "No libguestfs formula found"
# echo "Copying portableendian.h to homebrew"
# cp ./Setup/homebrew/portableendian.h /opt/homebrew/include/
# echo "Installing libguestfs"
# brew install -v --formula ./Setup/homebrew/libguestfs.rb

echo "Cleanup brew"
brew cleanup;brew autoremove

# Install amphetamine enhancer
if [[ ! $(ls -l /Applications | grep 'Amphetamine Enhancer') ]]; then
    wget https://github.com/x74353/Amphetamine-Enhancer/raw/master/Releases/Current/Amphetamine%20Enhancer.dmg -O /tmp/amphetamine_enhancer.dmg
    hdiutil attach /tmp/amphetamine_enhancer.dmg
    cp -R /Volumes/Amphetamine\ Enhancer/Amphetamine\ Enhancer.app /Applications
    hdiutil unmount /Volumes/Amphetamine\ Enhancer
fi

# Upgrade pip
echo "Upgrade pip"
pip3 install -U pip

# Install podman-compose
echo "Installing podman-compose via pip3"
pip3 install podman-compose

# Add completions to tools that are not shipped by zsh-completions
[ -f "$(brew --prefix)/share/zsh-completions/_podman" ] || podman completion zsh -f /opt/homebrew/share/zsh-completions/_podman
[ -f "$(brew --prefix)/share/zsh-completions/_limactl" ] || limactl completion zsh > /opt/homebrew/share/zsh-completions/_limactl

# Backup current dotfiles
[ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.bk

# Copy dotfiles to home directory
cp -r -f .zshenv .zshrc .config ~

# Apply defaults to applications

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Install defaults
bash ./Setup/macos_defaults.sh install

# Execute apple script
bash ./Setup/apple_script.sh install

# Copy mackup config file
cp .mackup.cfg ~/.mackup.cfg

# Copy mackup applications config file
rm -rf ~/.mackup; cp -r .mackup ~/.mackup

# Restore using mackup
mackup -f restore

echo "Please run 'compaudit | xargs chmod g-w' if needed."
