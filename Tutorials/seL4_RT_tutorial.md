---
toc: true
---

# seL4 5.2.0-MCS Tutorial


This tutorial demonstrates how to use the real-time features of the MCS
kernel API, it covers enough such that if you have already done the seL4
tutorials for master and are familiar with the API, you do not need to
redo the previous ones. As a result is does duplicate some of the work
from the other tutorials, but not all.

You'll observe that the things you've already covered in the other
tutorials are already filled out and you don't have to repeat them: in
much the same way, we won't be repeating conceptual explanations on this
page, if they were covered by a previous tutorial in the series.

## Learning outcomes


- Obtain scheduling control capabilities.
- Create and configure scheduling contexts.
- Spawn round-robin and periodic threads.
- Set up a passive server.
- Set up clients to call the passive server using the immediate
      priority ceiling protocol.

## Walkthrough


This tutorial is currently stored separately from the other tutorials.
To get the code:
```
mkdir sel4-mcs-tutorials
cd sel4-mcs-tutorials repo
init -u <https://github.com/SEL4PROJ/sel4-tutorials-manifest> -m sel4-mcs-tutorials.xml
repo sync
```

Then, build and run the tutorial:
```
# select the config for the first tutorial
make ia32_hello-mcs_defconfig
# build it
make -j8
# run it in qemu
make simulate
```

Before you have done any tasks, when running the tutorial should produce
the following before halting:
```
mcs <main@main.c>:179 [Cond failed: sched_control == seL4_CapNull]
    Failed to find sched_control.
```

Look for `TASK` in the `apps/hello-mcs` directory for each task.

### TASK 1
 Find the scheduling control capability. There is one per
node in the system. This allows you to populate scheduling contexts with
parameters.

The output will now look like this:
```
=== Round robin ===
Ping 0
Ping 1
Ping 2
Ping 3
Ping 4
=== Just Ping ===
Ping
Ping
Ping
Ping
Ping
=== Periodic ===
Tick
Tick
Tick
Tick
Tick
Tick
Tick
Tick
Tick
Tick
== Sporadic ==
```

### TASK 2
 Create a scheduling context. The simplest way is to use
the VKA interface. TODO add size.

The output will not change, as we have not given the scheduling context
any time to use. When they are created, scheduling contexts are
''empty'' and represent no CPU time.

Scheduling contexts are variable sized in order to allow custom maximum
sizes for the refill list. This is discussed in more detail in TASK 7.
The minimum size for a scheduling context is `seL4_MinSchedContextBits`.

### TASK 3


Configure the scheduling context as a round robin thread using the
sched_control capability obtained in TASK 2 and the scheduling context
created in TASK 1.

Once you have reached this point, the tutorial output should change. You
should now see the `yielding_thread` that we created outputting messages
in between our own messages, as both threads yield to each other.
```
=== Round robin ===
Ping 0
Pong 0
Ping 1
Pong 1
Ping 2
Pong 2
Ping 3
Pong 3
Ping 4
Pong 4
=== Just Ping ===
Ping
Pong 5
Ping
Pong 6
Ping
Pong 7
Ping
Pong 8
Ping
Pong 9
=== Periodic ===
Pong 10
Pong 11
Pong 12
Pong 13
Pong 14
Pong 15
mcs <yielding_thread@main.c>:87 [Cond failed: i > NUM_YIELDS * 3]
    Too many yeilds!
```

### TASK 4


Note that in the previous output, while the Round robin section worked,
the ''Just Ping'' section did not. The `yielding_thread` is set to call
abort if it runs for too long.

To fix this, convert the round robin thread to passive by unbinding the
scheduling context. Passive threads do not have their own time. This
will stop the round robin thread from running and the output will be as
follows:
```
=== Round robin ===
Ping 0
Pong 0
Ping 1
Pong 1
Ping 2
Pong 2
Ping 3
Pong 3
Ping 4
Pong 4
=== Just Ping ===
Ping
Ping
Ping
Ping
Ping
=== Periodic ===
Tick
Tick
Tick
Tick
Tick
Tick
Tick
Tick
Tick
Tick
== Sporadic ==
```

