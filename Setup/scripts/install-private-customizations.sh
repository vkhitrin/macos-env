#!/usr/bin/env bash
set -eo pipefail

source ./Setup/scripts/common.sh

print_padded_title "iCloud - Check"
[ -d "${HOME}/.iCloudDrive" ] || error_exit "iCloud symlink doesn't exist"
[ -d "${HOME}/.iCloudDrive/Documents/Scripts/macOS" ] || error_exit "scripts directory doesn't exist in iCloud"

print_padded_title "iCloud - Execute Private Script"
[ -f "${HOME}/.iCloudDrive/Documents/Scripts/macOS/install-private-customizations.sh" ] || error_exit "Private script doesn't exist"
"${HOME}/.iCloudDrive/Documents/Scripts/macOS/install-private-customizations.sh"
