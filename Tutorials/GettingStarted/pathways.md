---
toc: true
title: Tutorial pathways
layout: tutorial
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2024 seL4 Project a Series of LF Projects, LLC.
---

# Pathways through tutorials
The tutorials can be approached in a number of different ways. Our recommended approach for newcomers is to begin the [Microkit](https://trustworthy.systems/projects/microkit/tutorial/), bearing in mind that the Microkit hides many of the seL4 mechanisms - it is designed that way, to make building on top of seL4 easier. Having built a small system on top of seL4, the developer can delve into the concepts in the order list in the navigation bar to the left.

## Alternate pathways
Alternate pathways through the tutorials depend on development goals.

### Evaluation
Goals:
- to understand seL4 and its benefits
- to learn how to use seL4 to develop trustworthy systems
- to see, compile, and run some code

Recommended tutorials
- [Setting up your machine](../seL4Kernel/setting-up)
- [Getting the tutorials](../seL4Kernel/get-the-tutorials.md)
- [Hello world](../seL4Kernel/hello-world.md)

### System Building
Goals:
- to build systems based on seL4
- to know which tools are available to build systems, and how to use those tools
- to build trustworthy systems

Recommended tutorials:
- [Setting up your machine](../seL4Kernel/setting-up)
- [Getting the tutorials](../seL4Kernel/get-the-tutorials.md)
- [Hello world](../seL4Kernel/hello-world.md)
- [MCS](../MCS/mcs.md)
- The CAmkES tutorials beginning with [Hello CAmkES](../CAmkES/hello-camkes-0.md)
- Virtualisation tutorials 
  - [CAmkES VM](../CAmkES/camkes-vm-linux) using Linux as a guest in the CAmkES VM; and
  - [CAmkES Cross-VM communication](../CAmkES/camkes-vm-crossvm.md) walkthrough of adding communication between Linux guests in separate VMs


### Platform Development
Goals:
- to contribute to development of the seL4 (user-level) platform
- to develop operating system services and device drivers
- to develop seL4-based frameworks and operating systems

Recommended tutorials:
- [Setting up your machine](../seL4Kernel/setting-up)
- [Getting the tutorials](../seL4Kernel/get-the-tutorials.md)
- [Hello world](../seL4Kernel/hello-world.md)
- [M]
**up to here**


seL4 mechanisms tutorial
Rapid prototyping tutorials
CAmkES tutorials
Virtualisation tutorial
MCS tutorial

Kernel Development
Goal:

You want to contribute to the seL4 kernel itself.
You want to port seL4 to a new platform.
You want to add new features to the kernel.
Read this first:

Contributing to kernel code
Then follow these tutorials:

seL4 overview
Introduction tutorial
seL4 mechanisms tutorial
MCS tutorial


<p>
     Next tutorial: <a href="../seL4Kernel/overview">seL4 kernel tutorials</a>
</p>