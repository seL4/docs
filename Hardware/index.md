---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# Supported hardware platforms

### Summary

seL4 is available on 3 major hardware architectures, [ARM](#arm),
[RISC-V](#risc-v) and [x86](#x86), for a number of platforms with varying
hardware features.

seL4 is formally verified for specific configurations for a subset of these
platforms. The depth of the proofs and which properties are verified depend on
the platform.

The tables below provide more details.


### Platforms' attributes

The tables below list the platforms for which seL4 is available. For each
platform, the tables list:

- whether specific features are supported (e.g. *Virtualisation*, *IOMMU/SMMU*, etc) and to which degree (where applicable);
- the *verification status* (see more [below](#verification-status));
- who has contributed this platform port;
- who is maintaining this platform port.

### Verification status

The seL4 proofs only hold for specific configurations, as noted in the *Verification Status* column in the tables, as follows:

* Unverified: this platform is not verified at all and is not scheduled for verification.
* Ongoing: this feature is currently undergoing verification.
* FC: the functional correctness proofs are complete.
* Verified: all proofs for this platform are complete, including functional correctness, integrity and information flow.

More information can be found on the [Verified Configurations](../projects/sel4/verified-configurations.md) page.


### Simulating seL4

Running seL4 in a simulator is a quick way to test it out and iteratively develop software.
Note that feature support is then limited by the simulator.
See [Running It](/seL4Test#RunningIt) for how to run seL4 using Qemu.

You can also [run seL4 on VMware](VMware).


## ARM

seL4 has support for select ARMv7 and ARMv8 Platforms.

* [General info on ARM Platforms](GeneralARM)

| Platform                                      | System-on-chip            | Core             | Arch  | Virtualisation | SMMU              | Verification Status     | Contributed by | Maintained by |
| - | - | - | - | - | - | - | - | - |
{%- assign sorted = site.pages | sort: 'platform' %}
{% for page in sorted %}
{%- if page.arm_hardware -%}
| [{{ page.platform }}]({{page.url}}) | {{ page.soc}} | {{ page.cpu }} | {{ page.arch }} | {{ page.virtualization }} | {{ page.iommu}} | {{ page.Status }} | {{ page.Contrib }} | {{page.Maintained}} |
{% endif %}
{%- endfor %}


## RISC-V

We currently provide support for some of the RISC-V platforms. Support for the hypervisor extension is yet to be mainlined.

| Platform | Simulation | System-on-chip | Core | Arch | Virtualisation | Verification Status | Contributed by | Maintained by |
| -        |  -         | -              | -    | -    | -              | -                   | -              | -             |
{% for page in sorted %}
{%- if page.riscv_hardware -%}
| [{{ page.platform }}]({{page.url}}) | {% if page.simulation_target %}Yes{% else %}No{% endif %} | {{ page.soc }} | {{ page.cpu }} | {{ page.arch }} | {{ page.virtualization }} | {{ page.Status }} | {{ page.Contrib }} | {{ page.Maintained }} |
{% endif %}
{%- endfor %}

## x86

We support PC99-style Intel Architecture Platforms.

| Platform              | Arch | Virtualisation | IOMMU | Verification Status                  | Contributed by | Maintained by |
| -                     |  -   | -              | -     | -                                    | -              | -             |
| [PC99 (32-bit)](IA32) | x86  | VT-X           | VT-D  | Unverified                           | Data61         | seL4 Foundation        |
| [PC99 (64-bit)](IA32) | x64  | VT-X           | VT-D  | [FC (without VT-X, VT-D and fastpath)][X64] | Data61         | seL4 Foundation        |

[X64]: /projects/sel4/verified-configurations.html#x64
