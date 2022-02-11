#!/usr/bin/env bash

set -eux -o pipefail

echo "Step 1: Download Modified Image"
s3cmd get s3://vkhitrin/personal_macos_fedora-coreos-35.20220116.3.0-qemu.aarch64.qcow2 /tmp/

echo "Step 2: Starting Fedora CoreOS VM"
yes "" | limactl start ./Setup/lima/fedora_coreos_podman.yaml || test $? -eq 141
