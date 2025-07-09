---
layout: tutorial
nav_prev: mcs.html
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# End of the seL4 Tutorial

## That's all for the seL4 kernel tutorial.

You might want to check out some of the following tutorials as well.

<div class="grid grid-cols-1 lg:grid-cols-2 gap-y-24 gap-x-12 lg:gap-x-20 px-10 pt-8 py-12 sm:py-20 not-prose">
  {% include card.html
     icon="puzzle-piece"
     title="Microkit tutorial"
     body="Tutorial on building static systems on Microkit. Building a simple Wordle server with drivers and a VM."
     link="/projects/microkit/tutorial/welcome.html"
  %}
  {% include card.html
     icon="other/C"
     title="C library tutorials"
     body="Tutorials on the no-assurance C prototyping libraries for seL4. Initialisation, threading, ELF loading."
     link="/Tutorials/libraries-1.html"
  %}
  {% include card.html
     icon="other/rust-logo-blk"
     title="Rust on seL4 tutorial"
     body="Tutorial on running the Rust language on seL4."
     link="/projects/rust/tutorial/introduction.html"
  %}
  {% include card.html
     icon="puzzle-piece"
     title="CAmkES tutorial"
     body="Tutorials for the CAmkES component framework."
     link="/Tutorials/hello-camkes-0.html"
  %}
</div>
