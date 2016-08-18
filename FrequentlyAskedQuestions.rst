= Frequently Asked Questions =
<<TableOfContents()>>

== What is seL4? ==
seL4 is the most advanced member of the L4 microkernel family, notable for its comprehensive formal verification, which sets it apart from any other operating system. seL4 achieves this without compromising performance.

=== What is a microkernel? ===
A microkernel is the minimal core of an operating system (OS). It presents a very small subset of what is generally considered an operating system today. The definition of what makes up a microkernel is given by Liedtke [SOSP'95]: A concept is tolerated inside the microkernel only if moving it outside the kernel, i.e., permitting competing implementations, would prevent the implementation of the system's required functionality.

A microkernel therefore does not provide high-level abstractions over the hardware (files, processes, sockets etc) as most modern operating systems such as Linux or Windows do. Instead it provides minimal mechanisms for controlling access to physical address space, interrupts, and processor time. Any higher-level constructs are built on top of the microkernel, using those mechanisms. Such higher-level services inevitably encapsulate policy. Policy-freedom is an important characteristic of a well-designed microkernel.

In the model used by L4 microkernels (and seL4 is no exception), an initial user-level task (the root task) is given full rights to all resources left over once the kernel has booted up (this typically includes physical memory, IO ports on x86, and interrupts). It is up to this root task to set up other tasks, and to grant rights to those other tasks in order to build a complete system. In seL4, like other third-generation microkernels, such access rights are conferred by capabilities (unforgeable tokens representing privileges) and are fully delegatable.

=== What is the L4 microkernel family? ===
L4 is a family of very small, high-performance microkernels evolved from the first L4 microkernel developed by Jochen Liedtke in the early '90s. See the [[http://en.wikipedia.org/wiki/L4_microkernel_family|L4 microkernel family]] entry on Wikipedia and the website [[http://l4hq.org/|L4HQ]] for more details.

{{http://sel4.systems/images/familytree.png||width="500"}}

L4 microkernel family tree. Black arrows indicate code, green arrows ABI inheritance. Source: [Elphinstone & Heiser, SOSP 2013]

=== How does seL4's performance compare to other microkernels? ===
To the best of our knowledge, seL4 is the world's fastest microkernel on the supported processors, in terms of the usual ping-pong metric: the cost of a cross-address-space message-passing (IPC) operation. For more information, check the [[http://l4hq.org/docs/performance.php|performance page on L4HQ]].

Note that the x86 IPC times recorded at L4HQ are the result of micro-optimisations which are not yet in the public version, and may never make it there, as we expect the soon-to-be-released x64 version to be significantly faster, making 32-bit x86 obsolete. On ARM the verified master branch version is actually faster than the figures on L4HQ, one-way IPC on the A9 is now well below 300 cycles. Actual numbers fluctuate up and down by 5–10 cycles, but there is no longer a performance difference between verified and unverified branches on ARMv7. ARMv8 is not yet fully optimised.

== On what hardware does seL4 run? ==
=== What processor architectures are supported? ===
Presently seL4 runs on ARMv6 (ARM11), ARMv7 (Cortex A8, A9, A15) and x86 cores. Supported ARM platforms for these are the Freescale i.MX31, OMAP3 !BeagleBoard, Exynos Arndale 5250, Odroid-X, Odroid-XU, Inforce IFC6410 and Freescale i.MX6 Sabre Lite. All modern x86 machines are supported.

Talk to us if you have funds to support a port to further architectures.

=== What devices does seL4 support? ===
seL4, like any real microkernel, runs all device drivers in user mode, device support is therefore not the kernel's problem. The exceptions are a timer driver, which seL4 needs to enforce time-slice preemption, and the interrupt controller access to which seL4 mediates. When compiled with debugging enabled, the kernel also contains a serial driver.

Other than that, device support is the user's problem. seL4 provides the mechanisms for user-mode device drivers, especially the ability to map device memory to drivers and forward IRQs as (asynchronous) messages.

=== What about DMA? ===
The formal verification of seL4 on the ARM platform assumes that the MMU has complete control over memory, which means the proof assumes that DMA is off. DMA devices can in theory overwrite any memory on the machine, including kernel data and code.

You can still use DMA devices safely, but you have to separately assure that they are well-behaved, that is, that they don't overwrite kernel code or data structures, and only write to frames allocated to them according to the system policy. In practice, this means, drivers and hardware for DMA devices need to be trusted.

The unverified x86 version of seL4 supports VT-d extensions on the experimental branch. The VT-d extensions allow the kernel to restrict DMA and thereby enable DMA devices with untrusted user-level drivers. We are currently working on providing similar verified support for A15 ARM boards with SystemMMU.

=== Does seL4 support multicore? ===
On x86, seL4 can be configured to support multiple CPUs. Current multicore support is through a multikernel configuration where each booted CPU is given a portion of available memory. Cores can then communicate via limited shared memory and kernel supported IPIs. This configuration is highly experimental at the moment.

=== Can I run seL4 on an MMU-less microcontroller? ===
Using seL4 without a full memory-management unit (MMU) makes little sense, as its resource management is fundamentally based on virtual memory. For lower-end processors that only have a memory-protection unit (MPU) or no memory protection at all, you should look at NICTA's [[http://ssrg.nicta.com.au/projects/TS/echronos/|eChronos real-time operating system]] (RTOS), which is designed for such processors and is also undergoing formal verification.

=== What are the intended applications of seL4? ===
seL4 is a general-purpose microkernel, so the answer is all of them. The main target are embedded systems with security or reliability requirements, but that is not exclusive. Using a microkernel like seL4 makes sense on platforms that provide virtual memory protection and for application areas that need isolation between different parts of the software. Immediate application areas are in the financial, medical, automotive, avionics and defence sectors.

== How good is seL4 at supporting virtual machines? ==
=== Can I run Linux on top of seL4? ===
Yes, seL4 can run Linux in a virtual machine. At present this is supported on x86 processors only and seL4 requires a machine that supports Intel VT-x with EPT. Additionally the current VMM requires a HPET that supports MSI delivery. We are working on supporting virtualised Linux on ARM processors with virtualisation extensions (presently A15/A7 cores), a release should not be far off.

To support virtual machines, seL4 itself runs as a hypervisor (x86 Ring-0 root mode or ARM hyp mode) and forwards virtualisation events to a virtual machine monitor (VMM) which performs the necessary emulations. The VMM runs de-privileged (x86 Ring-3 root mode or ARM supv mode).

=== How does seL4+VMM compare with OKL4 or Codezero? ===
That’s a bit difficult to answer, given that of the three, only seL4 is open-source.

Codezero (when it was still open source) was a clone of the then OKL4 microkernel, without any of the optimisations that make L4 microkernels fast.

The OKL4 Microvisor has a different API, especially designed to support efficient para-virtualisation. It has fairly mature userland, especially a driver framework.

=== Does seL4 support multiple virtual machines at once? ===
seL4 supports (hardware-supported) full virtualisation. The userland VMM required to support VMs hasn’t yet been released for ARM, but it works pretty well internally and will be released soon. We have no plans to support para-virtualised VMs.

Yes, multiple VMs are supported, including heterogeneous ones.

=== Can I run a real-time OS in a virtual machine on seL4? ===
seL4 is the world’s only hypervisor with a sound worst-case execution-time (WCET) analysis, and as such the only one that can give you actual real-time guarantees, no matter what others may be claiming. (If someone else tells you they can make such guarantees, ask them to make them in public so I can call out their bullshit.)

That said, the analysis was performed on an earlier version of the kernel, not the presently released one. We are currently re-doing that analysis. This will require some updates to the kernel to reduce interrupt latencies where they have crept up due to recent changes.

More importantly, we’re working on improvements for enabling the kind of temporal isolation that’s required for supporting mixed-criticality scheduling. That will take 6-12 months to make it into the release, by which time it’ll have been comprehensively tested and evaluated, among others in the [[http://ssrg.nicta.com.au/projects/TS/SMACCM/|SMACCM]] project

I'm actually not convinced that running an RTOS in a VM is necessarily the way to go, although that somewhat depends on your circumstances. In general you’re better off running RT apps in a native seL4 environment.

== What is formal verification? ==
Formal software verification is the activity of using mathematical proof to show that a piece of software satisfies specific properties. Traditionally, formal verification has been widely used to show that the design or a specification of a piece of software has certain properties, or that a design implements a specification correctly. In recent years, it has become possible to apply formal verification directly to the code that implements the software and to show that this code has specific properties.

There are two broad approached to formal verification: fully automated methods such as model checking that work on limited systems and properties, and interactive mathematical proof which requires manual effort.

The seL4 verification uses formal mathematical proof in the theorem prover [[http://isabelle.in.tum.de/|Isabelle/HOL]]. This theorem prover is interactive, but offers a comparatively high degree of automation. It also offers a very high degree of assurance that the resulting proof is correct.

=== What does seL4's formal verification mean? ===
Unique about seL4 is its unprecedented degree of assurance, achieved through formal verification. Specifically, the ARM version of seL4 is the first (and still only) general-purpose OS kernel with a full code-level functional correctness proof, meaning a mathematical proof that the implementation (written in C) adheres to its specification. In short, the implementation is proved to be bug-free (see below). This also implies a number of other properties, such as freedom from buffer overflows, null pointer exceptions, use-after-free, etc.

There is a further proof that the binary code which executes on the hardware is a correct translation of the C code. This means that the compiler does not have to be trusted, and extends the functional correctness property to the binary.

Furthermore, there are proofs that seL4's specification, if used properly, will enforce integrity and confidentiality, core security properties. Combined with the proofs mentioned above, these properties are guaranteed to be enforced not only by a model of the kernel (the specification) but the actual binary that executes on the hardware. Therefore, seL4 is the world's first (and still only) OS that is proved secure in a very strong sense.

Finally, seL4 is the first (and still only) protected-mode OS kernel with a sound and complete timeliness analysis. Among others this means that it has provable upper bounds on interrupt latencies (as well as latencies of any other kernel operations). It is therefore the only kernel with memory protection that can give you hard real-time guarantees.

=== Does seL4 have zero bugs? ===
The functional correctness proof states that, if the proof assumptions are met, the seL4 kernel implementation has no deviations from its specification. The security proofs state that if the kernel is configured according to the proof assumptions and further hardware assumptions are met, this specification (and with it the seL4 kernel implementation) enforces a number of strong security properties: integrity, confidentiality, and availability.

There may still be unexpected features in the specification and one or more of the assumptions may not apply. The security properties may be sufficient for what your system needs, but might not. For instance, the confidentiality proof makes no guarantees about the absence of covert timing channels.

So the answer to the question depends on what you understand a bug to be. In the understanding of formal software verification (code implements specification), the answer is yes. In the understanding of a general software user, the answer is potentially, because there may still be hardware bugs or proof assumptions unmet. For high assurance systems, this is not a problem, because analysing hardware and proof assumptions is much easier than analysing a large software system, the same hardware, and test assumptions.

=== Is seL4 proven secure? ===
This depends on what you mean by secure. In the interpretation of classic operating system security, the answer is yes. In particular, seL4 has been proved to enforce specific security properties, namely integrity and confidentiality, under certain assumptions. These proofs are very strong evidence about seL4's utility for building secure systems.

Some of the proof assumptions may appear restrictive, for instance use of DMA is excluded, or only allowed for trusted drivers that have to be formally verified by the user. While these restrictions are common for high-assurance systems, we are working to reduce them, for instance through the use of IOMMUs on x86 or System MMUs on ARM.

=== If I run seL4, is my system secure? ===
Not automatically, no. Security is a question that spans the whole system, including its human parts. An OS kernel, verified or not, does not automatically make a system secure. In fact, any system, no matter how secure, can be used in insecure ways.

However, if used correctly, seL4 provides the system architect and user with strong mechanisms to implement security policies, backed by specific security theorems.

=== What are the proof assumptions? ===
The brief version is: we assume that in-kernel assembly code is correct, hardware behaves correctly, in-kernel hardware management (TLB and caches) is correct, and boot code is correct. The hardware model assumes DMA to be off or to be trusted. The security proofs additionally give a list of conditions how the system is configured.

For a more in-depth description, see the [[http://sel4.systems/Info/FAQ/proof.pml|proof and assumptions page]].

=== How do I leverage seL4's formal proofs? ===
The seL4 proofs are just the first step in building secure systems. They provide the tools that application and system developers need for providing evidence that their systems are secure.

For instance, one can use the functional correctness proof to show that an application interfaces correctly with the kernel. One can use the integrity property to show that others can't interfere with private data, and the confidentiality proof to show that others can't get access to that private data. And one can tie together all of these into a proof about an entire (one-machine) systems without having to verify the code of the entire system.

If you are interested in connecting to the seL4 proofs, let us know, we may be able to offer assistance.

=== Have OS kernels not been verified before? ===
OS verification goes back at least 40 years to the mid 1970s, so there is plenty of previous work on verified OS kernels. See also a [[http://ssrg.nicta.com.au/publications/papers/Klein_09.abstract|comprehensive overview]] paper on OS verification from 2008 as well as the related work section of the [[http://ssrg.nicta.com.au/publications/papers/Klein_09.abstract|seL4 overview paper]] from 2014.

The new and exciting thing about seL4 is that is has a) strong properties such as functional correctness, integrity, and confidentiality, and b) has these properties formally verified directly to the code — initially to C, now also to binary. In addition, the seL4 proofs are machine-checked, not just based on pen and paper.

Previous verifications have either not completed their proofs, have targeted more shallow properties, such as the absence of undefined execution, or they have verified manually constructed models of the code instead of the code itself.

Some of these previous verifications were impressive achievements that laid much of the groundwork without which the seL4 proofs would not have been achieved. It is only in the last 5-10 years that code verification and theorem proving technology has advanced enough to make large code-level proofs feasible.

=== When and how often does seL4 get updated and re-proved? ===
We update the seL4 proofs semi-continuously, usually whenever something is pulled into the master branch in the seL4 github repository. You can see the proof updates coming through on https://github.com/seL4/l4v/commits/master and you can see the kernel revision the proof currently refers to in https://github.com/seL4/verification-manifest/blob/master/default.xml. This is usually the head of the master branch.

The rough protocol for updates in the seL4 master branch is that, together with the kernel team, the verification team picks the next feature(s), isolates them on a separate small internal feature branch, starts verifying that, and when done, merges both into the proof repository and seL4 master. Occasionally, something new gets directly into master, is verified there and then pulled through to experimental.

The frequency depends on what it is and who has time. Larger features take longer to write and prove, get pushed when they are done, and get selected by importance for the projects we're running. Not many of these happen per year unless there is specific funding for a specific feature. Small updates take a day to a few weeks and we often do them on the side. There's no specific schedule at the moment.

=== How do I tell which code in github is covered by the proof and which isn't? ===
The verification sees the entire C code for one particular combination of configuration options. Currently this is the imx6 platform, Cortex A9 processor, ARMv7-a architecture, all other config options unset (in particular DEBUG, PROFILING, etc). Excluded from this C code is the machine interface and boot code, their behavior is an explicit assumption to the proof.

You can see the exact verification config options in [[https://github.com/seL4/l4v/blob/master/spec/cspec/c/Makefile|l4v/spec/cspec/c/Makefile]]. The machine interface are the functions that correspond to the ones in the Haskell file [[https://github.com/seL4/seL4/blob/master/haskell/src/SEL4/Machine/Hardware.lhs|Hardware.lhs]].

You can further inspect the gory details by looking at the preprocessor output in the file `kernel_all.c_pp` in the proof build - this is what the prover, the proof engineer, and the compiler see after configuration is done. So a quick way of figuring out if something is in the proof input or not is checking if the contents of that file change if you make a change to the source you're wondering about. You don't need the prover for this, and only parts of the seL4 build environment setup.

The top-level proof makes statements about the behaviour of all of the kernel entry points, which we enumerate once manually in the proof. The prover reads in these entry points, and anything that they call must either have a proof or an assumption for it to complete its proof. If anything is missing, the proof fails.

That means all of the C code that is in this `kernel_all.c_pp` file either:

 * has a proof,
 * or has an explicit assumption about it,
 * or is not part of the kernel (i.e. is never called)

The functions with explicit assumptions are the machine interface functions mentioned above (they're usually inline asm) and the functions that are only called by the boot process (usually marked with the BOOT_CODE macro in the source so they're easy to spot).

As an example, the CPU and architecture options mean that everything under `src/arch/ia32` is not covered by the proof, but that the files in `src/kernel/object` are.

== What is the seL4 fastpath? ==
The fastpath is an add-on frontend to the kernel which performs the simple cases of some common operations quickly.

Enabling or disabling the fastpath should not have any impact on the kernel behaviour except for performance.

There is a section on the fastpath and its verification in [[http://www.ssrg.nicta.com.au/publications/nictaabstracts/Klein_AEMSKH_14.abstract.pml|this article]]. The fastpath discussion starts on page 23.

== What can I do with seL4? ==
You can use seL4 for research, education or commerce. Details are specified in the standard open-source [[#lic|licenses]] that come with the code. Different licenses apply to different parts of the code, but the conditions are designed to ease uptake.

== What are the licensing conditions? ==
<<Anchor(lic)>>

The seL4 kernel is released under GPL Version 2. Userland tools and libraries are mostly under BSD. See the [[http://sel4.systems/Info/GettingStarted/license.pml|license page]] for more details.

== How do I contribute to seL4? ==
See [[http://sel4.systems/Community/Contributing|How to Contribute]]. In brief, seL4 was released under a complicated agreement between the partners who owned the code. A condition of the release is that we track all contributions, and get a signed licence agreement from all contributors.

== How can I build a system with seL4? ==
Much more is required to build a system on seL4 compared to building on, say Linux. Having decomposed your system into modules, you will need to work out what access each module needs to hardware resources, you will need to build device drivers for the platform you are on (there are a few provided in libplatsupport for supported platforms), and you will have to integrate it into something that can be run.

There are two recommended ways to do this.

 * [[http://sel4.systems/Info/CAmkES|CAmKES]] is the Component Architecture for Micro-Kernel-based Embedded Systems. It provides a language for describing the distribution of resources to components, and the assignment of components to address spaces.
 * Build on `libsel4utils`, which provides useful abstractions like processes, but is generally more low-level.

For build instructions, and how to get started, see the [[http://sel4.systems/Info/GettingStarted/|Download]] page. Also, UNSW's [[http://cs9242.web.cse.unsw.edu.au/|Advanced Operating Systems course]] has an extensive project component that builds an OS on top of seL4. If you have access to a Sabre Lite board, you should be able to do the project work yourself as a way of familiarising yourself with seL4.

== Where can I learn more? ==
NICTA's [[http://ssrg.nicta.com.au/projects/seL4/|seL4 project]] and [[http://ssrg.nicta.com.au/projects/TS/|Trustworthy Systems]] pages contain more technical information about seL4, including links to all peer-reviewed publications. Good starting points are:

 * [[http://ssrg.nicta.com.au/publications/nictaabstracts/Elphinstone_Heiser_13.abstract.pml|from L3 to seL4 – what have we learnt in 20 years of L4 microkernels?]], a 20-year retrospective of L4 microkernels;
 * [[http://ssrg.nicta.com.au/publications/papers/Klein_EHACDEEKNSTW_09.abstract|the original 2009 paper]] describing seL4 and its formal verification;
 * [[http://ssrg.nicta.com.au/publications/nictaabstracts/Klein_AEMSKH_14.abstract.pml|a much longer paper detailing the complete verification story of seL4]], including the high-level security proofs, binary verification and timeliness analysis. It also contains an analysis of the cost of verification, and how it compares to that of traditionally-engineered systems.

== What's coming up next? ==
We're currently working on a number of things. As we're in a research environment (not a product development environment) we cannot commit to dates, or the order in which any of these will be delivered (or even if they will be released at all).

That being said, we are currently working on and should be able to release soon:

 * Arm virtualisation support, on the Arndale and Odroid
 * A port to the Odroid XU3
 * WCET guarantees for the current kernel
 * An SMP version of seL4
