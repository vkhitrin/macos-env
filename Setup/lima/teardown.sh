#!/usr/bin/env bash

IMAGE_REMOTE_URL=${IMAGE_REMOTE_URL:-https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/36.20221030.3.0/aarch64/fedora-coreos-36.20221030.3.0-live.aarch64.iso}
IMAGE_URI=${IMAGE_URI:-/tmp/$(basename $IMAGE_REMOTE_URL)}
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
