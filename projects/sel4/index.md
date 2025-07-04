---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025 Proofcraft Pty Ltd
---

# The seL4 microkernel

The seL4 kernel itself is the core software program, running in privilege mode,
providing applications with a minimal abstraction layer above the
hardware. Applications can be built directly on top of seL4, or, for an easier
entry point, using frameworks like [Microkit] or [CAmkES].

General information about the [seL4 microkernel][about], including details about
its [formal verification][verification] are found on the [seL4 main
site][sel4.systems], which also contains other sources of learning, such as
[publications], [courses], and a [white paper], as well as an extensive [FAQ].

We welcome contributions to seL4. Please see [how to contribute][contribute].

The seL4 kernel itself is open source and [licensed][license] under the GPL,
version 2. Application code, operating system components, and drivers can have
any license, proprietary or open source. The GPL propagation clause of the
kernel license stops at the kernel/user code boundary.


<div class="grid grid-cols-1 lg:grid-cols-2 gap-y-24 gap-x-12 lg:gap-x-20 px-10 py-8 md:py-12 not-prose">

  {% include card.html
     icon="arrow-right-end-on-rectangle"
     title="Tutorial"
     body="Learn about the base API mechanisms provided by the seL4 kernel
     through short exercises and basic examples."
     link="/Tutorials/setting-up.html"
  %}

  {% include card.html
     icon="book-open"
     title="Manual"
     body="The seL4 kernel reference manual."
     link="/projects/sel4/manual.html"
  %}

  {% include card.html
     icon="document-magnifying-glass"
     title="API"
     body="The C API reference for the seL4 kernel."
     link="/projects/sel4/api-doc.html"
  %}

  {% include card.html
     icon="other/github"
     title="Sources"
     body="The source code of seL4 microkernel."
     link="https://github.com/seL4/seL4"
  %}

  {% include card.html
     icon="cpu-chip"
     title="Supported Platforms"
     body="The table of all hardware and platforms supported by seL4."
     link="/Hardware/"
  %}
  {% include card.html
     icon="check-circle"
     title="Verified Configurations"
     body="Description of the architecture/platform/configuration combinations
     for which seL4 has verified properties."
     link="/projects/sel4/verified-configurations.html"
  %}

</div>


To build the seL4 kernel, please follow the [set up instructions][build].

If you believe you have found a security vulnerability in seL4 or related
software, we ask you to follow our [vulnerability disclosure policy][VDP].



[about]: https://sel4.systems/About/
[verification]: https://sel4.systems/Verification/
[sel4.systems]: https://sel4.systems/

[license]: https://sel4.systems/Legal/license.html

[Microkit]: /projects/microkit/
[CAmkES]: /projects/camkes/

[contribute]: /projects/sel4/kernel-contribution.html

[learn]: https://sel4.systems/Learn/
[white paper]: https://sel4.systems/About/whitepaper.html
[publications]: https://sel4.systems/Research/publications.html
[courses]: https://sel4.systems/Research/courses.html
[FAQ]: https://sel4.systems/About/FAQ.html


[build]: /projects/buildsystem/host-dependencies.html
[VDP]: https://github.com/seL4/seL4/blob/master/SECURITY.md
