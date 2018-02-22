# seL4 1.0.0-rt-dev


The development branch of the for the seL4 realtime extensions. This
branch is not verified and is under active development.

## Highlights


### Maximum priorities


Previously seL4 would not allow threads to set any other thread's
priority to higher than its own. This has been extracted into a separate
field for the RT kernel, a maximum priority, which limits what threads
can set their own or other threads priorities to.

### Criticality & Max Criticality


Criticality is a new field for threads. The kernel has a system
criticality level which can be set by the user. When the criticality
level is raised, threads with criticality &gt;= the criticality level
have their priorities boosted such that they are chosen by the scheduler
over low criticality threads.

### Scheduling contexts


This branch adds scheduling contexts to seL4, which represent CPU time
(as budget/period). Scheduling contexts are separate from threads
(although threads require one to run) and can be passed around over IPC,
if the target of an IPC does not have its own scheduling context.

Scheduling contexts allow developers to create periodic threads,
temporally isolate threads and have variable timeslices for round robin
threads. If budget == period, the scheduling context acts as timeslice.

### IPC & Signal ordering


Signal and IPC delivery is now priority ordered, instead of FIFO.

### Temporal exceptions


Threads can register a temporal exception handler that will be called if
a threads budget expires before its period has passed. This is optional.

For more details, please see the manual. Most of the updates are in the
threads chapter.

### User level scheduling support


The new API makes it much easier to build high performing user level
schedulers.

## RT API


This section documents kernel API changes as compared with the current
master of seL4.

### API Changes


  -   seL4\_TCB\_Configure arguments changed (domain removed, scheduling
      context cap, max priority, criticality, max criticality, temporal
      exception handler added). Fault endpoints are also now specified
      in the caller's cspace, as they are installed the the TCB cspace
      and looked up once rather than every fault.
  -   seL4\_TCB\_SetSpace temporal exeception handler added.

### API Additions


  -   seL4\_CapSchedControl - initial cap for control of CPU time
  -   seL4\_SchedContextObject - new object for that allows threads
      access to CPU time
  -   seL4\_SchedContextBits - size in bits of a scheduling context
      object
  -   seL4\_SignalRecv - new system call which allows a single kernel
      invocation to perform a non-blocking send on one capability, and
      wait on another.
  -   seL4\_SignalRecvWithMRs - uses above new system call without
      touching the IPC buffer, passing only data in registers
  -   seL4\_Time - type for specifying temporal units to the kernel
  -   seL4\_TCB\_SetMaxPriority - set the max priority for a TCB,
      threads can only start / set priorities threads up to and
      including their max priority
  -   seL4\_TCB\_SetCriticality - set the criticality for a TCB.
  -   seL4\_TCB\_SetMaxCriticality - set the max criticality for a TCB,
      threads can only set criticalities of threads threads up to and
      including their max criticality
  -   seL4\_Prio\_t - type for priority and max priority, criticality
      and max criticality, used in TCB\_Configure
  -   seL4\_CNode\_SwapCaller - swap the reply cap in the TCB's reply
      slot with the reply cap or null cap in the slot in the
      specified slot.
  -   seL4\_CNode\_SwapTCBCaller - as above, but operates on the reply
      cap slot of the target TCB. This allows another thread to reply on
      behalf of the owner of the reply cap.
  -   seL4\_SchedControl\_Configure - invokes the scheduling control cap
      to populate a scheduling context with parameters
  -   seL4\_SchedContext\_Yield - end the timeslice of the thread bound
      to the sched context invoked. The thread will not run again until
      its period passes.
  -   seL4\_SchedContext\_YieldTo - If a thread is bound to the
      scheduling context that this call is invoked on, place it at the
      head of the scheduling queue for that threads priority. Returns
      the amount of time the thread yielded to executes.
  -   seL4\_SchedContext\_Consumed - returns the amount of time this
      scheduling context has executed since the last call to this
      function or YieldTo.
  -   seL4\_SchedContext\_BindTCB - bind a TCB to a scheduling context,
      if the TCB is runnable and scheduling context has budget, this
      will start the TCB running
  -   seL4\_SchedContext\_UnbindTCB - remove binding of a scheduling
      context from a TCB, TCB will no longer run but state will be
      preserved
  -   seL4\_CapInitThreadSC - capability to the initial threads
      scheduling context
  -   seL4\_CapSchedControl - scheduling control capability, which is
      given to the root thread
  -   seL4\_SchedContext\_BindNotification - Bind a notification to a
      scheduling context. Passive threads waiting on this notification
      will borrow the scheduling context.
  -   seL4\_SchedContext\_UnbindNotification - unbind the notification.

### API deletions


  -   seL4\_Yield (replaced by seL4\_SchedContext\_Yield)
  -   seL4\_DomainSet
  -   Domain scheduler removed.
  -   seL4\_CNode\_SaveCaller (replaced by seL4\_CNode\_SwapCaller).

## Performance improvements


The RT kernel has various experimental performance improvements
including:

  -   Interrupt fastpath
  -   Signal fastpath (when signals are not delivered immediately - i.e
      to a lower prio thread)
  -   Slowpath avoids IPC lookup if message fits in registers
  -   Fault endpoints are looked up when registered and installed in the
      TCB's CNode, saving lookups on each fault.

## Library & test compatability


The 'rt' branch of seL4\_libs has been adapted to the rt branch of seL4,
and the rt branch of sel4test has been ported to the seL4\_rt-dev-1.0.0
kernel, along with many more tests written suited to the rt kernel. To
run it, checkout the default.xml manifest on the rt branch of
[sel4test-manifest](https://github.com/seL4/sel4test-manifest/tree/rt).

The rt branch is in no way compatible with the master branch of seL4.

## Hardware support


The RT kernel currently supports:

  -   Beagle board
  -   Sabre
  -   x86 (only processors that support TSC\_DEADLINE mode)
  -   Odroid-XU

Other hardware platforms will be added as required (the ports require
updated kernel and user-level timer drivers)

## More details


See the 1.0.0-rt-dev manual included in the release.
