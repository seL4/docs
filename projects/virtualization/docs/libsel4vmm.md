---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# VMM library (libsel4vmmplatsupport)

A library containing various VMM utilities and drivers that can be used to
construct a Guest VM on a supported platform. This library makes use of
‘libsel4vm’ to implement VMM support. The main reference implementations using
this library are the [CAmkES VMs] on Arm and IA32. The sources are [available on
GitHub][sources].

<!-- inline source link, because it's too long -->
[sources]: https://github.com/seL4/seL4_projects_libs/blob/master/libsel4vmmplatsupport/README.md
[CAmkES VMs]: {{ '/projects/camkes-vm/' | relative_url }}
[libsel4vm]: {{ '/projects/virtualization/docs/libsel4vm.html' | relative_url }}

## Main features

The library contains Virtio support and Virtio drivers for PCI, Console, and
Net. It provides a cross-VM connection/communication driver, guest image loading
utilities (e.g. kernel, initramfs), [libsel4vm] memory helpers and utilities,
and an IOPorts management interface.

On Arm, it further provides a VCPU fault handler module with HSR/Exception & SMC
decoding and dispatching, PSCI handlers through a VCPU fault (+SMC handler)
interface, guest reboot utilities, and guest OS boot interfaces for Linux VMs.
It defines generic virtual device interfaces for generic access controlled
devices (read/write privileges), and for generic forwarding devices via
dispatching faults to external handlers. It also provides a virtual USB driver.

On IA32, the library supports ACPI table generation, PCI device passthrough
helpers, and guest OS Boot interfaces for Linux VMs that provide boot VCPU
initialisation, BIOS boot info structure generation, E820 map generation, and
VESA initialisation.

## API documentation

See below for usage documentation on `libsel4vmmplatsupport` interfaces.

### Common Interfaces

* [sel4vmmplatsupport/device.h](api/libsel4vmmplatsupport_device): Provides a
  series of datastructures and helpers to manage VMM devices.
* [sel4vmmplatsupport/device_utils.h](api/libsel4vmmplatsupport_device_utils):
  Provides various helpers to establish different types devices for a given VM
  instance
* [sel4vmmplatsupport/guest_image.h](api/libsel4vmmplatsupport_guest_image):
  Provides general utilites to load guest vm images (e.g. kernel, initrd,
  modules)
* [sel4vmmplatsupport/guest_memory_util.h](api/libsel4vmmplatsupport_guest_memory_util):
  Provides various utilities and helpers for using the libsel4vm guest memory
  interface
* [sel4vmmplatsupport/guest_vcpu_util.h](api/libsel4vmmplatsupport_guest_vcpu_util):
  Provides abstractions and helpers for managing libsel4vm vcpus
* [sel4vmmplatsupport/ioports.h](api/libsel4vmmplatsupport_ioports): Useful
  abstraction for initialising, registering and handling ioport events for a
  guest VM instance
* [sel4vmmplatsupport/drivers/cross_vm_connection.h](api/libsel4vmmplatsupport_cross_vm_connection):
  Facilitates the creation of communication channels between VM's and other
  components on an seL4-based system
* [sel4vmmplatsupport/drivers/pci.h](api/libsel4vmmplatsupport_pci): Interface
  presents a VMM PCI Driver, which manages the host's PCI devices, and handles
  guest OS PCI config space read & writes
* [sel4vmmplatsupport/drivers/pci_helper.h](api/libsel4vmmplatsupport_pci_helper):
  This interface presents a series of helpers when using the VMM PCI Driver
* [sel4vmmplatsupport/drivers/virtio_con.h](api/libsel4vmmplatsupport_virtio_con):
  This interface provides the ability to initalise a VMM virtio console driver
* [sel4vmmplatsupport/drivers/virtio_net.h](api/libsel4vmmplatsupport_virtio_net):
  This interface provides the ability to initalise a VMM virtio net driver

### Architecture Specific Interfaces

#### Arm

* [sel4vmmplatsupport/arch/generic_forward_device.h](api/libsel4vmmplatsupport_arm_generic_forward_device):
  This interface facilitates the creation of a virtual device used for
  dispatching faults to external handlers
* [sel4vmmplatsupport/arch/guest_boot_init.h](api/libsel4vmmplatsupport_arm_guest_boot_init):
  Provides helpers to initialise the booting state of a VM instance
* [sel4vmmplatsupport/arch/guest_reboot,h](api/libsel4vmmplatsupport_arm_guest_reboot):
  Provides a series of helpers for registering callbacks when rebooting the VMM
* [sel4vmmplatsupport/arch/guest_vcpu_fault.h](api/libsel4vmmplatsupport_arm_guest_vcpu_fault):
  Provides a module for registering and processing ARM vcpu faults
* [sel4vmmplatsupport/arch/guest_vcpu_util.h](api/libsel4vmmplatsupport_arm_guest_vcpu_util):
  Provides abstractions and helpers for managing libsel4vm vcpus on an ARM
  platform
* [sel4vmmplatsupport/arch/vpci.h](api/libsel4vmmplatsupport_arm_vpci): Presents
  a Virtual PCI driver for ARM-based VM's
* [sel4vmmplatsupport/arch/vusb.h](api/libsel4vmmplatsupport_arm_vusb): Presents
  a Virtual USB driver for ARM-based VM's
* [sel4vmmplatsupport/arch/ac_device.h](api/libsel4vmmplatsupport_arm_ac_device):
  Facilitates the creation of generic virtual devices in a VM instance with
  access control permissions over the devices addressable memory

#### x86

* [sel4vmmplatsupport/arch/acpi.h](api/libsel4vmmplatsupport_x86_acpi): Provides
  support for generating ACPI table in a guest x86 VM
* [sel4vmmplatsupport/arch/guest_boot_init.h](api/libsel4vmmplatsupport_x86_guest_boot_init):
  Provides helpers to initialise the booting state of a VM instance
* [sel4vmmplatsupport/arch/drivers/vmm_pci_helper.h](api/libsel4vmmplatsupport_x86_vmm_pci_helper):
  Interface presents a series of helpers for establishing VMM PCI support on x86
  platforms
