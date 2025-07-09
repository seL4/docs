---
project: rust

redirect_from:
  - /Rust

SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Rust

seL4 officially supports the use of Rust in userspace. This support entails:

- Rust bindings for the seL4 API ([source](https://github.com/seL4/rust-sel4/tree/main/crates/sel4))
- A runtime for root tasks ([source](https://github.com/seL4/rust-sel4/tree/main/crates/sel4-root-task))
- A runtime for [seL4 Microkit](../microkit) protection domains
  ([source](https://github.com/seL4/rust-sel4/tree/main/crates/sel4-microkit))
- Custom `rustc` target specifications for seL4 userspace ([JSON and docs](https://github.com/seL4/rust-sel4/tree/main/support/targets#readme))
- Many more crates for use in seL4 userspace

<div class="grid grid-cols-1 lg:grid-cols-2 gap-y-24 gap-x-12 lg:gap-x-20 px-10 py-8 md:py-12 not-prose">

  {% include card.html
     icon="arrow-right-end-on-rectangle"
     title="Tutorial"
     body="Learn how to use Rust in seL4 userspace."
     link="/projects/rust/tutorial/introduction.html"
  %}

  {% include card.html
     icon="document-magnifying-glass"
     title="API"
     body="Rustdoc for the crates mantained by the seL4 Foundation."
     link="https://sel4.github.io/rust-sel4/"
  %}

  {% include card.html
     icon="document-magnifying-glass"
     title="How to use"
     body="How to use the seL4 rust crates."
     link="/projects/rust/how-to-use.html"
  %}

  {% include card.html
     icon="other/github"
     title="Sources"
     body="Repository for development and collaboration on Rust support in seL4 userspace."
     link="https://github.com/sel4/rust-sel4"
  %}

</div>

The development and maintenance of Rust support for seL4 userspace is funded and
managed by the seL4 Foundation. All of this work happens in one GitHub
repository: [seL4/rust-sel4](https://github.com/sel4/rust-sel4).
