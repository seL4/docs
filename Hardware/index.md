---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
wide: true
---

# Supported platforms

seL4 is available on 3 major hardware architectures, [Arm](#arm),
[RISC-V](#risc-v) and [x86](#x86), for a number of platforms with varying
hardware features.

The tables below list the platforms for which seL4 is available. For each
platform, the tables list whether specific features are supported (e.g.
*Virtualisation*, *IOMMU/SMMU*, etc) and to which degree (where applicable), as
well as the *verification status* for that platform.

seL4 is formally verified for specific configurations for a subset of these
platforms. The depth of the proofs and which properties are verified depend on
the platform and are noted in the *Verification Status* column as follows:

* Unverified: this platform is not verified at all and is not scheduled for verification.
* Ongoing: this feature is currently undergoing verification.
* FC: the functional correctness proofs are complete.
* Verified: all proofs for this platform are complete, including functional
  correctness, integrity and information flow.

More information can be found on the [Verified Configurations](../projects/sel4/verified-configurations.md) page.

## Arm

seL4 has support for select ARMv7 and ARMv8 Platforms. In addition to the page
with [general instructions how to run seL4 on Arm](GeneralARM.html), each board
page may have additional instructions for running seL4 on it.

<div class="overflow-x-auto">
<table>
  <thead>
    <tr>
      <th>Platform</th>
      <th>System-on-chip</th>
      <th>Core</th>
      <th>Arch</th>
      <th>Virtualisation</th>
      <th>SMMU</th>
      <th>Verification Status</th>
    </tr>
  </thead>
  <tbody>
{%- assign sorted = site.pages | sort: 'platform' %}
{%- for page in sorted %}
{%- if page.arm_hardware and page.Maintained -%}
{%-   if page.verified -%}
{%-    assign link = "/projects/sel4/verified-configurations.html#" | append: page.verified | relative_url -%}
{%-    assign status = '<a href="' | append: link | append: '">' | append: page.Status | append: '</a>' %}
{%-   else -%}
{%-    assign status = page.Status -%}
{%-   endif %}
    <tr>
      <td><a href="{{page.url| relative_url}}">{{ page.platform }}</a></td>
      <td>{{ page.soc}}</td>
      <td>{{ page.cpu }}</td>
      <td>{{ page.arch }}</td>
      <td class="text-center">
{%- if page.virtualization %}
        {% svg _icons/check.svg class="inline-icon stroke-3 text-f_green-500 dark:text-logogreen" %}
{%- else %}
        &ndash;
{%- endif %}
      </td>
      <td class="text-center">
{%- if page.iommu %}
{%-   if page.iommu == "limited" %}
{%-     assign color="text-yellow-500" %}
{%-   else %}
{%-     assign color="text-f_green-500 dark:text-logogreen" %}
{%-   endif %}
        {% svg _icons/check.svg class="inline-icon stroke-3 {{color}}" %}
{%- else %}
        &ndash;
{%- endif %}
      </td>
      <td>{{ status }}</td>
    </tr>
{%- endif %}
{%- endfor %}
  </tbody>
</table>
</div>

## RISC-V

We currently provide support for some of the RISC-V platforms. Support for the hypervisor extension is yet to be mainlined.

<div class="overflow-x-auto">
<table>
  <thead>
    <tr>
      <th>Platform</th>
      <th>System-on-chip</th>
      <th>Core</th>
      <th>Arch</th>
      <!-- th>Virtualisation</th -->
      <th>Verification Status</th>
    </tr>
  </thead>
  <tbody>
{%- for page in sorted %}
{%- if page.riscv_hardware and page.Maintained -%}
{%-   if page.verified -%}
{%-    assign link = "/projects/sel4/verified-configurations.html#" | append: page.verified | relative_url -%}
{%-    assign status = '<a href="' | append: link | append: '">' | append: page.Status | append: '</a>' %}
{%-   else -%}
{%-    assign status = page.Status -%}
{%-   endif %}
    <tr>
      <td><a href="{{page.url| relative_url}}">{{ page.platform }}</a></td>
      <td>{{ page.soc}}</td>
      <td>{{ page.cpu }}</td>
      <td>{{ page.arch }}</td>
      <!-- td class="text-center">
{%- if page.virtualization %}
        {% svg _icons/check.svg class="inline-icon stroke-3 text-f_green-500 dark:text-logogreen" %}
{%- else %}
        &ndash;
{%- endif %}
      </td -->
      <td>{{ status }}</td>
    </tr>
{%- endif %}
{%- endfor %}
  </tbody>
</table>
</div>

## x86

seL4 supports PC99-style Intel Architecture Platforms.

| Platform              | Arch | Virtualisation | IOMMU | Verification Status                  |
| -                     |  -   | -              | -     | -                                    |
| [PC99 (32-bit)](IA32.html) | x86  | VT-X           | VT-D  | Unverified                        |
| [PC99 (64-bit)](IA32.html) | x64  | VT-X           | VT-D  | [FC (without VT-X, VT-D and fastpath)][X64] |

[X64]: {{ '/projects/sel4/verified-configurations.html#x64' | relative_url }}


### Simulating seL4

Running seL4 in a simulator is a quick way to test it out and iteratively
develop software. Note that feature support is then limited by the simulator.
See the QEMU [Arm](qemu-arm-virt.html) and [RISCV](qemu-riscv-virt.html) targets
and the [simulation instructions for sel4test](/projects/sel4test/#running-it)
for x86 for how to run seL4 using QEMU.

### Not in the lists above?

If the platform, architecture, feature that you are after is not listed on this page,
you have several options, listed below. It is important to note however that, as
explained in the guidelines linked below, contributing new ports or features will require
compelling arguments, discussion with the technical community (including through
Request-For-Comments), as well as testing requirements and maintenance/expertise
commitment, to a degree depending on the nature of the contribution.


- You can contact one of the seL4 Foundation [Endorsed Services
  Providers](https://sel4.systems/Foundation/Services/) to get commercial
  support or professional advice to develop such a port or feature (with the
  implications and expectations detailed in our [guidelines for contributing
  kernel code](../projects/sel4/kernel-contribution.html));

- You can check the [roadmap](https://sel4.systems/roadmap.html) for any planned
  contributions, from the seL4 Foundation or larger community, such on any new
  architecture ports, new large formal verifications, or large or fundamental
  new features;

- You can contact the seL4 community through one of our [communication
  channels](https://sel4.systems/contact/) to ask whether someone is developing
  such a port or feature already, or whether there is general interest in discussing
  such a new port or feature;

- If you are in a position to develop the seL4 port or feature yourself, you
  should follow our [guidelines for contributing kernel
  code](../projects/sel4/kernel-contribution.html), which details the
  implications and expectations.
