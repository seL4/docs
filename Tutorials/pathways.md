---
layout: tutorial
description: pathways through tutorials depending on learning objectives
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Pathways through the seL4 tutorials

The tutorials can be approached in a number of different ways. Our recommended approach for newcomers is to begin the [Microkit](https://trustworthy.systems/projects/microkit/tutorial/), bearing in mind that the Microkit hides many of the seL4 mechanisms - it is designed that way, to make building on top of seL4 easier. Having built a small system on top of seL4, the developer can delve into the concepts in the order list in the navigation bar to the left.

## Alternate pathways
Alternate pathways through the tutorials depend on development goals.

### Evaluation
Goals
- to understand seL4 and its benefits
- to learn how to use seL4 to develop trustworthy systems
- to see, compile, and run some code

Recommended tutorials
- [Setting up your machine](setting-up.md)
- [Getting the tutorials](get-the-tutorials.md)
- [Hello world](hello-world.md)

### System Building
Goals
- to build systems based on seL4
- to know which tools are available to build systems, and how to use those tools
- to build trustworthy systems

Recommended tutorials
- [Setting up your machine](setting-up.md)
- [Getting the tutorials](get-the-tutorials.md)
- [Hello world](hello-world.md)
- [MCS](mcs.md)
- The CAmkES tutorials beginning with [Hello CAmkES](hello-camkes-0.md)
- Virtualisation tutorials
  - [CAmkES VM](../camkes-vm-linux) using Linux as a guest in the CAmkES VM; and
  - [CAmkES Cross-VM communication](camkes-vm-crossvm.md) walkthrough of adding communication between Linux guests in separate VMs


### Platform Development
Goals
- to contribute to development of the seL4 (user-level) platform
- to develop operating system services and device drivers
- to develop seL4-based frameworks and operating systems

Recommended tutorials
To gain a comprehensive understanding of seL4, we recommend that you go through all the tutorials in the order listed in the default pathway.


### Kernel Development
Goals
- to contribute to the seL4 kernel itself
- to port seL4 to a new platform
- to add new features to the kernel

Recommended reading
- [Contributing to kernel code](/projects/sel4/kernel-contribution.html)

Recommended tutorials
- Follow the tutorial in the default pathway up to and including MCS.
