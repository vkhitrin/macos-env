#!/usr/bin/env bash
set -eox pipefail

# Variable definition
UTM_VIRTUAL_MACHINE_DISPLAY_NAME=${UTM_VIRTUAL_MACHINE_DISPLAY_NAME:-ubuntu\-linux\-00}
UTM_VIRTUAL_MACHINE_VIRTUAL_CPU_COUNT=${UTM_VIRTUAL_MACHINE_VIRTUAL_CPU_COUNT:-4}
UTM_VIRTUAL_MACHINE_VIRTUAL_MEMORY_AMOUNT=${UTM_VIRTUAL_MACHINE_VIRTUAL_MEMORY_AMOUNT:-8192}
UTM_VIRTUAL_MACHINE_STORAGE_DEVICE_SIZE=${UTM_VIRTUAL_MACHINE_STORAGE_DEVICE_SIZE:-20g}
UTM_VIRTUAL_MACHINE_BUNDLES_DIRECTORY="$HOME/Library/Containers/com.utmapp.UTM/Data/Documents"
UTM_VIRTUAL_MACHINE_BUNDLE_PATH="$UTM_VIRTUAL_MACHINE_BUNDLES_DIRECTORY/$UTM_VIRTUAL_MACHINE_DISPLAY_NAME.utm"
# UBUNTU_ARCHIVE_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-arm64.tar.gz"
UBUNTU_VMLINUZ_URL="https://cloud-images.ubuntu.com/releases/jammy/release/unpacked/ubuntu-22.04-server-cloudimg-arm64-vmlinuz-generic"
UBUNTU_INITRD_URL="https://cloud-images.ubuntu.com/releases/jammy/release/unpacked/ubuntu-22.04-server-cloudimg-arm64-initrd-generic"

function _genereate_apple_virtual_machine_identifier {
swift repl << EOF > /tmp/apple_vm_identifier.txt
import Foundation
import Virtualization

struct VM: Codable {
    var machineIdentifier: Data?
}

let placeholder = VM(machineIdentifier: VZGenericMachineIdentifier().dataRepresentation)

let encoder = PropertyListEncoder()
do {
    let encodedData = try encoder.encode(placeholder)

    let tmpDirectory = FileManager.default.temporaryDirectory
    let plistURL = tmpDirectory.appendingPathComponent("vm.plist")

    try encodedData.write(to: plistURL)
    print("\(plistURL.path)")

} catch {
    print("Error encoding data to plist: \(error)")
}
EOF
cat /tmp/apple_vm_identifier.txt | tail -n1 | tr -d '\r' | xargs cat
rm -rf /tmp/apple_vm_identifier.txt
}

# Network device attachment has to be done via code, plist definition is not enough
# --- 
# function _generate_apple_random_mac_addres {
# swift repl << EOF
# import Virtualization
# print(VZMACAddress.randomLocallyAdministered().string)
# EOF
# }

source ./Setup/scripts/common.sh
[ -d "/Applications/UTM.app" ] || error_exit "UTM is not installed"
[ -d "$UTM_VIRTUAL_MACHINE_BUNDLES_DIRECTORY" ] || error_exit "UTM virtual machine bundle directory '$UTM_VIRTUAL_MACHINE_BUNDLES_DIRECTORY' is not present"

print_padded_title "UTM - Check For Existance Of '${UTM_VIRTUAL_MACHINE_BUNDLE_PATH}'"
[ ! -d "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH" ] || error_exit "Virtual machine bundle '$UTM_VIRTUAL_MACHINE_BUNDLE_PATH'"

print_padded_title "UTM - Create '${UTM_VIRTUAL_MACHINE_BUNDLE_PATH}' Virtual Machine Bundle"
mkdir -p "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/Data"

print_padded_title "UTM - Generate Unique Apple Virtual Machine Identifier"
UTM_VIRTUAL_MACHINE_APPLE_VIRTUAL_MACHINE_IDENTIFIER=$(_genereate_apple_virtual_machine_identifier)
[ -n "$UTM_VIRTUAL_MACHINE_APPLE_VIRTUAL_MACHINE_IDENTIFIER" ]

# print_padded_title "UTM - Generate Unique Apple Virtual MAC Address"
# UTM_VIRTUAL_MACHINE_APPLE_VIRTUAL_MACHINE_MAC_ADDRESS=$(_generate_apple_random_mac_addres)
# [ -n "$UTM_VIRTUAL_MACHINE_APPLE_VIRTUAL_MACHINE_MAC_ADDRESS" ]

