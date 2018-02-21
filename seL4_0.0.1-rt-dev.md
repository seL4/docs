= seL4 0.0.1-rt-dev =

The development branch of the for the seL4 realtime extensions. This
branch is not verified and is under active development.

== Highlights ==

> \* Maximum priorities
>
> :   -   Previously seL4 would not allow threads to set any other
>         thread's priority to higher than its own. This has been
>         extracted into a separate field for the RT kernel, a maximum
>         priority, which limits what thread cans set their own or other
>         threads priorities to.
>
> \* Scheduling contexts
>
> :   -   This branch adds scheduling contexts to seL4, which represent
>         CPU time. Scheduling contexts are separate to threads
>         (although threads required one to run) and can be passed
>         around over IPC.
>     -   Scheduling contexts allow developers to create periodic
>         threads, temporally isolation threads and have variable
>         timeslices for round robin threads.
>
For more details, please see the manual. Most of the updates are in the
threads chapter.

== API Changes ==

> -   seL4\_TCB\_Configure arguments changed (domain removed, scheduling
>     context cap and max priority added).

== API Additions ==

> -   seL4\_CapSchedControl - initial cap for control of CPU time
> -   seL4\_SchedContextObject - new object for that allows threads
>     access to CPU time
> -   seL4\_SchedContextBits - size in bits of a scheduling context
>     object
> -   seL4\_NBSendRecv - new system call which allows once kernel
>     invocation to perform a non-blocking send on one capability, and
>     wait on another.
> -   seL4\_NBSendRecvWithMRs - uses above new system call without
>     touching the IPC buffer, passing only data in registers
> -   seL4\_Time - type for specifying temporal units to the kernel
> -   seL4\_TCB\_SetMaxPriority - set the max priority for a tcb,
>     threads can only start / set priorities threads up to and
>     including their max priority
> -   seL4\_Prio\_t - type for priority and max priority, used in
>     TCB\_Configure
> -   seL4\_CNode\_SaveTCBCaller - save the reply cap of the target tcb.
>     This allows another thread to reply on behalf of the owner of the
>     reply cap.
> -   seL4\_SchedControl\_Configure - invokes the scheduling control cap
>     to populate a scheduling context with parameters
> -   seL4\_SchedContext\_Yield - end the timeslice of the thread bound
>     to the sched context invoked.
> -   seL4\_SchedContext\_BindTCB - bind a tcb to a scheduling context,
>     if the TCB is runnable and scheduling context has budget, this
>     will start the tcb running
> -   seL4\_SchedContext\_UnbindTCB - remove binding of a scheduling
>     context from a tcb, tcb will no longer run but state will be
>     preserved
> -   seL4\_CapInitThreadSC - capability to the initial threads
>     scheduling context
> -   seL4\_CapSchedControl - scheduling control capability, which is
>     given to the root thread
> -   seL4\_SchedContext\_BindNotification - Bind a notification to a
>     scheduling context. Passive threads waiting on this notification
>     will borrow the scheduling context.
> -   seL4\_SchedContext\_UnbindNotification - unbind the notification.

== API deletions ==

> -   seL4\_Yield (replaced by seL4\_SchedContext\_Yield)
> -   seL4\_DomainSet
> -   Domain scheduler removed.

== Library & test compatability ==

The 'rt' branch of seL4\_libs has been adapted to the rt branch of seL4,
and the rt branch of sel4test has been ported to the seL4\_rt-dev-0.0.1
kernel, along with many more tests written suited to the rt kernel. To
run it, checkout the default.xml manifest on the rt branch of
sel4test-manifest.

The rt branch is in no way compatible with the master branch of seL4.

More details See the 0.0.1-rt-dev manual included in the release.
