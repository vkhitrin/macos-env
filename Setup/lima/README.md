# lima

**NOTE:** lima doesn't support CoreOS based distributions due to
it not supporting `ignition` and only supporting `cloud-init`.

[lima](https://github.com/lima-vm/lima) is a tool to launch Linux
virtual machines on macOS using QEMU.

## Why

Running Linux VMs on macOS is beneficial due to many reasons. Personally
I want to work with container technologies which are not supported by darwin
(macOS' kernel).  
[Podman](https://github.com/containers/podman) runtime on macOS requires a Linux
VM.  
It is possible to use the `podman` CLI to configure a Fedora CoreOS VM to act as
a podman host.

It is impossible to mount local directories when using `podman` to create a
VM. lima allows mounting local directories to VMs which will allow
containers to mount local directories.

Not everything is fully supported and I am using workarounds.

## Prerequisites And Workarounds

As mentioned above, lima doesn't support distributions like CoreOS
due to being reliant on cloud-init for bootstrapping.

I still wish to use lima so I will be providing workarounds on how to
achieve everything needed with manual workarounds.

### Prerequisites For Intel Based Macs

In order to boot a CoreOS instance the following dependencies must be satisfied:

* `bash` >= 3.5.3
* [libguestfs](https://libguestfs.org/) - Allows to access and modify tools.
* [macFUSE](https://osxfuse.github.io/) - Support for FUSE like filesystems on macOS.
* Allow SSH connections to macOS.

### Workarounds For Intel Based Macs

There are several workarounds needed for macOS:

* libguestfs is not natively present in brew. A user has compiled and provided
libguestfs for macOS [here](https://github.com/Amar1729/homebrew-libguestfs).
* Supplied appliance in amar1729/libguestfs is old, it should be replaced with a
newer appliance like `https://download.libguestfs.org/binaries/appliance/appliance-1.46.0.tar.xz`.
* macfuse should be installed in order to support FUSE file systems.
* Generate a compatible podman SSH key in order to [authenticate](https://github.com/containers/podman/blob/main/troubleshooting.md#26-exec-container-process-binsh-exec-format-error-or-another-binary-than-binsh)
with podman remotely.

All those workarounds are needed to modify the Fedora CoreOS image in order to
allow to use it as a podman host.

### Workarounds For Apple Silicon Macs

Sadly, I was unsuccessful in compiling libguestfs tools on Apple silicon.  
I am using a pre-generated image that was modified on x86 host.

Modified image is hosted on a private instance of s3 not accessible to outside world.  
[bootstrap_x86.sh](./Setup/lima/bootstrap_x86.sh) script was used to generate the modified aarch64 image.

## Usage

In order to start a Fedora CoreOS VM using lima run `make bootstrap-lima`
from root directory of this repository or run script `bootstrap.sh` from
this directory.

In order to delete the VM run `make teardown-lima` from root directory of this
repository or run script `teardown.sh` from this directory.

Variables can be provided in order to modify default behavior of the scripts,
example:

```bash
IGNITION_FILE=/path/to/directory/config.ign make bootstrap-lima
```
