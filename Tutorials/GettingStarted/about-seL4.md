---
toc: true
layout: overview
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2024 seL4 Project a Series of LF Projects, LLC.
---
<h1>About seL4</h1>

<p>
    seL4 is a third-generation microkernel. It is broadly based on L4 and influenced by EROS. Like L4 it features abstractions for virtual address spaces, threads, IPC, and, unlike most earlier L4 kernels, an explicit in-kernel memory management model and capabilities for authorisation.
</p>
<p>
    <em>Authority</em> in seL4 is conferred by possession of a capability. Capabilities are segregated and stored in capability address spaces composed of capability container objects called <em>CNodes</em>. seL4 has six system calls, of which five require possession of a capability (the sixth is a <em>yield</em> to the scheduler). The five system calls are IPC primitives that are used either to invoke services implemented by other processes (using capabilities to port-like <em>endpoints</em> that facilitate message passing), or invoke kernel services (using capabilities to kernel objects, such as a thread control block (TCB)). While the number of system calls is small, the kernel’s effective API is the sum of all the interfaces presented by all kernel object types.
</p>
<p>
    <em>Kernel memory management</em> in seL4 is explicit. All kernel data structures are either statically allocated at boot time, or are dynamically-allocated first-class objects in the API. Kernel objects thus act as both inkernel data structures, and user-invoked fine-grained kernel services. Kernel objects include TCBs, CNodes, and level-1 and level-2 page tables (termed PageDirectories and PageTables).
</p>
<p>
    Authority over free memory is encapsulated in an untyped memory object. Creating new kernel objects explicitly involves invoking the retype method of an untyped
memory object, which allocates the memory for the object, initialises it, and returns a capability to the new object.
</p>
<p>
    <em>Virtual address spaces</em> are formed by explicit manipulation of virtual-memoryrelated kernel objects: PageDirectories, PageTables, ASIDPools and Frames (mappable physical memory). As such, address spaces have no kernel-defined structure (except for a protected region reserved for the seL4 kernel itself). Whether the userlevel system is Exokernel like, a multi-server, or a para-virtualised monolithic OS is determined by user-level via a <em>map</em> and <em>unmap</em> interface to Frames and PageTables. The distribution of authority to the kernel virtual memory (VM) objects ultimately determines the scope of influence over virtual and physical memory.
</p>
<p>
    <em>Threads</em> are the active entity in seL4. By associating a CNode and a virtual address space with a thread, user-level policies create high-level abstractions, such as processes or virtual machines.
</p>
<p>
    <em>IPC</em> is supported in two forms: synchronous message passing via endpoints (portlike destinations without in-kernel buffering), and asynchronous notification via <em>asynchronous endpoints</em> (rendezvous objects consisting of a single in-kernel word that is used to combine IPC sends using a logical <em>or</em>). Remote procedure call semantics are facilitated over synchronous IPC via <em>reply capabilities</em>. Send capabilities are <em>minted</em> from an initial endpoint capability. Send capabilities feature an immutable <em>badge</em> which is used by the specific endpoint’s IPC recipients to distinguish which send capability (and thus which authority) was used to send a message. The unforgeable badge, represented by an integer value, is delivered with the message.
</p>
<p>
    <em>Exceptions</em> are propagated via synchronous IPC to each thread’s exception handler (registered in the TCB via a capability to an endpoint). Similarly, page faults are also propagated using synchronous IPC to a thread’s page fault handler. Non-native system calls are treated as exceptions to support virtualisation.
</p>
<p>
    <em>Device Drivers</em> run as user-mode applications that have access to device registers and memory, either by mapping the device into the virtual address space, or by controlled access to device ports on x86 hardware. seL4 provides a mechanism to receive notification of interrupts (via asynchronous IPC) and acknowledge their receipt.
</p>
<p>
    The seL4 kernel runs on multiple platforms, and runs on common architectures like ARM and RiscV.
</p>
<p>
    Because sel4 is small, a lot more needs to be done in user space and there are a lot more choices about how to do that. We'll start by building a simple system using the seL4 Microkit, which is a software development kit for building static systems on seL4.
</p>
<p>
    Next: Get started with the <a href="microkit">seL4 microkit tutorial</a>
</p>