### TASK 5


Reconfigure the scheduling context to be periodic. The output should not
change as the scheduling context is still unbound.

### TASK 6


Rebind the scheduling context to the thread. Altering scheduling context
state has no impact on the state of the TCB, so it will start where it
left off. No you should see the periodic thread waking every 2 seconds
and printing:
```
=== Round robin ===
Ping 0
Pong 0
Ping 1
Pong 1
Ping 2
Pong 2
Ping 3
Pong 3
Ping 4
Pong 4
=== Just Ping ===
Ping
Ping
Ping
Ping
Ping
=== Periodic ===
Pong 5
Tick
Tick
Pong 6
Tick
Tick
Pong 7
Tick
Tick
Pong 8
Tick
Tick
Pong 9
Tick
Tick
Pong 10
== Sporadic ==
42
0
49
1
56
2
63
3
70
4
76
5
83
6
90
7
97
8
104
Waiting for server
echo:
<<seL4(CPU 0) [decodeInvocation/578 T0xe0295500 "helper_thread" @8049746]: Attempted to invoke a null cap #0.>>
<<seL4(CPU 0) [lookupReply/318 T0xe0295500 "helper_thread" @8049746]: Cap in reply slot is not a reply>>
Caught cap fault in send phase at address 0x0
while trying to handle:
cap fault in receive phase at address 0x0
in thread 0xe0295500 "helper_thread" at address 0x8049746
With stack:
0x10075f2c: 0x10075f5c
0x10075f30: 0x806ef46
0x10075f34: 0x10075f5c
0x10075f38: 0x0
0x10075f3c: 0x0
0x10075f40: 0x0
0x10075f44: 0x0
0x10075f48: 0x0
0x10075f4c: 0x0
0x10075f50: 0x0
0x10075f54: 0x0
0x10075f58: 0x0
0x10075f5c: 0x0
0x10075f60: 0x0
0x10075f64: 0x0
0x10075f68: 0x0
```

### TASK 7


Now we reconfigure the scheduling context to change the extra_refills
parameter. Extra_refills controls how many times the scheduling context
can change for a non-round robin thread without using up all of its
budget. The current scheduling context is changed when a thread is
preempted, blocks, or makes an RPC to an active thread (a thread that
has its own scheduling context).

