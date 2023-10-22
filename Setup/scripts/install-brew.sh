#!/usr/bin/env bash
set -eo pipefail

source ./Setup/scripts/common.sh

# Verify brew is installed
which brew > /dev/null 2>/dev/null || error_exit "Brew is not installed, please download from https://brew.sh/"

# Disable brew analytics
print_padded_title "Brew - Disable Analytics"
brew analytics off

# Update brew
print_padded_title "Brew - Update"
brew update

# Install brew packages
print_padded_title "Brew - Install/Update"
[ -f ./Setup/Brewfile ] || error_exit "No Brewfile is found"
brew bundle --quiet --file=./Setup/Brewfile

# Soft links
print_padded_title "Files - Soft Links"
ln -sf /opt/homebrew/bin/yt-dlp /opt/homebrew/bin/youtube-dl

# Cleanup brew
print_padded_title "Brew - Cleanup"
brew cleanup
brew autoremove

# Brew completions
print_padded_title "Brew - Completions"
# Link shipped brew completions
brew completions link
# Add completions to tools that are not shipped by zsh-completions
[ -f "/opt/homebrew/share/zsh-completions/_podman" ] || podman completion zsh -f /opt/homebrew/share/zsh-completions/_podman
# [ -f "/opt/homebrew/share/zsh-completions/_limactl" ] || limactl completion zsh > /opt/homebrew/share/zsh-completions/_limactl
# [ -f "/opt/homebrew/share/zsh-completions/_oc" ] || oc completion zsh > /opt/homebrew/share/zsh-completions/_oc
[ -f "/opt/homebrew/share/zsh-completions/_gh" ] || gh completion -s zsh > /opt/homebrew/share/zsh-completions/_gh
# [ -f "/opt/homebrew/share/zsh-completions/_glab" ] || glab completion -s zsh > /opt/homebrew/share/zsh-completions/_glab
# [ -f "/opt/homebrew/share/zsh-completions/_bw" ] || bw completion --shell zsh > /opt/homebrew/share/zsh-completions/_bw
[ -f "/opt/homebrew/share/zsh-completions/_rtx" ] || rtx completion zsh > /opt/homebrew/share/zsh-completions/_rtx
[ -f "/opt/homebrew/share/zsh-completions/_snipkit" ] || snipkit completion zsh > /opt/homebrew/share/zsh-completions/_snipkit
# [ -f "/opt/homebrew/share/zsh-completions/_virtctl" ] || virtctl completion zsh > /opt/homebrew/share/zsh-completions/_virtctl
