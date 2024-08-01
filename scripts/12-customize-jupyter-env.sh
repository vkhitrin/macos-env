#!/usr/bin/env bash
set -eo pipefail

source ./scripts/common.sh

print_padded_title "golang - Install 'gonb' Bindary"
go install github.com/janpfeifer/gonb@latest
go install golang.org/x/tools/cmd/goimports@latest
go install golang.org/x/tools/gopls@latest

print_padded_title "gonb - Install Kernel"
gonb --install
