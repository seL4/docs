---
redirect_from:
  - /VM/

project: virtualization
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Virtualisation on seL4


## Virtualisation Libraries

Virtualisation support on seL4 is underpinned by two libraries. These being:
* [libsel4vm](/projects/virtualization/libsel4vm): A guest hardware virtualisation library for x86 (ia32) and ARM (ARMv7/w virtualization extensions & ARMv8)
* [libsel4vmmplatsupport](/projects/virtualization/libsel4vmmplatsupport): A library containing various VMM utilities and drivers that can be used to construct a guest VM on a supported platform

These libraries can be utilized to construct VMM servers through providing useful interfaces to create VM(+VCPU) instances, manage *guest* physical address spaces and provide virtual device support (among multiple other things).
Refer to each library to see further documentation regarding their features and APIs.

## Reference VMMs

Multiple projects exist that make use of our virtualisation infrastructure on seL4. These include:

* [x86 and Arm virtualisation](/projects/camkes-vm)
    * [CentOS](/projects/camkes-vm/centos)

