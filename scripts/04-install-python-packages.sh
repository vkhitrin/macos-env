#!/usr/bin/env bash
set -eo pipefail

source ./scripts/common.sh

print_padded_title "Brew pipx - Install Additional Software"
declare -a PIPX_PACKAGES
declare -a PIPX_HARLEQUIN_PACKAGES
# NOTE: Install harlequin from source while support for Python 3.13 is not shipped.
#PIPX_PACKAGES=("passhole" "harlequin" "scylla-cqlsh" "rexi")
PIPX_PACKAGES=("passhole" "git+https://github.com/tconbeer/harlequin" "scylla-cqlsh" "rexi")
# NOTE: harlequin-cassandra does not work on Python 3.13 due to datastax driver
# PIPX_HARLEQUIN_PACKAGES=("catppuccin[pygments]" "boto3" "harlequin-postgres" "harlequin-mysql" "harlequin-odbc" "harlequin-cassandra" "git+https://github.com/ThomAub/harlequin-clickhouse")
PIPX_HARLEQUIN_PACKAGES=("boto3" "harlequin-postgres" "harlequin-mysql" "harlequin-odbc")
${HOMEBREW_BIN_PATH_PREFIX}/pipx install "${PIPX_PACKAGES[@]}"
for HARLEQUIN_PACKAGE in "${PIPX_HARLEQUIN_PACKAGES[@]}"; do
   ${HOMEBREW_BIN_PATH_PREFIX}/pipx inject harlequin "${HARLEQUIN_PACKAGE}"
done
${HOMEBREW_BIN_PATH_PREFIX}/pipx upgrade-all --include-injected