print_padded_title "UTM - Generate UTM Metadata Unique Identifiers"
UTM_VIRTUAL_MACHINE_UUID=$(uuidgen)
UTM_VIRTUAL_MACHINE_STORAGE_DEVICE_UUID=$(uuidgen)

print_padded_title "UTM - Generate 'config.plist'"
/usr/libexec/PlistBuddy -c 'save' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Serial array' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Network array' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
# /usr/libexec/PlistBuddy -c "add :Network:0:MacAddress string $UTM_VIRTUAL_MACHINE_APPLE_VIRTUAL_MACHINE_MAC_ADDRESS" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
# /usr/libexec/PlistBuddy -c 'add :Network:0:Mode string Shared' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Serial:0:Mode string Terminal' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Serial:0:Terminal:BackgroundColor string #000000' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Serial:0:Terminal:Font string Menlo' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Serial:0:Terminal:CursorBlink bool true' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Serial:0:Terminal:FontSize integer 12' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Serial:0:Terminal:ForegroundColor string #ffffff' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Backend string Apple' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :System:Architecture string aarch64' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :System:CPUCount integer $UTM_VIRTUAL_MACHINE_VIRTUAL_CPU_COUNT" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :System:MemorySize integer $UTM_VIRTUAL_MACHINE_VIRTUAL_MEMORY_AMOUNT" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :System:GenericPlatform:machineIdentifier data $UTM_VIRTUAL_MACHINE_APPLE_VIRTUAL_MACHINE_IDENTIFIER" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :System:Boot:UEFIBoot bool false' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :System:Boot:OperatingSystem string Linux' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :System:Boot:LinuxKernelPath string $(basename ${UBUNTU_VMLINUZ_URL})" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :System:Boot:LinuxInitialRamdiskPath string $(basename ${UBUNTU_INITRD_URL})" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Virtualization:Pointer bool true' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Virtualization:Trackpad bool false' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Virtualization:Keyboard bool true' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Virtualization:Audio bool true' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Virtualization:Entropy bool true' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Virtualization:Rosetta bool true' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Virtualization:Balloon bool true' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Virtualization:ClipboardSharing bool true' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Information:Icon string ubuntu' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :Information:Name string $UTM_VIRTUAL_MACHINE_DISPLAY_NAME" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :Information:UUID string $UTM_VIRTUAL_MACHINE_UUID" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Information:IconCustom bool false' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Display array' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Display:0:HeightPixels integer 1080' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Display:0:PixelsPerInch integer 80' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Display:0:WidthPixels integer 1920' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Drive array' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :Drive:0:Identifier string $UTM_VIRTUAL_MACHINE_STORAGE_DEVICE_UUID" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :Drive:0:ImageName string $UTM_VIRTUAL_MACHINE_STORAGE_DEVICE_UUID.img" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :Drive:0:ReadOnly bool false" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :ConfigurationVersion integer 4' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"

print_padded_title "UTM - Download External Ubuntu Linux Binaries"
test -f "$HOME/Downloads/$(basename ${UBUNTU_VMLINUZ_URL})" || wget -qO ${UBUNTU_VMLINUZ_URL} "$HOME/Downloads/$(basename ${UBUNTU_VMLINUZ_URL})"
test -f "$HOME/Downloads/$(basename ${UBUNTU_INITRD_URL})" || wget -qO ${UBUNTU_INITRD_URL} "$HOME/Downloads/$(basename ${UBUNTU_INITRD_URL})"

print_padded_title "UTM - Generate Disk Image (Storage)"
hdiutil create -layout none -size "$UTM_VIRTUAL_MACHINE_STORAGE_DEVICE_SIZE" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/Data/$UTM_VIRTUAL_MACHINE_STORAGE_DEVICE_UUID"
mv "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/Data/$UTM_VIRTUAL_MACHINE_STORAGE_DEVICE_UUID.dmg" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/Data/$UTM_VIRTUAL_MACHINE_STORAGE_DEVICE_UUID.img"

print_padded_title "UTM - Import Virtual Machine Bundle"
open "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH"

print_padded_title "Notes"
# Network devices are usng `vmnet` framework, DHCP leases can be read at `/var/db/dhcpd_leases`, can be converted to JSON using `cat /var/db/dhcpd_leases | sed -e 's/\t\(.*\)=\(.*\)/"\1": "\2",/g' | tr -d '\n' | sed -E 's:,(\s*}):\1:g' | jq`
# Configuration is stored at `/Library/Preferences/SystemConfiguration/com.apple.vmnet.plist`
echo "* Don't forget to create network device manually!"
# Shared directories are stored in `defaults read com.utmapp.UTM`, should look for a way to inject this myself
echo "* Don't forget to share $HOME with virtual machine"
