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

| Platform                                      | System-on-chip            | Core             | Arch  | Virtualisation | SMMU              | Verification Status   |
| - | - | - | - | - | - | - |
{%- assign sorted = site.pages | sort: 'platform' %}
{% for page in sorted %}
{%- if page.arm_hardware and page.Maintained != "No" -%}
{%-   if page.verified -%}
{%-    assign link = "/projects/sel4/verified-configurations.html#" | append: page.verified | relative_url -%}
{%-    assign status = "[" | append: page.Status | append: "](" | append: link | append: ")" %}
{%-   else -%}
{%-    assign status = page.Status -%}
{%-   endif -%}
| [{{ page.platform }}]({{page.url| relative_url}}) | {{ page.soc}} | {{ page.cpu }} | {{ page.arch }} | {{ page.virtualization }} | {{ page.iommu}} | {{ status }} |
{% endif %}
{%- endfor %}


## RISC-V

We currently provide support for some of the RISC-V platforms. Support for the hypervisor extension is yet to be mainlined.

| Platform | System-on-chip | Core | Arch | Virtualisation | Verification Status |
| -        |  -             | -    | -    | -              | -                   |
{% for page in sorted %}
{%- if page.riscv_hardware -%}
{%-   if page.verified -%}
{%-    assign link = "/projects/sel4/verified-configurations.html#" | append: page.verified | relative_url -%}
{%-    assign status = "[" | append: page.Status | append: "](" | append: link | append: ")" %}
{%-   else -%}
{%-    assign status = page.Status -%}
{%-   endif -%}
| [{{ page.platform }}]({{page.url | relative_url}}) | {{ page.soc }} | {{ page.cpu }} | {{ page.arch }} | {{ page.virtualization }} | {{ status }} |
{% endif %}
{%- endfor %}

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

---

<div class="prose-p:text-lighter prose-td:text-lighter prose-th:text-light prose-h2:text-lighter prose-a:text-lighter" markdown="1">

## Unmaintained platforms

Unmaintained platforms are platforms for which code has been contributed, but
this code is not or no longer tested and is unlikely to work. We list these
here, because bringing an unmaintained platform up may be faster and easier than
starting from scratch on a new platform port.

| Platform | System-on-chip | Core | Arch | Virtualisation | SMMU |
| - | - | - | - | - | - | - |
{%- assign sorted = site.pages | sort: 'platform'%}
{% for page in sorted %}
{%- if page.arm_hardware and page.Maintained == "No" -%}
| [{{ page.platform }}]({{page.url | relative_url}}) (unmaintained) | {{ page.soc}} | {{ page.cpu }} | {{ page.arch }} | {{ page.virtualization }} | {{ page.iommu}} |
{% endif %}
{%- endfor %}

</div>
