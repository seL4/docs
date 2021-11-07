---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# Supported Platforms

## Verification status

The seL4 proofs are only for specific platforms, as noted in the tables for x86 and ARM below, in
the *Status* column, as follows:

* Unverified: this platform is not verfied at all and is not scheduled for verification.
* Pending: this feature is currently undergoing verification.
* FC: the functional correctness proofs are complete.
* FCI: the integrity proofs are complete, in addition to functional correctness.
* Verified: all proofs for this platform are complete, including functional correctness, integrity and infoflow.

## Simulating seL4

Running seL4 in a simulator is a quick way to test it out and iteratively develop software. However,
note that feature support is limited by the simulator.

See [Running It](/seL4Test#RunningIt) for how to run seL4 using Qemu.

* [Running seL4 on VMware](VMware)

## x86

We support PC99-style Intel Architecture Platforms.

| Platform              | Arch | Virtualisation | IOMMU | Status                               | Contributed by | Maintained by |
| -                     |  -   | -              | -     | -                                    | -              | -             |
| [PC99 (32-bit)](IA32) | x86  | VT-X           | VT-D  | Unverified                           | Data61         | seL4 Foundation        |
| [PC99 (64-bit)](IA32) | x64  | VT-X           | VT-D  | FC (without VT-X, VT-D and fastpath) | Data61         | seL4 Foundation        |

## ARM

seL4 has support for select ARMv6, ARMv7 and ARMv8 Platforms.

* [General info on ARM Platforms](GeneralARM)

| Platform                                      | System-on-chip            | Core             | Arch  | Virtualisation | IOMMU              | Status     | Contributed by | Maintained by |
| - | - | - | - | - | - | - | - | - |
{%- assign sorted = site.pages | sort: 'arch' %}
{% for page in sorted %}
{%- if page.arm_hardware -%}
| [{{ page.platform }}]({{page.url}}) | {{ page.soc}} | {{ page.cpu }} | {{ page.arch }} | {{ page.virtualization }} | {{ page.iommu}} | {{ page.Status }} | {{ page.Contrib }} | {{page.Maintained}} |
{% endif %}
{%- endfor %}


## RISC-V

We currently provide support for some of the RISC-V platforms. Multicore, floating point unit (FPU) and hypervisor extension support are under internal review, will be released soon.

| Platform | Simulation | System-on-chip | Core | Arch | Virtualisation | Status | Contributed by | Maintained by |
{% for page in sorted %}
{%- if page.riscv_hardware -%}
| [{{ page.platform }}]({{page.url}}) | {% if page.simulation_target %}Yes{% else %}No{% endif %} | {{ page.soc }} | {{ page.cpu }} | {{ page.arch }} | {{ page.virtualization }} | {{ page.Status }} | {{ page.Contrib }} | {{ page.Maintained }} |
{% endif %}
{%- endfor %}
