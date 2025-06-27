---
title: seL4 releases
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
Configurations](/projects/sel4/verified-configurations.html).

| Feature                        | Hardware                          | Available From      |
| -                              | -                                 | -                   |
| AARCH64 RPI3                   | [RPI3](/Hardware/Rpi3)            | [10.1.0](seL4_10.1.0) |
| TX2 support (Aarch64 only)     | [TX2](/Hardware/JetsonTX2)        | [10.1.0](seL4_10.1.0) |
| Support for more than 1 VM     | ARM                               | [10.1.0](seL4_10.1.0) |
| 32-bit RISC-V architecture support    | RISC-V (Spike simulation target)  | [10.0.0](seL4_10.0.0) |
| 64-bit RISC-V architecture support    | RISC-V (Spike simulation target)  | [9.0.1](seL4_9.0.1) |
| Meltdown mitigation            | x86                               | [9.0.0](seL4_9.0.0) |
| Spectre mitigation             | x86                               | [9.0.0](seL4_9.0.0) |
| Zynq UltraScale+ MPSoC         | Xilinx ZCU102, ARMv8a, Cortex A53 | [8.0.0](seL4_8.0.0) |
| Multiboot2 support             | x86                               | [8.0.0](seL4_8.0.0) |
| CMake based build system       | all                               | [7.0.0](seL4_7.0.0) |
| ARM 32-bit SMP                 | [Sabre](/Hardware/sabreLite)      | [6.0.0](seL4_6.0.0) |
| ARMv7 32-bit FPU support       | ARM                               | [6.0.0](seL4_6.0.0) |
| ARM 64-bit support             | Aarch64                           | [5.0.0](seL4_5.0.0) |
| 64-bit x86 support             | x86\_64                           | [4.0.0](seL4_4.0.0) |
| Raspberry Pi 3 support         | [RPI3](/Hardware/Rpi3)            | [4.0.0](seL4_4.0.0) |
| ARM Hypervisor initial support | ARM                               | [3.2.0](seL4_3.2.0) |
| First ARMv8 support            | [HiKey](/Hardware/HiKey)          | [3.1.0](seL4_3.1.0) |
| NVIDIA Tegra K1 support        | [TK1](/Hardware/jetsontk1)        | [3.0.1](seL4_3.0.1) |
| Notification binding           | all                               | [2.0.0](seL4_2.0.0) |

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
- [{{ release.title }}]({{ release.url | relative_url }})
([manual](http://sel4.systems/Info/Docs/seL4-manual-{{ release.version }}.pdf)) {% if forloop.first %}(latest){% endif %}
{%   endif %}
{% endfor %}

### Older Mixed Criticality Support (MCS) / Realtime releases

As of seL4 version 11.0.0, the MCS features are included in the main kernel release, via the build option `KernelIsMCS`. Set `KernelIsMCS` to `ON` to switch the scheduler implementation to MCS and enable the MCS API.

{% for release in releases reversed %}
{%   if release.variant == "mcs" %}
- [{{ release.title }}]({{ release.url | relative_url }})
([manual](http://sel4.systems/Info/Docs/seL4-manual-{{ release.version }}.pdf))
{%   endif %}
{% endfor %}
