#!/usr/bin/env bash

set -eux -o pipefail

# Define variables
IMAGE_REMOTE_URL=${IMAGE_REMOTE_URL:-https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/36.20221030.3.0/aarch64/fedora-coreos-36.20221030.3.0-live.aarch64.iso}
IMAGE_URI=${IMAGE_URI:-/tmp/$(basename $IMAGE_REMOTE_URL)}
IGNITION_USER_SSH_FILE=${IGNITION_USER_SSH_FILE:-$HOME/.ssh/id_rsa.pub}
IGNITION_PODMAN_SSH_FILE=${IGNITION_PODMAN_SSH_FILE:-$HOME/.ssh/podman.pub}
IGNITION_FILE_TEMPLATE=${IGNITION_FILE_TEMPLATE:-./Setup/lima/ignition_config_template.yaml}
GENERATED_HUMAN_IGNITION_FILE=${GENERATED_HUMAN_IGNITION_FILE:-/tmp/generated_ignition_file.yaml}
IGNITION_FILE=config.ign
TEMPORARY_WORK_DIR=${TEMPORARY_WORK_DIR:-/tmp/fcos}
MODIFIED_ISO_IMAGE=${MODIFIED_ISO_IMAGE:-/tmp/fcos.iso}


echo "Pre-req step 1: Ensure lighttpd is running"
brew services restart lighttpd

# Download image if it does not exist
echo "Step 1: Download Fedora CoreOS image if required"
[ -f ${IMAGE_URI} ] || wget -nc ${IMAGE_REMOTE_URL} -O ${IMAGE_URI}

echo "Step 2: Download geteltorito tool"
# Download geteltorito.pl tool
[ -f /tmp/geteltorito.pl ] || wget -nc https://userpages.uni-koblenz.de/~krienke/ftp/noarch/geteltorito/geteltorito/geteltorito.pl -O /tmp/geteltorito.pl
chmod +x /tmp/geteltorito.pl

echo "Step 3: Extract bootable media from ISO and fetch volume information"
/tmp/geteltorito.pl -o /tmp/boot.bin ${IMAGE_URI}
ISO_VOLUME_ID=$(isoinfo -i ${IMAGE_URI} -d | grep 'Volume id:' | sed -e 's/Volume id: //g')

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
cp ${IGNITION_FILE} /opt/homebrew/var/www/${IGNITION_FILE}.html

echo "Step 7: Exit if image has an open handler"
lsof ${IMAGE_URI} && exit

echo "Step 8: Mount image"
MOUNT_INFO=$(hdiutil attach ${IMAGE_URI} | xargs)
MOUNT_DRIVE=$(echo ${MOUNT_INFO} | awk '{print $1}')
MOUNT_PATH=$(echo ${MOUNT_INFO} | awk '{print $2}')

echo "Step 9: Copy files from mounted ISO and create new directory for new ISO and update grub"
sudo rm -rf ${TEMPORARY_WORK_DIR}
mkdir -p ${TEMPORARY_WORK_DIR}
cp -r ${MOUNT_PATH}/ ${TEMPORARY_WORK_DIR}
cp /tmp/boot.bin ${TEMPORARY_WORK_DIR}
sudo sed -I '' "s/\t\(linux.*\)/\t\1 ignition.config.url=http:\/\/192.168.5.2:8080\/${IGNITION_FILE}.html/g" ${TEMPORARY_WORK_DIR}/EFI/fedora/grub.cfg

echo "Step 10: Unmount image"
hdiutil detach $MOUNT_DRIVE

echo "Step 11: Create new ISO image"
rm -f ${MODIFIED_ISO_IMAGE}
pushd ${TEMPORARY_WORK_DIR}
mkisofs -sysid LINUX -volid ${ISO_VOLUME_ID} -volset ${ISO_VOLUME_ID} -udf -no-emul-boot -relaxed-filenames -joliet-long -hide boot.bin -b boot.bin -D -o ${MODIFIED_ISO_IMAGE} ${TEMPORARY_WORK_DIR}
popd

echo "Step 12: Starting Fedora CoreOS VM"
yes "" | limactl start ./Setup/lima/fedora_coreos_podman_aarch64.yaml || test $? -eq 141
