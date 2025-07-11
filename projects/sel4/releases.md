---
permalink: /releases/seL4.html
redirect_from:
  - /sel4_release
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# seL4 releases

This page documents tagged releases of the seL4 kernel and proofs.

## Landmark releases

This section documents the version at which specific features were introduced to
seL4. For future features, see the [roadmap](https://sel4.systems/roadmap.html)
on the main seL4 website. For other previous features, see the release notes
below.

For the verification status of all platforms, see [Verified
Configurations](../projects/sel4/verified-configurations.html).

| Feature                        | Hardware                             | Available From             |
| -                              | -                                    | -                          |
| AARCH64 RPI3                   | [RPI3](../Hardware/Rpi3.html)        | [10.1.0](sel4/10.1.0.html) |
| TX2 support (Aarch64 only)     | [TX2](../Hardware/JetsonTX2.html)    | [10.1.0](sel4/10.1.0.html) |
| Support for more than 1 VM     | ARM                                  | [10.1.0](sel4/10.1.0.html) |
| 32-bit RISC-V architecture support | RISC-V (Spike simulation target) | [10.0.0](sel4/10.0.0.html) |
| 64-bit RISC-V architecture support | RISC-V (Spike simulation target) | [9.0.1](sel4/9.0.1.html)   |
| Meltdown mitigation            | x86                                  | [9.0.0](sel4/9.0.0.html)   |
| Spectre mitigation             | x86                                  | [9.0.0](sel4/9.0.0.html)   |
| Zynq UltraScale+ MPSoC         | Xilinx ZCU102, ARMv8a, Cortex A53    | [8.0.0](sel4/8.0.0.html)   |
| Multiboot2 support             | x86                                  | [8.0.0](sel4/8.0.0.html)   |
| CMake based build system       | all                                  | [7.0.0](sel4/7.0.0.html)   |
| ARM 32-bit SMP                 | [Sabre](../Hardware/sabreLite.html)  | [6.0.0](sel4/6.0.0.html)   |
| ARMv7 32-bit FPU support       | ARM                                  | [6.0.0](sel4/6.0.0.html)   |
| ARM 64-bit support             | Aarch64                              | [5.0.0](sel4/5.0.0.html)   |
| 64-bit x86 support             | x86\_64                              | [4.0.0](sel4/4.0.0.html)   |
| Raspberry Pi 3 support         | [RPI3](../Hardware/Rpi3.html)        | [4.0.0](sel4/4.0.0.html)   |
| ARM Hypervisor initial support | ARM                                  | [3.2.0](sel4/3.2.0.html)   |
| First ARMv8 support            | [HiKey](../Hardware/HiKey/)          | [3.1.0](sel4/3.1.0.html)   |
| NVIDIA Tegra K1 support        | [TK1](../Hardware/jetsontk1.html)    | [3.0.1](sel4/3.0.1.html)   |
| Notification binding           | all                                  | [2.0.0](sel4/2.0.0.html)   |

## Main releases

{% assign coll = site['releases'] | where: "project", "sel4" %}
{% comment %}
Sort sorts by string sorting so a version of 2.3.0 is higher than 10.0.0.
Because of this we need to split the list into two before sorting.
{% endcomment %}
{% assign releases_1 = coll | where_exp:"item", "item.version_digits != 2" | sort: "version"  %}
{% assign releases_2 = coll | where_exp:"item", "item.version_digits == 2" | sort: "version" %}
{% assign releases =  releases_1 | concat: releases_2 %}

{% for release in releases reversed %}
{%   if release.variant != "mcs" %}
- seL4 Release [{{ release.title }}]({{ release.url | relative_url }}),
  with [PDF manual](http://sel4.systems/Info/Docs/seL4-manual-{{ release.version }}.pdf) {% if forloop.first %}(latest){% endif %}
{%   endif %}
{% endfor %}

### Older Mixed Criticality Support (MCS) / Realtime releases

As of seL4 version 11.0.0, the MCS features are included in the main kernel release, via the build option `KernelIsMCS`. Set `KernelIsMCS` to `ON` to switch the scheduler implementation to MCS and enable the MCS API.

{% for release in releases reversed %}
{%   if release.variant == "mcs" %}
- seL4 Release [{{ release.title }}]({{ release.url | relative_url }}),
  corresponding [PDF manual](http://sel4.systems/Info/Docs/seL4-manual-{{ release.version }}.pdf)
{%   endif %}
{% endfor %}
