---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# VM library (libsel4vm)

A guest hardware virtualisation library for IA32 and ARM (AArch32 &
AArch64) for use on seL4-based systems. The library as such is not specific to
CAmkES,  but the main users of this library are the [CAmkES VMs] on x86 and Arm.

This is a consolidated library composed of the now deprecated libraries
`libsel4vmm` (x86) and `libsel4arm-vmm` (Arm).

Sources: <https://github.com/seL4/seL4_projects_libs/blob/master/libsel4vm/>

[CAmkES VMs]: {{ '/projects/camkes-vm/' | relative_url }}

## Features

The library supports IRQ Controller emulation (GICv2 on AArch32 and AArch64, and
PIC & LAPIC on IA32), guest VM memory management, guest VCPU fault and context
management, as well as VM runtime management.

The Arm library has SMP support for GICv2 platforms, the IA32 library provides
an IOPort fault registration handler and a VMCall handler registration interface.

## API documentation

See below for usage documentation on `libsel4vm`.

### Common Interfaces

* [sel4vm/boot.h](api/libsel4vm_boot.html): An interface for creating, initialising
  and configuring VM instances
* [sel4vm/guest_irq_controller.h](api/libsel4vm_guest_irq_controller.html):
  Abstractions around initialising a guest VM IRQ controller
* [sel4vm/guest_memory_helpers.h](api/libsel4vm_guest_memory_helpers.html): Helpers
  for using the guest memory interface
* [sel4vm/guest_vcpu_fault.h](api/libsel4vm_guest_vcpu_fault.html): Useful methods to
  query and configure vcpu objects that have faulted during execution
* [sel4vm/guest_vm.h](api/libsel4vm_guest_vm.html): Provides base definitions of the
  guest vm datastructure and primitives to run the VM instance
* [sel4vm/guest_iospace.h](api/libsel4vm_guest_iospace.html):  Enables the
  registration and management of a guest VM's IO Space
* [sel4vm/guest_memory.h](api/libsel4vm_guest_memory.html): Useful abstractions to
  manage your guest VM's physical address space
* [sel4vm/guest_ram.h](api/libsel4vm_guest_ram.html): A set of methods to manage,
  register, allocate and copy to/from a guest VM's RAM
* [sel4vm/guest_vm_util.h](api/libsel4vm_guest_vm_util.html): A set of utilties to
  query a guest vm instance

### Architecture Specific Interfaces

#### ARM

* [sel4vm/arch/guest_arm_context.h](api/libsel4vm_guest_arm_context.html): Provides a
  set of useful getters and setters on ARM vcpu thread contexts
* [sel4vm/arch/guest_vm_arch.h](api/libsel4vm_arm_guest_vm.html): Provide definitions
  of the arm guest vm datastructures and primitives to configure the VM instance

#### X86

* [sel4vm/arch/guest_x86_context.h](api/libsel4vm_guest_x86_context.html): Provides a
  set of useful getters and setters on x86 vcpu thread contexts
* [sel4vm/arch/guest_vm_arch.h](api/libsel4vm_x86_guest_vm.html): Provide definitions
  of the x86 guest vm datastructures and primitives to configure the VM instance
* [sel4vm/arch/vmcall.h](api/libsel4vm_x86_vmcall.html): Methods for registering and
  managing vmcall instruction handlers
* [sel4vm/arch/ioports.h](api/libsel4vm_x86_ioports.html): Abstractions for
  initialising, registering and handling ioport events
