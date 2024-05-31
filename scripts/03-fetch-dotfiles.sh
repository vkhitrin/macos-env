#!/usr/bin/env bash
set -eo pipefail

source ./scripts/common.sh

# Dotfiles
print_padded_title "Repos - Clone dotfiles"
# Might fail, revisit on new re-install
[ -d "$HOME/Projects/Automation/dotfiles" ] || git clone --separate-git-dir="$HOME/Projects/Automation/dotfiles" http://github.com/vkhitrin/dotfiles /tmp/dotfiles
rsync --recursive --verbose --exclude "README.md" --exclude ".git" /tmp/dotfiles/ "$HOME/" && rm -rf /tmp/dotfiles
