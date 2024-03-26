---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Contributing to kernel code

If the platform, architecture, feature that you are after is not listed on the
[Supported Platforms page](/Hardware/), and if, from your available
[options](/Hardware/index.html#not-in-the-lists-below), you choose to contribute
the port or feature yourself, here are the guidelines for it.

There four classes of kernel contributions possible:

1. Board Support Package (BSP) ports, also known as platform ports.
2. Architecture features
3. Architecture ports
4. Kernel features

For any kernel contributions it is important to note that a modified kernel
will *not* be considered formally verified (and therefore will not fully
benefit from the seL4 proofs), until the proofs themselves are also
appropriately modified, or it can be shown that the modifications do not
affect the proofs.

## Platform/BSP ports

*Platform ports*, also known as *Board Support Package (BSP) ports* are the
simplest, and require the least modifications, discussion and approval.  This
assumes that you are porting the kernel to a new board on an existing
architecture.

The main thing is to:

* follow the [platform porting guide](/projects/sel4/porting);
* follow the guidelines to [become a platform owner](/projects/sel4/platf-owner.html).

Questions, discussion, and sharing of work in progress during this stage are
welcome.

If you run into problems please ask questions - many of us may have run into
the same problems before and can provide information on how to fix them (and
save hours to weeks of frustration).  Please us one of our
[communication channels](https://sel4.systems/contact/) for this.

Make sure to write appropriate tests and include them in seL4test as
part of the port.  Consider (and discuss) a plan for how to support
this port (e.g. with regression testing) so that it continues to be
updated and work as seL4 evolves.

Once the code is ready for submission follow the
[Contribution Guidelines](/processes/contributing.html) to submit the changes.

## Architecture features

In some cases a kernel port requires more than just a platform/BSP port.  If the port is
on a supported architecture, but you wish to make use of architecture features
that the kernel does not yet support, then these will be *architecture feature
contributions*.  This will typically require moderate modifications to kernel
design and implementation.

We do not have general (nor specific) guidelines or how-tos for adding
architecture features.  Each such feature is different and the design
decisions and implementations will also vary.

Before starting on design and implementation of architecture features please
start an initial discussion on one of our [communication channels](https://sel4.systems/contact/)
to check if such a feature is not already being worked on, if it is considered
appropriate to include in the kernel, etc.

Then start a [Request For Comment (RFC)](/processes/rfc-process)
describing your design and plans, and engage in discussion with others
about this.  The goal is to get feedback into specific design
decisions, as well as to get agreement on the general direction and
design (considering the fit with the overall philosophy and
architecture of the kernel, performance impacts, verification impacts,
etc).

Once there is agreement on how to design and implement such a feature,
then the next step is to implement it.  Discussion, revisions of
design, and sharing of code (intermediate, proof of concept, prototype,
etc) during this stage is encouraged.

Evaluate any performance and security impacts of the implementation, and if
there are significant impacts, discuss these and consider how to redesign or
re-implement to avoid them.

If the feature implementation affects the proofs in any way, then the
modifications will also have to be evaluated and approved by proof
engineers to ensure that the existing proofs are not invalidated.
Note that this is even the case if the architecture feature
implementation itself is not verified - it is still likely to touch
code that does affect the verified part of the kernel.

Consider whether you want to have the architecture feature
implementation verified, and the plans for achieving that.

As with a platform/BSP port make sure to write appropriate tests and include
them in seL4test as part of the work.  Consider (and discuss) a plan
for how to support this port (e.g. with regression testing) so that it
continues to be updated and work as seL4 evolves.

Once the implementation is complete follow the [Contribution
Guidelines](processes/contributing.html) for submitting changes.

## Architecture Ports

If you wish to port seL4 to a new hardware architecture that seL4 does not yet
support, then this will be a new *architecture port*.  This will require
extensive kernel design and implementation modifications.

We feel that seL4 currently supports the most important hardware architectures
(ARM, x86, RISC-V), however, there may be reasons to port to other (new or
existing) architectures.

Some architectures will be similar enough to currently supported
architectures that a port will be relatively straight forward.
However, other architectures may be radically different and introduce
significantly different abstractions that require extensive kernel
modifications or additions.  Furthermore, such changes may render the
kernel for that architecture incompatible with much of the existing
user-level code.

Architecture ports also have significant impact on verification.

For these reasons, it is critical to first engage in discussion before
commencing on such a port.

Start an initial discussion on one of our [communication channels](Contact Us)
to check if such a port is already being worked on, whether there are known challenges with such a port, etc.  After initial discussion, start a [Request For
Comment (RFC)](RFC) describing your design and plans.

Once there is agreement on the general suitability of and design of
the port, then go on to implementing it.  Discussion, revisions of
design, sharing intermediate, proof of concept, and prototype code
during this stage is required.

Evaluate the performance and security properties of the port, and if
there are significant impacts, discuss these and consider how to redesign or
re-implement to avoid them.

Consider whether you want to have the port verified, and the plans for
achieving that.  Verifying an architecture port is a significant undertaking.

As with a platform/BSP port, make sure to write appropriate tests and include
them in seL4test as part of the port.  Consider (and discuss) a plan
for how to support this port (e.g. with regression testing) so that it
continues to be updated and work as seL4 evolves.

Once the implementation is complete follow the [Contribution
Guidelines](processes/contributing.html) for submitting changes.

## Kernel Features

If you wish to add new features to the kernel that are architecture
independent (i.e. they span different architectures) then these are
called *kernel feature contributions*.  These will require the most
extensive kernel design and implementation modifications.

As with architecture feature contributions, we do not have general
(nor specific) guidelines or how-tos for adding kernel features.
Each such feature is different and the design decisions and
implementations will also vary.

Such features are not to be considered lightly, and will often be the
result of significant research (e.g. a PhD project).

Before starting on design and implementation of architecture features
please start an initial discussion on one of our [communication
channels](https://sel4.systems/contact/) to check if such a feature is
not already being worked on, if it is considered appropriate to
include in the kernel, known issues and challenges with such features,
etc.

Then start a [Request For Comment (RFC)](/processes/rfc-process)
describing your design and plans, and engage in discussion with others
about this.  The goal is to get feedback into specific design
decisions, as well as to get agreement on the general direction and
design (considering the fit with the overall philosophy and
architecture of the kernel, performance impacts, verification impacts,
etc).

It is particulary important to consider how such a kernel feature will
affect, and be affected on, all the kernel ports, how it will affect
user-level components and systems, and how it will impact key properties such as security.

Once there is agreement on how to design and implement such a feature,
then the next step is to implement it.  Discussion, revisions of
design, and sharing of code (intermediate, proof of concept, prototype,
etc) during this stage is required.

As with any kernel modification, make sure to write appropriate tests
and include them in seL4test.  Consider (and discuss) a plan for how
to support this port (e.g. with regression testing) so that it
continues to be updated and work as seL4 evolves.

This is particularly important for features that span all the kernel
ports and need to be tested on all the supported platfroms.  It is not
sufficient to implement a kernel feature on a single platform, with no
plans of how to ensure that it works on all supported platforms (where
possible).

Once the implementation is complete follow the [Contribution
Guidelines](processes/contributing.html) for submitting changes.

## Proof Contributions

Contributing to the seL4 proofs requires a different skill set than contributing to the code, and so far we have not had many community contributions to the proofs.

As a result, our infrastructure for proof contributions is not as mature as that for code contributions.

If you are interested in proof contributions the main things to do are to:

- [Learn](http://proofcraft.org/blog/proof-engineer-reading.html) about the [Isabelle theorem prover](http://isabelle.in.tum.de/).
- Review the [proofs themselves](https://github.com/seL4/l4v/).
- [Contact us](https://sel4.systems/contact/home.pml) to discuss the possibilities.
