#!/usr/bin/env bash
set -eo pipefail

source ./scripts/common.sh

print_padded_title "gh - Install GitHub CLI Extensions"
if [ -f /opt/homebrew/bin/gh ]; then
    gh extension install --force yusukebe/gh-markdown-preview
    gh extension install --force dlvhdr/gh-dash
fi
