---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Getting Started

## Building Systems on seL4

The quickest and easiest way to get started with building a system on top of
seL4 is the seL4 Microkit. We recommend to:

- start with the [tutorial](projects/microkit/tutorial/welcome.html),
- check out the Microkit examples on the [examples page],
- look at the [manual](projects/microkit/manual/latest/) to get a full overview, and
- check the [supported platforms](projects/microkit/platforms.html)
  to see what hardware you can run on.

The Microkit is for systems with a statically described software architecture.
For dynamic systems, you may want to work on the seL4 API directly (see
below), or use one of the [tools &amp; frameworks][frameworks] that the seL4
ecosystem has to offer.

[frameworks]: https://sel4.systems/tools.html
[examples page]: examples.html
[seL4 white paper]: https://sel4.systems/About/whitepaper.html
[seL4 manual]: projects/sel4/manual.html
[API reference]: projects/sel4/api-doc.html

## Learning about seL4

If you are planning to write a dynamic system or you want to learn about seL4
itself, we recommend to:

- check out the [seL4 white paper] for a high-level overview,
- start learning the API with the [seL4 tutorials](Tutorials/setting-up.html),
- look at the [seL4 manual] and [API reference],
- browse the seL4 [examples page] for what is available, and
- check the [supported platforms](Hardware/) to see what hardware you can run on.

If you are looking for deeper background reading material, you might be
interested in the selection of [research publications on seL4][publications] on
the main website.

## Writing Rust on seL4

The Rust programming language is a great fit for writing applications on top of
seL4. Check out:

- the [Rust support for seL4](projects/rust/), and
- examples tagged with Rust on the seL4 [examples page].

## Build instructions and tests

If you just want instructions for building and running the seL4 kernel, check
the page on [setting up your
machine](projects/buildsystem/host-dependencies.html).

## The proofs

seL4's claim to fame is that it is formally verified. These formal proofs are
available in the [l4v](https://github.com/seL4/l4v/) repository with their own
setup and build instructions. See the [verification pages] on the main website
for an overview of the proofs, and check the [Verified
Configurations](projects/sel4/verified-configurations.html) to know which
architecture/platform/configuration combinations of seL4 have verified
properties.



[verification pages]: https://sel4.systems/Verification/

## Help and Support

Check out the navigation on the left for the main content of this documentation
site.

If you have questions, you can head to the [New to seL4][new] section on seL4
discourse or the general seL4 community [help and support][support] channels.

[new]: https://sel4.discourse.group/c/new-to-sel4/
[support]: https://sel4.systems/support.html
[publications]: https://sel4.systems/Research/publications.html
