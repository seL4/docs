---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# VM library API documentation (libsel4vm)

See below for usage documentation on various libsel4vm interfaces. These are not
specific to CAmkES but are mostly used in CAmkES.

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
