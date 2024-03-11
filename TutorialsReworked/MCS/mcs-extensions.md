---
toc: true
layout: project
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2024 seL4 Project a Series of LF Projects, LLC.
---

# MCS Extensions
This tutorial presents the features in the upcoming MCS extensions for seL4, which are currently undergoing
verification. For further context on the new features, please see the
[paper](https://trustworthy.systems/publications/csiro_full_text/Lyons_MAH_18.pdf) or [phd](https://github.com/pingerino/phd/blob/master/phd.pdf)
 which provides a comprehensive background on the changes.

Learn:
1. About the MCS new kernel API.
1. How to create and configure scheduling contexts.
2. The jargon *passive server*.
3. How to spawn round-robin and periodic threads.



## Initialising

Then initialise the tutorial:

```sh
# For instructions about obtaining the tutorial sources see https://docs.sel4.systems/Tutorials/#get-the-code
#
# Follow these instructions to initialise the tutorial
# initialising the build directory with a tutorial exercise
./init --tut mcs
# building the tutorial exercise
cd mcs_build
ninja
```

<details markdown='1'>
<summary style="display:list-item"><em>Hint:</em> tutorial solutions</summary>
<br>
All tutorials come with complete solutions. To get solutions run:
```
./init --solution --tut mcs
```
</details>


## Background

The MCS extensions provide capability-based access to CPU time, and provide mechanisms to limit the upper
bound of execution of a thread.

### Scheduling Contexts

Scheduling contexts are a new object type in the kernel, which contain scheduling parameters amoung other
accounting details. Most importantly, scheduling contexts contain a *budget* and a *period*, which
represent an upper bound on execution time allocated: the kernel will enforce that threads cannot execute
for more than *budget* microseconds out of *period* microseconds.

### SchedControl

Parameters for scheduling contexts are configured by invoking `seL4_SchedControl` capabilities, one of
which is provided per CPU. The invoked `seL4_SchedControl` determines which processing core that specific
scheduling context provides access to.

Scheduling contexts can be configured as *full* or *partial*. Full scheduling contexts have `budget ==
period` and grant access to 100% of CPU time. Partial scheduling contexts grant access to an upper bound of
 `budget/period` CPU time.

The code example below configures a
scheduling context with a budget and period both equal to 1000us. Because the budget and period are equal,
the scheduling context is treated as round-robin

```c
    error = seL4_SchedControl_Configure(sched_control, sched_context, US_IN_S, US_IN_S, 0, 0);
    ZF_LOGF_IF(error != seL4_NoError, "Failed to configure schedcontext");
```

### SchedContext Binding

Thread control blocks (TCBs) must have a scheduling context configured with non-zero budget and period
 in order to be picked by the scheduler. This
can by invoking the scheduling context capability with the `seL4_SchedContext_Bind` invocation, or by
using `seL4_TCB_SetSchedParams`, which takes a scheduling context capability. Below is example code for
binding a TCB and a scheduling context.

```c
    error = seL4_SchedContext_Bind(sched_context, spinner_tcb);
    ZF_LOGF_IF(error != seL4_NoError, "Failed to bind sched_context to round_robin_tcb");
```

TCB's can only be bound to one scheduling context at a time, and vice versa. If a scheduling context has not
been configured with any time, then although the TCB has a scheduling context it will remain ineligible
for scheduling.

### Bounding execution

For partial scheduling contexts, an upper bound on execution is enforced by seL4 using the *sporadic server*
algorithm, which work by guaranteeing the *sliding window* constrain, meaning that during any period, the
budget cannot be exceeded. This is achieved by tracking the eligible budget in chunks called
*replenishments* (abbreviated to `refills` in the API for brevity). A replenishment is simply an amount
 of time, and a timestamp from which that time can be consumed. We explain this now through an example:

Consider a scheduling context with period *T* and budget *C*. Initially, the scheduling context has
a single replenishment of size *C* which is eligible to be used from time *t*.

The scheduling context is scheduled at time *t* and blocks at time *t + n*. A new replenishment is then scheduled
for time *t+T* for *n*. The existing replenishment is updated to *C - n*, subtracting the amount consumed.
For further details on the sporadic server algorithm, see the
[original paper](https://dl.acm.org/citation.cfm?id=917665).

If the replenishment data structure is full, replenishments are merged and the upper bound on execution is
reduced. For this reason, the bound on execution is configurable with the `extra_refills` parameter
on scheduling contexts. By default, scheduling contexts contain only two parameters, meaning if a
scheduling context is blocked, switched or preempted more than twice, the rest of the budget is forfeit until
the next period. `extra_refills` provides more replenishment data structures in a scheduling context. Note
that the higher the number of replenishments the more fragmentation of budget can occur, which will increase
scheduling overhead.

`extra_refills` itself is bounded by the size of a scheduling context, which is itself configurable.
On scheduling context creation a size can be specified, and must be `> seL4_MinSchedContextBits`. The
maximum number of extra refills that can fit into a specific scheduling context size can be calculated
with the function `seL4_MaxExtraRefills()` provided in `libsel4`.

Threads bound to scheduling contexts that do not have an available replenishment are placed into an ordered
queue of threads, and woken once their next replenishment is ready.

### Scheduler

The seL4 scheduler is largely unchanged: the highest priority, non-blocked thread with a configured
 scheduling context that has available budget is chosen by the scheduler to run.

### Passive servers

The MCS extensions allow for RPC style servers to run on client TCBs' scheduling contexts. This is achived by
unbinding the scheduling context once a server is blocked on an endpoint, rendering the server *passive*.
Caller scheduling contexts are donated to the server on `seL4_Call` and returned on `seL4_ReplyRecv`.

Passive servers can also receive scheduling contexts from their bound notification object, which is
achieved by binding a notification object using `seL4_SchedContext_Bind`.

### Timeout faults

Threads can register a timeout fault handler using `seL4_TCB_SetTimeoutEndpoint`. Timeout fault
handlers are optional and are raised when a thread's replenishment expires *and* they have a valid handler
registered. The timeout fault message from the kernel contains the data word which can be used to identify the
scheduling context that the thread was using when the timeout fault occurred, and the amount of time
consumed by the thread since the last fault or `seL4_SchedContext_Consumed`.

### New invocations

* `seL4_SchedContext_Bind` - bind a TCB or Notification capability to the invoked scheduling context.
* `seL4_SchedContext_Unbind` - unbind any objects from the invoked scheduling context.
* `seL4_SchedContext_UnbindObject`- unbind a specific object from the invoked scheduling context.
* `seL4_SchedContext_YieldTo` - if the thread running on the invoked scheduling context is
schedulable, place it at the head of the scheduling queue for its priority. For same priority threads, this
will result in the target thread being scheduled. Return the amount of time consumed by this scheduling
context since the last timeout fault, `YieldTo` or `Consumed` invocation.
* `seL4_SchedContext_Consumed` - Return the amount of time consumed by this scheduling
context since the last timeout fault, `YieldTo` or `Consumed` invocation.
* `seL4_TCB_SetTimeoutEndpoint` - Set the timeout fault endpoint for a TCB.

### Reply objects

The MCS API also makes the reply channel explicit: reply capabilities are now fully fledged objects
which must be provided by a thread on `seL4_Recv` operations. They are used to track the scheduling
context donation chain and return donated scheduling contexts to callers.

Please see the [release notes](https://docs.sel4.systems/sel4_release/seL4_9.0.0-mcs) and
[manual](https://docs.sel4.systems/sel4_release/seL4_9.0.0-mcs.html) for further details
 on the API changes.

## Exercises

In the initial state of the tutorial, the main function in `mcs.c` is running in one process, and the
following loop from `spinner.c` is running in another process:


```
    int i = 0;
    while (1) {
        printf("Yield\n");
        seL4_Yield();
    }
```

Both processes share the same priority. The code in `mcs.c` binds
a scheduling context (`sched_context`) to the TCB of the spinner process (`spinner_tcb)` with round-robin scheduling parameters. As a result, you should see
 something like the following output, which continues uninterrupted:

```
Yield
Yield
Yield
```

### Periodic threads

**Exercise** Reconfigure `sched_context` with the following periodic scheduling parameters,
 (budget = `0.9 * US_IN_S`, period = `1 * US_IN_S`).

 ```c
    //TODO reconfigure sched_context to be periodic
```
<details markdown='1'>
<summary style="display:list-item"><em>Quick solution</em></summary>
```c
    error = seL4_SchedControl_Configure(sched_control, sched_context, 0.9 * US_IN_S, 1 * US_IN_S, 0, 0);
    ZF_LOGF_IF(error != seL4_NoError, "Failed to configure schedcontext");
```
</details>


By completing this task successfully, the output will not change, but the rate that the output is
printed will slow: each subsequent line should be output once the period has elapsed. You should now
be able to see the loop where the `mcs.c` process and `spinner.c` process alternate, until the `mcs.c`
process blocks, at which point `"Yield"` is emitted by `spinner.c` every second, as shown below:

```
Yield
Tick 0
Yield
Tick 1
Yield
Tick 2
Yield
Tick 3
Yield
Tick 4
Yield
Tick 5
Yield
Tick 6
Yield
Tick 7
Yield
Tick 8
Yield
Yield
Yield
```
Before you completed this task, the scheduling context was round-robin, and so was
schedulable immediately after the call to `seL4_Yield`.
By changing
the scheduling parameters of `sched_context` to periodic parameters (budget < period), each time
`seL4_Yield()` is called the available budget in the scheduling context is abandoned, causing the
thread to sleep until the next replenishment, determined by the period.

### Unbinding scheduling contexts

You can cease a threads execution by unbinding the scheduling context.
Unlike *suspending* a thread via `seL4_TCB_Suspend`, unbinding will not change the thread state. Using suspend
cancels any system calls in process (e.g IPC) and renders the thread unschedulable by changing the
thread state. Unbinding a scheduling context does not alter the thread state, but merely removes the thread
from the scheduler queues.

**Exercise** Unbind `sched_context` to stop the spinner process from running.
```c
    //TODO unbind sched_context to stop yielding thread
```
<details markdown='1'>
<summary style="display:list-item"><em>Quick solution</em></summary>
```c
    error = seL4_SchedContext_Unbind(sched_context);
    ZF_LOGF_IF(error, "Failed to unbind sched_context");
```
</details>


On success, you should see the output from the yielding thread stop.

### Sporadic threads

Your next task is to use a different process, `sender` to experiment with sporadic tasks. The
`sender` process is ready to run, and just needs a scheduling context in order to do so.

**Exercise** First, bind `sched_context` to `sender_tcb`.

 ```c
    //TODO bind sched_context to sender_tcb
```
<details markdown='1'>
<summary style="display:list-item"><em>Quick solution</em></summary>
```c
    error = seL4_SchedContext_Bind(sched_context, sender_tcb);
    ZF_LOGF_IF(error != seL4_NoError, "Failed to bind schedcontext");
```
</details>

The output should look like the following:
```
...
Tock 3
Tock 4
Tock 5
Tock 6
```

Note the rate of the output: currently, you should see 2 lines come out at a time, with roughly
a second break between (the period of the scheduling context you set earlier). This is because
scheduling context only has the minimum sporadic refills (see background), and each time a context switch
occurs a refill is used up to schedule another.

**Exercise** Reconfigure the `sched_context` to an extra 6 refills, such that all of the `Tock` output
occurs in one go.

 ```c
    //TODO reconfigure sched_context to be periodic with 6 extra refills
```
<details markdown='1'>
<summary style="display:list-item"><em>Quick solution</em></summary>
```c
    error = seL4_SchedControl_Configure(sched_control, sched_context, 0.9 * US_IN_S, 1 * US_IN_S, 6, 0);
    ZF_LOGF_IF(error != seL4_NoError, "Failed to configure schedcontext");
```
</details>

### Passive servers

Now look to the third process, `server.c`, which is a very basic echo server. It currently does
not have a scheduling context, and needs one to initialise.

**Exercise** Bind `sched_context` to `server_tcb`.

 ```c
    //TODO bind sched_context to server_tcb
```
<details markdown='1'>
<summary style="display:list-item"><em>Quick solution</em></summary>
```c
    error = seL4_SchedContext_Bind(sched_context, server_tcb);
    ZF_LOGF_IF(error != seL4_NoError, "Failed to bind sched_context to server_tcb");
```
</details>


Now you should see the server initialise and echo the messages sent. Note the initialisation protocol:
first, you bound `sched_context` to the server. At this point, in `server.c`, the server calls
`seL4_NBSendRecv` which sends an IPC message on `endpoint`, indicating that the server is now initialised.
The output should be as follows

```
Tock 8
Starting server
Wait for server
Server initialising
running
passive
echo server
Yield
```

The following code then converts the server to passive:

```c
    // convert to passive
    error = seL4_SchedContext_Unbind(sched_context);
```

From this point, the server runs on the `mcs` process's scheduling context.

### Timeout Faults

But before we discuss timeout faults, we must first discuss the differences
between configuring a fault endpoint on the master vs the MCS kernel. There is a
minor difference in the way that the kernel is informed of the cap to a fault
endpoint, between the master and MCS kernels.

Regardless though, on both versions of the kernel, to inform the kernel of the
fault endpoint for a thread, call the usual `seL4_TCB_SetSpace()`.

#### Configuring a fault endpoint on the MCS kernel

On the MCS kernel the cap given to the kernel must be a cap to an object in
the CSpace of the thread which is *calling the syscall* (`seL4_TCB_Configure()`)
to give the cap to the kernel.

This calling thread may be the handler thread, or some other thread which
manages both the handler thread and the faulting thread. Or in an oddly designed
system, it might be the faulting thread itself if the faulting thread is allowed
to configure its own fault endpoint.

The reason for this difference is merely that it is faster to lookup the fault
endpoint this way since it is looked up only once at the time it is configured.

#### Configuring a fault endpoint on the Master kernel

On the Master kernel the cap given to the kernel must be a cap to an object in
the CSpace of the *faulting thread*.

On the Master kernel, the fault endpoint cap is looked up from within the CSpace
of the faulting thread everytime a fault occurs.

#### Exercise:

**Exercise** Set the data field of `sched_context` using `seL4_SchedControl_Configure` and set a 1s period, 500 &#181;s
budget and 0 extra refills.

```c
    // reconfigure sched_context with 1s period, 500 microsecond budget, 0 extra refills and data of 5.
```
<details markdown='1'>
<summary style="display:list-item"><em>Quick solution</em></summary>
```c
    error = seL4_SchedControl_Configure(sched_control, sched_context, 500, US_IN_S, 0, 5);
    ZF_LOGF_IF(error != seL4_NoError, "Failed to configure sched_context");
```
</details>
The code then binds the scheduling context back to `spinner_tcb`, which starts yielding again.

**Exercise** set the timeout fault endpoint for `spinner_tcb`.


```c
    //TODO set endpoint as the timeout fault handler for spinner_tcb
```
<details markdown='1'>
<summary style="display:list-item"><em>Quick solution</em></summary>
```c
```
</details>


When the `spinner` faults, you should see the following output:

```
Received timeout fault
Success!
```

### Further exercises

That's all for the detailed content of this tutorial. Below we list other ideas for exercises you can try,
to become more familiar with the MCS extensions.

* Set up a passive server with a timeout fault handlers, with policies for clients that exhaust their budget.
* Experiment with notification binding on a passive server, by binding both a notification object to the
server TCB and an SC to the notification object.

Next tutorial: <a href="../DynamicLibraries/initialisation">Dynamic libraries</a>
