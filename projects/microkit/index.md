---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# The seL4 Microkit

The seL4 Microkit is an operating system framework on top of seL4. It provides a
small set of simple abstractions that ease the design and implementation of
statically structured systems on seL4, leveraging the kernel’s benefits of
security and performance.

The Microkit is distributed as an SDK that integrates with the build system of
your choice, significantly reducing the barrier to entry for new users of seL4.

<div class="grid grid-cols-1 md:grid-cols-2 gap-y-24 gap-x-12 md:gap-x-20 px-10 py-8 md:py-12 not-prose">

  {% include card.html
     icon="arrow-right-end-on-rectangle"
     title="Tutorial"
     body="Learn how to use Microkit and its concepts to make a system."
     link="/projects/microkit/tutorial/welcome.html"
  %}

  {% include card.html
     icon="book-open"
     title="Manual"
     body="User's manual for the Microkit SDK."
     link="/projects/microkit/manual/latest/"
  %}

  {% include card.html
     icon="arrow-down-tray"
     title="Releases"
     body="SDK downloads and release notes."
     link="/releases/microkit.html"
  %}

  {% include card.html
     icon="other/github"
     title="Sources"
     body="If you are planning to make contributions to the Microkit, this is
           where to start."
     link="https://github.com/seL4/microkit/"
  %}

</div>


The seL4 Microkit is part of the repositories managed by the seL4 Foundation. It
is currently mainly maintained and developed by the Trustworthy Systems research
group at UNSW. See also the [Microkit project page] there.


[Microkit project page]: https://trustworthy.systems/projects/microkit
