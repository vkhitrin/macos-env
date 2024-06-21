#!/usr/bin/env bash
set -eo pipefail

source ./scripts/common.sh

print_padded_title "System Python - Install mackup"
/usr/bin/python3 -m pip install mackup

print_padded_title "Brew Python - Install Additional Software"
$HOMEBREW_PATH_PREFIX/pip3 install --break-system-packages --upgrade pip passhole harlequin[postgres,s3,mysql,odbc,cassandra] scylla-cqlsh catppuccin[pygments]
