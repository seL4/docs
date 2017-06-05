/!\ Draft /!\

= seL4 5.2.0-mcs =

This is a pre-release of the seL4 mixed-criticality systems (RT) extensions. This branch is not verified and is under active verification. This is a subset of the previously released RT extensions, which still exist and can be provided in request.

== Highlights ==

=== Scheduling contexts ===

This branch adds scheduling contexts to seL4, which represent CPU time (as budget/period). Scheduling contexts are separate from threads (although threads require one to run) and can be passed around over IPC, if the target of an IPC does not have its own scheduling context.

Scheduling contexts allow developers to create periodic threads, temporally isolate threads and have variable timeslices for round robin threads. If budget == period, the scheduling context acts as timeslice.

=== IPC & Signal ordering ===
 
Signal and IPC delivery is now priority ordered and FIFO within a priority, rather than plain FIFO 

=== Periodic scheduling ===

TODO 

=== Passive Servers ===

TODO 

=== Reply objects ===

TODO

== MCS API ==

This section documents kernel API changes as compared with the current master of seL4.

=== API Changes ===

 * `seL4_TCB_Configure` arguments changed (scheduling context cap added). Fault endpoints are also now specified in the caller's cspace, as they are installed the the TCB cspace and looked up once rather than every fault. 
 * `seL4_Wait` vs `seL4_Recv`

=== API Additions ===

 * `seL4_CapSchedControl` - initial cap for control of CPU time
 * `seL4_SchedContextObject` - new object for that allows threads access to CPU time
 * `seL4_MinSchedContextBits` - minimum size n (2^n) of a scheduling context object
 * `seL4_Wait`
 * `seL4_NBWait`
 * `seL4_NBSendRecv` - new system call which allows a single kernel invocation to perform a non-blocking send on one capability, and wait on another. 
 * `seL4_NBSendRecvWithMRs` - uses above new system call without touching the IPC buffer, passing only data in registers
 * `seL4_SchedControl_Configure` - invokes the scheduling control cap to populate a scheduling context with parameters
 * `seL4_SchedContext_Bind` - bind a TCB to a scheduling context, if the TCB is runnable and scheduling context has budget, this will start the TCB running
 * `seL4_SchedContext_Unbind` - remove binding of a scheduling context from a TCB, TCB will no longer run but state will be preserved
 * `seL4_SchedContext_Unbind Object` - remove binding of a scheduling context from a TCB, TCB will no longer run but state will be preserved
 * `seL4_CapInitThreadSC` - capability to the initial threads scheduling context
 * `seL4_CapSchedControl` - scheduling control capability, which is given to the root thread

=== API deletions ===

 * `seL4_CNode_SaveCaller` (deprecated by reply objects)
 * `seL4_Reply` (replaced by invoking a reply object)

== Performance improvements ==

The RT kernel has various experimental performance improvements including:

 * Fault endpoints are looked up when registered and installed in the TCB's CNode, saving lookups on each fault.

== Library & test compatability ==

The 'rt' branch of seL4_libs has been adapted to the rt branch of seL4, and the rt branch of sel4test has been ported to the seL4_rt-dev-1.0.0 kernel, along with many more tests written suited to the rt kernel. To run it, checkout the default.xml manifest on the rt branch of [[https://github.com/seL4/sel4test-manifest/tree/rt|sel4test-manifest]].

The `rt` branch is in no way compatible with the master branch of seL4.

== Hardware support ==

The RT kernel currently supports:

 * Beagle board
 * Sabre
 * x86
 * Odroid-XU

Other hardware platforms will be added as required (the ports require updated kernel and user-level timer drivers)

== More details ==

See the 5.2.0-mcs manual included in the release. 
