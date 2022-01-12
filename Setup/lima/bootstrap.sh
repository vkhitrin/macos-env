#!/usr/bin/env bash

set -eux -o pipefail

# Define variables
APPLIENCE_URL=${APPLIENCE_URL:-https://download.libguestfs.org/binaries/appliance/appliance-1.46.0.tar.xz}
APPLIANCE_KERNEL_MD5=${APPLIANCE_KERNEL_MD5:-c7d4ca631036fa4a5f6e6a2e35bd7705}
COMPRESSED_IMAGE_URI=${COMPRESSED_IMAGE_URI:-/tmp/fedora-coreos-35.20211215.3.0-qemu.x86_64.qcow2.xz}
IMAGE_URI=${IMAGE_URI:-/tmp/fedora-coreos-35.20211215.3.0-qemu.x86_64.qcow2}
IMAGE_FORMAT=${IMAGE_FORMAT:-qcow2}
IGNITION_USER_SSH_FILE=${IGNITION_USER_SSH_FILE:-$HOME/.ssh/id_rsa.pub}
IGNITION_PODMAN_SSH_FILE=${IGNITION_PODMAN_SSH_FILE:-$HOME/.ssh/podman.pub}
IGNITION_FILE_TEMPLATE=${IGNITION_FILE_TEMPLATE:-./Setup/lima/ignition_config_template.yaml}
GENERATED_HUMAN_IGNITION_FILE=${GENERATED_HUMAN_IGNITION_FILE:-/tmp/generated_ignition_file.yaml}
IGNITION_FILE=${IGNITION_FILE:-/tmp/config.ign}

echo "Step 1: Downloading updated supermin appliance if required"
if [[ $APPLIANCE_KERNEL_MD5 != $(md5 ${LIBGUESTFS_PATH}/kernel | awk '{print $4}') ]];then
    wgen -nc $APPLIENCE_URL -O /tmp/$(basename ${APPLIENCE_URL})
    rm -rf $LIBGUESTFS_PATH/*
    tar -xvf /tmp/appliance-1.46.0.tar.xz --strip-components 1 -C $LIBGUESTFS_PATH 'appliance/*'
fi

# Download image if it does not exist
echo "Step 2: Download Fedora CoreOS image if required"
[ -f $COMPRESSED_IMAGE_URI ] || wget -nc https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/35.20211215.3.0/x86_64/fedora-coreos-35.20211215.3.0-qemu.x86_64.qcow2.xz -O /tmp/$(basename ${COMPRESSED_IMAGE_URI})

# Unarchive image if it is not present
echo "Step 3: Unarchive Fedora CoreOS image if required"
[ -f $IMAGE_URI ] || unxz -k $COMPRESSED_IMAGE_URI

echo "Step 4: Generating podman related SSH certificate if required"
[ -f $IGNITION_PODMAN_SSH_FILE ] || ssh-keygen -t ecdsa -f $HOME/.ssh/podman -N ''

# Retrieve SSH keys to be injected to ignition file
IGNITION_USER_SSH_KEY=$(cat ${IGNITION_USER_SSH_FILE} | sed -e 's/\+/\\+/g' | sed -e 's/\//\\\//g')
IGNITION_PODMAN_SSH_KEY=$(cat ${IGNITION_PODMAN_SSH_FILE} | sed -e 's/\+/\\+/g' | sed -e 's/\//\\\//g')

echo "Step 5: Generating human readable ignition file"
cp $IGNITION_FILE_TEMPLATE $GENERATED_HUMAN_IGNITION_FILE
sed -i '' "s/<ENTER_AUTHORIZED_USER_KEY>/${IGNITION_USER_SSH_KEY}/g" $GENERATED_HUMAN_IGNITION_FILE
sed -i '' "s/<ENTER_AUTHORIZED_PODMAN_KEY>/${IGNITION_PODMAN_SSH_KEY}/g" $GENERATED_HUMAN_IGNITION_FILE
sed -i '' "s/<ENTER_USERNAME_HERE>/${USER}/g" $GENERATED_HUMAN_IGNITION_FILE

echo "Step 6: Generating CoreOS ignition file using butane"
butane $GENERATED_HUMAN_IGNITION_FILE -s -o $IGNITION_FILE

echo "Step 7: Discovering boot device for image"
IMAGE_BOOT_DEVICE=$(virt-filesystems --format=$IMAGE_FORMAT -a $IMAGE_URI -l | grep boot | awk -F ' ' '{print $1}')

echo "Step 8: Upload ignition file to image"
# Check if file is already exists in image and delete it if required
if [[ $(virt-cat --format=$IMAGE_FORMAT -a $IMAGE_URI -m $IMAGE_BOOT_DEVICE:/ /ignition/config.ign) ]];then
    guestfish add $IMAGE_URI : run : mount "$IMAGE_BOOT_DEVICE" / : rm-rf /ignition : unmount-all : exit
fi
guestfish add $IMAGE_URI : run : mount "$IMAGE_BOOT_DEVICE" / : mkdir /ignition : copy-in $IGNITION_FILE /ignition/ : unmount-all : exit

echo "Step 9: Starting Fedora CoreOS VM"
yes "" | limactl start ./Setup/lima/fedora_coreos_podman.yaml || test $? -eq 141