For further detail, please see
[this paper](https://www.cs.fsu.edu/~awang/papers/rtas2010.pdf)
which explains in detail the sporadic server algorithm the MCS version
of seL4 uses to implement temporal isolation. Note that in code, we use
the term `refill` to talk about sporadic replenishments for brevity.

The `sender_thread` used in this task simply sends a message and prints
out the number of times it has sent one. The main thread keeps sending
messages, and prints out the current time (in seconds -- although on
qemu these values are not reliable so may not match your output). This
causes the current scheduling context to change every time we switch
threads.

Once this task is completed, you should see the sporadic thread print 3
times (1 for the default refill, 2 for the extra refills) before
depleting its budget (by running out of space for refills) until the
next period. Prior to this change, there should be a gap between each
number printed by the task, and the timestamp should change. Now there
should only be a noticeable wait after every 3 numbers, and no gaps in
the timestamps for each set of three numbers.
```
=== Round robin ===
Ping 0
Pong 0
Ping 1
Pong 1
Ping 2
Pong 2
Ping 3
Pong 3
Ping 4
Pong 4
=== Just Ping ===
Ping
Ping
Ping
Ping
Ping
=== Periodic ===
Pong 5
Tick
Tick
Pong 6
Tick
Tick
Pong 7
Tick
Tick
Pong 8
Tick
Tick
Pong 9
Tick
Tick
Pong 10
== Sporadic ==
42
0
42
1
42
2
49
3
49
4
49
5
56
6
56
7
56
8
63
Waiting for server
echo:
<<seL4(CPU 0) [decodeInvocation/578 T0xe0295500 "helper_thread" @80497a6]: Attempted to invoke a null cap #0.>>
<<seL4(CPU 0) [lookupReply/318 T0xe0295500 "helper_thread" @80497a6]: Cap in reply slot is not a reply>>
Caught cap fault in send phase at address 0x0
while trying to handle:
cap fault in receive phase at address 0x0
in thread 0xe0295500 "helper_thread" at address 0x80497a6
With stack:
0x10075f2c: 0x10075f5c
0x10075f30: 0x806efa6
0x10075f34: 0x10075f5c
0x10075f38: 0x0
0x10075f3c: 0x0
0x10075f40: 0x0
0x10075f44: 0x0
0x10075f48: 0x0
0x10075f4c: 0x0
0x10075f50: 0x0
0x10075f54: 0x0
0x10075f58: 0x0
0x10075f5c: 0x0
0x10075f60: 0x0
0x10075f64: 0x0
0x10075f68: 0x0
```

### TASK 8


You'll notice an exception in the output of the last run. This is
because we restart our helper thread as an echo server, and pass it an
endpoint and a capability to a reply object. However, since this task is
to create a reply cap the echo server faults instead.

Reply objects are used to track scheduling contexts across call and
reply wait. For users of other versions of seL4, they also simplify the
kernel API, in that the single-use reply capability is generated in the
reply object, which means there is no longer any requirement to make a
specific call to save the reply capability.

This task is to create a reply object, which will stop the echo server
from faulting.
```
=== Round robin ===
Ping 0
Pong 0
Ping 1
Pong 1
Ping 2
Pong 2
Ping 3
Pong 3
Ping 4
Pong 4
=== Just Ping ===
Ping
Ping
Ping
Ping
Ping
=== Periodic ===
Pong 5
Tick
Tick
Pong 6
Tick
Tick
Pong 7
Tick
Tick
Pong 8
Tick
Tick
Pong 9
Tick
Tick
Pong 10
== Sporadic ==
42
0
42
1
42
2
49
3
49
4
49
5
56
6
56
7
56
8
63
Waiting for server
echo:
```
=== TASK 9 ===

The echo server no longer crashes, instead it runs a very inefficient
way IPC echo server as an example passive server for this tutorial.
Currently the main thread waits for a signal from the server that it is
initialised and ready to be converted to passive.

This task is to edit the server (`echo_server`) function to signal to the
main thread that it is ready to be converted to passive. Once the main
thread gets this message, it deletes the servers scheduling context and
makes a call to the server. Passive threads do not have their own
scheduling context and run on the scheduling context of the caller - but
only if they are blocked on and IPC endpoint.

The main thread calls the server 3 times with different messages, so you
should see the passive server output 3 messages:
```
=== Round robin ===
Ping 0
Pong 0
Ping 1
Pong 1
Ping 2
Pong 2
Ping 3
Pong 3
Ping 4
Pong 4
=== Just Ping ===
Ping
Ping
Ping
Ping
Ping
=== Periodic ===
Pong 5
Tick
Tick
Pong 6
Tick
Tick
Pong 7
Tick
Tick
Pong 8
Tick
Tick
Pong 9
Tick
Tick
Pong 10
== Sporadic ==
42
0
42
1
42
2
49
3
49
4
49
5
56
6
56
7
56
8
63
Waiting for server
echo:
echo: 2nd message processed
echo: mcs tutorial finished!
```

## Finished!


You're done. Please enjoy experimenting with the pre-release MCS version
of seL4. Recall that this version is currently undergoing verification,
but is not yet verified - meaning it can crash. If it does please let us
know by raising an issue on the
[seL4 Github](https://github.com/seL4/seL4/issues).

We welcome your feedback and comments, hit us up on the developers
mailing list: <https://sel4.systems/lists/listinfo/devel>.
