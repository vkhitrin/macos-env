#!/usr/bin/env bash
set -eo pipefail

source ./Setup/scripts/common.sh

# Ensure iCloud is enabled on system
/usr/libexec/PlistBuddy -c "print :Accounts:0:Services:" ~/Library/Preferences/MobileMeAccounts.plist | grep MOBILE_DOCUMENTS -A3 -B3 | grep 'Enabled = true' > /dev/null 2>/dev/null || error_exit "iCloud is not enabled on the system"

# If Xcode is not installed, we wish to skip Developer related items from Spotlight search
print_padded_title "Workarounds - /Applications/Xcode.app"
[ -d "/Applications/Xcode.app" ] || mkdir /Applications/Xcode.app

# Create symlink to iCloud Drive
print_padded_title "Directories - .iCloud"
[ -d "$HOME/.iCloudDrive" ] || ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/" "$HOME/.iCloudDrive"

# Create Directories
print_padded_title "Directories - Projects"
mkdir -p "$HOME/Projects/Automation/Setup" "$HOME/Projects/Development" "$HOME/Projects/Containers" "$HOME/Documents/Screenshots"

print_padded_title "Directories - .local"
mkdir -p "$HOME/.local/bin"
