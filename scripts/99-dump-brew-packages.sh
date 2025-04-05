#!/usr/bin/env bash
set -eo pipefail

brew bundle dump --all --force
# NOTE: Workaround https://github.com/mas-cli/mas/issues/724
/usr/bin/mdfind -onlyin /Applications 'kMDItemAppStoreHasReceipt=1' -0 \
  | /usr/bin/xargs -0 /usr/bin/mdls -attr kMDItemAppStoreAdamID -attr kMDItemDisplayName \
  | while read -r id_line; do
      id=${id_line#*= }
      read -r name_line
      name=${name_line#*= }
      echo "mas $name, id: $id"
done | /usr/bin/sort >> Brewfile
