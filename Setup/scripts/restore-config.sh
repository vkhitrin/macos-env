#!/usr/bin/env bash
set -eo pipefail

source ./Setup/scripts/common.sh
 
# Ensure iCloud is enabled on system
/usr/libexec/PlistBuddy -c "print :Accounts:0:Services:" ~/Library/Preferences/MobileMeAccounts.plist | grep MOBILE_DOCUMENTS -A3 -B3 | grep 'Enabled = true' > /dev/null 2>/dev/null || error_exit "iCloud is not enabled on the system"

print_padded_title "Configuration - restore mackup backups"
cp -f .mackup.cfg "$HOME/"
rm -rf "$HOME/.mackup"
cp -rf .mackup "$HOME/.mackup"
mackup restore -vf && mackup uninstall --force 
open raycast://extensions/raycast/raycast/import-settings-data
