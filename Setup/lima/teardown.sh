#!/usr/bin/env bash

COMPRESSED_IMAGE_URI=${COMPRESSED_IMAGE_URI:-/tmp/fedora-coreos-35.20211215.3.0-qemu.x86_64.qcow2.xz}
IMAGE_URI=${IMAGE_URI:-/tmp/fedora-coreos-35.20211215.3.0-qemu.x86_64.qcow2}
GENERATED_HUMAN_IGNITION_FILE=${GENERATED_HUMAN_IGNITION_FILE:-/tmp/generated_ignition_file.yaml}
IGNITION_FILE=${IGNITION_FILE:-/tmp/config.ign}
LIMA_CACHE_PRUNE=${LIMA_CACHE_PRUNE:-true}
REMOVE_USER_FILES=${REMOVE_USER_FILES:-false}

# Remove lima VM
echo "Step 1: Removing VM if required"
limactl stop -f fedora_coreos_podman; limactl delete fedora_coreos_podman

# Delete lima cache
echo "Step 2: Deleting lima cache if required"
[ $LIMA_CACHE_PRUNE == 'true' ] && limactl prune

# Remove files
echo "Step 3: Removing files if required"
[ $REMOVE_USER_FILES == 'true' ] && rm -rf $COMPRESSED_IMAGE_URI $IMAGE_URI $GENERATED_HUMAN_IGNITION_FILE $IGNITION_FILE || exit 0
