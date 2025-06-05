---
title: libsel4vm & libsel4vmmplatsupport API documentation
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# libsel4vm API

See below for usage documentation on various libsel4vm interfaces:

### Common Interfaces
* [sel4vm/boot.h](api/libsel4vm_boot): An interface for creating, initialising and configuring VM instances
* [sel4vm/guest_irq_controller.h](api/libsel4vm_guest_irq_controller): Abstractions around initialising a guest VM IRQ controller
* [sel4vm/guest_memory_helpers.h](api/libsel4vm_guest_memory_helpers): Helpers for using the guest memory interface
* [sel4vm/guest_vcpu_fault.h](api/libsel4vm_guest_vcpu_fault): Useful methods to query and configure vcpu objects that have faulted during execution
* [sel4vm/guest_vm.h](api/libsel4vm_guest_vm): Provides base definitions of the guest vm datastructure and primitives to run the VM instance
* [sel4vm/guest_iospace.h](api/libsel4vm_guest_iospace):  Enables the registration and management of a guest VM's IO Space
* [sel4vm/guest_memory.h](api/libsel4vm_guest_memory): Useful abstractions to manage your guest VM's physical address space
* [sel4vm/guest_ram.h](api/libsel4vm_guest_ram): A set of methods to manage, register, allocate and copy to/from a guest VM's RAM
* [sel4vm/guest_vm_util.h](api/libsel4vm_guest_vm_util): A set of utilties to query a guest vm instance

### Architecture Specific Interfaces

#### ARM
* [sel4vm/arch/guest_arm_context.h](api/libsel4vm_guest_arm_context): Provides a set of useful getters and setters on ARM vcpu thread contexts
* [sel4vm/arch/guest_vm_arch.h](api/libsel4vm_arm_guest_vm): Provide definitions of the arm guest vm datastructures and primitives to configure the VM instance

#### X86
* [sel4vm/arch/guest_x86_context.h](api/libsel4vm_guest_x86_context): Provides a set of useful getters and setters on x86 vcpu thread contexts
* [sel4vm/arch/guest_vm_arch.h](api/libsel4vm_x86_guest_vm): Provide definitions of the x86 guest vm datastructures and primitives to configure the VM instance
* [sel4vm/arch/vmcall.h](api/libsel4vm_x86_vmcall): Methods for registering and managing vmcall instruction handlers
* [sel4vm/arch/ioports.h](api/libsel4vm_x86_ioports): Abstractions for initialising, registering and handling ioport events

# libsel4vmmplatsupport API

See below for usage documentation on various libsel4vmmplatsupport interfaces:

### Common Interfaces
* [sel4vmmplatsupport/device.h](api/libsel4vmmplatsupport_device): Provides a series of datastructures and helpers to manage VMM devices.
* [sel4vmmplatsupport/device_utils.h](api/libsel4vmmplatsupport_device_utils): Provides various helpers to establish different types devices for a given VM instance
* [sel4vmmplatsupport/guest_image.h](api/libsel4vmmplatsupport_guest_image): Provides general utilites to load guest vm images (e.g. kernel, initrd, modules)
* [sel4vmmplatsupport/guest_memory_util.h](api/libsel4vmmplatsupport_guest_memory_util): Provides various utilities and helpers for using the libsel4vm guest memory interface
* [sel4vmmplatsupport/guest_vcpu_util.h](api/libsel4vmmplatsupport_guest_vcpu_util): Provides abstractions and helpers for managing libsel4vm vcpus
* [sel4vmmplatsupport/ioports.h](api/libsel4vmmplatsupport_ioports): Useful abstraction for initialising, registering and handling ioport events for a guest VM instance
* [sel4vmmplatsupport/drivers/cross_vm_connection.h](api/libsel4vmmplatsupport_cross_vm_connection): Facilitates the creation of communication channels between VM's and other components on an seL4-based system
* [sel4vmmplatsupport/drivers/pci.h](api/libsel4vmmplatsupport_pci): Interface presents a VMM PCI Driver, which manages the host's PCI devices, and handles guest OS PCI config space read & writes
* [sel4vmmplatsupport/drivers/pci_helper.h](api/libsel4vmmplatsupport_pci_helper): This interface presents a series of helpers when using the VMM PCI Driver
* [sel4vmmplatsupport/drivers/virtio_con.h](api/libsel4vmmplatsupport_virtio_con): This interface provides the ability to initalise a VMM virtio console driver
* [sel4vmmplatsupport/drivers/virtio_net.h](api/libsel4vmmplatsupport_virtio_net): This interface provides the ability to initalise a VMM virtio net driver

### Architecture Specific Interfaces

#### ARM
* [sel4vmmplatsupport/arch/generic_forward_device.h](api/libsel4vmmplatsupport_arm_generic_forward_device): This interface facilitates the creation of a virtual device used for dispatching faults to external handlers
* [sel4vmmplatsupport/arch/guest_boot_init.h](api/libsel4vmmplatsupport_arm_guest_boot_init): Provides helpers to initialise the booting state of a VM instance
* [sel4vmmplatsupport/arch/guest_reboot,h](api/libsel4vmmplatsupport_arm_guest_reboot): Provides a series of helpers for registering callbacks when rebooting the VMM
* [sel4vmmplatsupport/arch/guest_vcpu_fault.h](api/libsel4vmmplatsupport_arm_guest_vcpu_fault): Provides a module for registering and processing ARM vcpu faults
* [sel4vmmplatsupport/arch/guest_vcpu_util.h](api/libsel4vmmplatsupport_arm_guest_vcpu_util): Provides abstractions and helpers for managing libsel4vm vcpus on an ARM platform
* [sel4vmmplatsupport/arch/vpci.h](api/libsel4vmmplatsupport_arm_vpci): Presents a Virtual PCI driver for ARM-based VM's
* [sel4vmmplatsupport/arch/vusb.h](api/libsel4vmmplatsupport_arm_vusb): Presents a Virtual USB driver for ARM-based VM's
* [sel4vmmplatsupport/arch/ac_device.h](api/libsel4vmmplatsupport_arm_ac_device): Facilitates the creation of generic virtual devices in a VM instance with access control permissions over the devices addressable memory

#### X86
* [sel4vmmplatsupport/arch/acpi.h](api/libsel4vmmplatsupport_x86_acpi): Provides support for generating ACPI table in a guest x86 VM
* [sel4vmmplatsupport/arch/guest_boot_init.h](api/libsel4vmmplatsupport_x86_guest_boot_init): Provides helpers to initialise the booting state of a VM instance
* [sel4vmmplatsupport/arch/drivers/vmm_pci_helper.h](api/libsel4vmmplatsupport_x86_vmm_pci_helper): Interface presents a series of helpers for establishing VMM PCI support on x86 platforms
