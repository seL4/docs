---
project: camkes-vm
title: "camkes-3.8.x-compatible-arm-old"
archive: true
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# Updates to camkes-arm-vm from camkes-3.7.x to camkes-3.8.0

- `VM`: Load kernel and dtb images using `FileServer`.
  This now uses the same mechanism as the x86 `Init` VM component.
- `VM`: Add basic module abstraction.  This allows compilation units
  to declare modules that the vmm will
  initialise without having to directly call the init function. This
  should reduce the amount of `#ifdefs` throughout the code.
- `VM`: Create `map_frame_hack` module.
  This is a hack that was used in the `SMACCM` demo for giving the VM direct
  memory access to a crypto component.
- `VM`: Create `device_fwd` module for tk1.
- `VM`: Create `vchan` module. This moves the vchan source into its own module.
- `VM`: Move remaining `vmlinux.c` code to per-platform init modules.
- Add initial aarch64 support.
- Add initial TX1 support.
- Rename `tk1_vm` to `vm_minimal` as this app supports more than one platform.
- `vm_minimal`: Added Exynos5422 support.
- `VM`: Perform `map_unity_ram` on Exynos5422.  This allows for
  a one-to-one PA<->IPA mapping of the guest RAM device on the exynos5422.
- Remove duplicate frames from `vm_odroid.camkes`.
  The new CapDL allocator will not permit separate objects with the same
  physical address. This change makes the `vm_odroid` share its hardware MMIO objects
  without duplicating them.
- `VM`: Install `vpci` device. Added call to the `sel4arm-vmm` in order to install the virtual
  pci device in the guest VM.
- `VM`: Added `virtio_net` module.
  This introduces the `virtio_net` module. This initializes and
  manages the virtio net driver in the guest VM. The module
  is a basic demonstration that responds to ARP request packets.
  This is refactored out of the x86 VMM (`camkes-vm`).
- `VM`: Support for loading `initrd` vm module.
  Attempts to load an `initrd` module if provided in the CPIO archive.
  This is loaded in the kernel lowmem alongside the dtb.
- `vm_minimal`: Added rootfs to archive for exynos5422.
  Updated the `vm_minimal` `CMakeLists.txt` to pass the linux-initrd file
  to the file server. This change pertains to the exynos5422
  platform.
- `vm_virtio_net`: New virtio_net application.
  Added `vm_viritio_net` application. This is currently target to
  the exynos5422 platform. The application demonstrates the use
  user level linux overlays, adding an arping test and network
  interface file to test virtio net functionality in the vm.
- Add griddle support:
  - Migrate `RELEASE` and `CAMKES_VM_APP` to `easy-settings.cmake`.
  - Give `CAMKES_VM_APP` a default of `vm_minimal`.
  - Add `PLATFORM` to `easy-settings.cmake` as well; default `tx1`.
- `VM`: Added TX2 Support.
- `VM`: Added GlobalAsynch notification to the VM.
  Added support for a global async notification within the VM
  component. This supports additional components in the system to
  send notifications to the VM.
- `VM`: Added Virtio Net `virtqueue` module.
  Added a new VM module that forwards and recieves packets through
  virtqueues. This allows packets to be forwarded to another
  component in the system and in addition for the connected component
  to send messages to the VM.
- `vm_virtio_net`: Added ping echo response client.
  Added an example camkes application that uses the VM's virtio
  net support to recieve and reply to arping and [icmp] ping
  packets sent by the connect guest VM. This is performed over
  virtqueues.
- `serial-server-app`: added console support libvirtio.
  Added console support to libvirtio library.
  This copys the same setup as net where we install
  a vpci device. Uses linux hvc0 device to communicate with
  the camkes serial server through the vm.
- `virtio-con`: Add module for virtual console.
- `VM`: Added CPP Macro configuration helpers.
  Added a set of CPP macro helpers that can be used to configure
  a camkes arm vm application. These can be used in substitute of
  the vm_common.camkes file.
- `VM`: Memory and image settings as camkes attributes.
  Refactored the definitions of the linux guest attributes (e.g. ram
  base, size, image names) into camkes attributes. This makes the
  VM component more configurable, removing the need to have to hard
  code values into the source. Updated the vm apps and component
  source to reflect these changes.
- `VM`: Update common sources for new IRQ server changes in libsel4utils.
- Remove Configuration library and append `#include <<lib_name>/gen_config.h>` after each
    `#include <autoconf.h>` since `autoconf.h` is only for the kernel and libsel4 config now.
- templates: Added new template `seL4VMDTBPassthrough`.
  Added a new template/interface that can be used in a camkes
  arm vm app. `seL4VMDTBPassthrough` allows users to define a series
  of dtb nodes that will in turn be converted into a series of
  untyped memory and irq objects. This can then be used for passing
  the devices through to the guest vm. This is an alternative
  interface that can be used as opposed to specifying two
  independent lists of untypes and irqs.
- `VM`: Component support for the `seL4VMDTBPassthrough`.
  Added support for the `seL4VMDTBPassthrough` template in the VM
  component. This in particular will add the untypes presented by
  the passthrough template and updating the camkes simple interface
  to account for the dtb irq caps.
- `vm_minimal`, `vm_serial`, `vm_virtio_net`, `odroid_vm`: Updated to use `seL4VMDTBPassthrough`.
  Updated the device configurations to the use `seL4VMDTBPassthrough`.
  This converts the untyped and irq arrays into a single dtb query
  array.
- Update `ping_client` to use the new virtqueue lib.
  Introduces the necessary changes for the ping client to use the new
  libvirtqueue with multi-entry rings and scatter buffer logic.
- Added support for the QEMU virt platform, starting a linux VM with buildroot.



