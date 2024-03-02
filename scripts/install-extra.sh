#!/usr/bin/env bash
set -eo pipefail

source ./scripts/common.sh

# Install Apple's SF Mono font
print_padded_title "Fonts - Apple SF Mono Font"
set +e
SF_MONO_FONTS=$($HOMEBREW_PATH_PREFIX/fc-list : file family | grep 'SF Mono')
set -e
if [ -z "$SF_MONO_FONTS" ];then
    curl https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg -o /tmp/SF-Mono.dmg
    hdiutil mount /tmp/SF-Mono.dmg
    sudo installer -pkg /Volumes/SFMonoFonts/SF\ Mono\ Fonts.pkg -target /
    hdiutil unmount "$(mount | grep SFMono | cut -d ' ' -f1)"
fi

# Dotfiles
print_padded_title "Repos - Clone dotfiles"
# Might fail, revisit on new re-install
[ -d "$HOME/Projects/Automation/dotfiles" ] || git clone --separate-git-dir="$HOME/Projects/Automation/dotfiles" http://github.com/vkhitrin/dotfiles /tmp/dotfiles; rsync --recursive --verbose --exclude "README.md" --exclude ".git" /tmp/dotfiles/ "$HOME/" && rm -rf /tmp/dotfiles

print_padded_title "Mackup - Install Via System's Python"
/usr/bin/python3 -m pip install mackup

print_padded_title "pip3 - Install Additional Software Using Brew's pip"
$HOMEBREW_PATH_PREFIX/pip3 install --break-system-packages --upgrade passhole s3cmd harlequin[postgres,s3,mysql,odbc] scylla-cqlsh catppuccin[pygments]
