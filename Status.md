---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# Status of new and future seL4 features and projects


This page tracks the status of various seL4 platform features that are
in progress or not yet started (i.e. planned).

For status of existing kernel ports, features, drivers, and other userland components, see:

- [Hardware](Hardware): for hardware platform ports
- Kernel Features: for kernel features
- [Userland Components and Drivers](/UserlandComponents): for device driver and
        userland components

## Kernel Features and hardware platform ports


|Feature|Status|Driven by|Repo|Comment|
|-|-|-|-|-|
| MCS kernel | in development | [D61](mailto:devel@sel4.systems)| {{site.sel4_mcs}} | Rebased onto master at each release, but the development branch is not public. Being developed for all architectures and most supported platforms. |
| AArch64 hyp | in development (unreleased) | [D61](mailto:devel@sel4.systems)| | being developed on NVIDIA TX1, HiKey |
| AArch64 SMP | planned | [D61](mailto:devel@sel4.systems)| | to be developed on NVIDIA TX1, HiKey |
| NVIDIA TX1 SMMU | planned | [D61](mailto:devel@sel4.systems)| | AArch32 and AArch64 |
| RISC-V | planned | [D61](mailto:devel@sel4.systems)| | |

## CAmkES Features


|Feature|Status|Driven by|Repo|Comment|
|-|-|-|-|-|
| CAmkES AArch64 | planned | [D61](mailto:devel@sel4.systems)| | |
| CAmkES AArch64 & hyp | planned | [D61](mailto:devel@sel4.systems)| | |

## Virtualisation


|Feature|Status|Driven by|Repo|Comment|
|-|-|-|-|-|
| camkes-arm-vmm for AArch64 | planned |[D61](mailto:devel@sel4.systems)| | Including libsel4arm-vmm for AArch64 |
| camkes-arm-vmm for NVIDIA TX1 | planned |[D61](mailto:devel@sel4.systems)| | Including Linux running in a VM |
| multiple ARM VMs | planned| | | be able to run multiple VMMs, one VM per VMM. AArch32? AArch64?|
