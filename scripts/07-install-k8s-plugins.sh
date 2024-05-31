#!/usr/bin/env bash
set -eo pipefail

source ./scripts/common.sh

# Kubernetes krew plugins
print_padded_title "krew - Install Kubernetes CLI Extensions Using krew"
if [ -f /opt/homebrew/bin/kubectl-krew ]; then
    kubectl krew install browse-pvc cert-manager ctr deprecations dup get-all graph history images node-admin node-logs node-restart node-shell nodepools resource-capacity restart sick-pods unlimited view-secret viewnode tree
fi

# helm plugins
print_padded_title "helm - Install Helm Plugins"
if [ -f /opt/homebrew/bin/helm ]; then
    helm plugin list | grep diff >/dev/null 2>/dev/null || helm plugin install https://github.com/databus23/helm-diff
fi
