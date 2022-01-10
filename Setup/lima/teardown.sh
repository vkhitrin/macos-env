#!/usr/bin/env bash

COMPRESSED_IMAGE_URI='/tmp/fedora-coreos-35.20211215.3.0-qemu.x86_64.qcow2.xz'
IMAGE_URI='/tmp/fedora-coreos-35.20211215.3.0-qemu.x86_64.qcow2'
GENERATED_HUMAN_IGNITION_FILE='/tmp/generated_ignition_file.yaml'
IGNITION_FILE='/tmp/config.ign'

# Remove lima VM
echo "Removing VM if required"
limactl stop -f fedora_coreos_podman; limactl delete fedora_coreos_podman

# Delete lima cache
echo "Deleting lima cache"
limactl prune

# Remove files
echo "Removing files if required"
rm -rf $COMPRESSED_IMAGE_URI $IMAGE_URI $GENERATED_HUMAN_IGNITION_FILE $IGNITION_FILE
