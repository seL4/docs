= Benchmarking seL4 =
<<TableOfContents(2)>>

== Benchmarking project ==
There is a set of microbenchmarks for seL4 available, see the [[https://github.com/seL4/sel4bench-manifest|sel4bench-manifest]].

= Benchmarking Tools =
== In kernel log-buffer ==
We provide a 1MB buffer in the kernel when `CONFIG_TRACEPOINTS > 0`. This can be used to place information while the kernel is running. The buffer is write-through to optimise performance by minimising cache pollution, so if using the buffer make sure you do not read data back. Ideally, benchmarks that use the buffer should log one line at a time, sequentially, into the buffer for minimal performance impact while benchmarking.

Buffer data can be extracted via special benchmarking system calls to the kernel that copy the data out via the IPC buffer.

We provide several benchmarking tools that use the log buffer.

=== Caveats ===
On Sabre, Odroid-XU and Haswell platforms we

== Tracepoints ==
We allow the user to specify tracepoints in the kernel to track the time between points.

=== How to use ===
Set "Maximum number of tracepoints" in Kconfig (seL4 > seL4 System Parameters) to a non-zero value.

Wrap the regions you wish to time with TRACE_POINT_START(i) and TRACE_POINT_STOP(i) where i is an integer from 0 to 1 less than the value of "Maximum number of tracepoints".

The number of cycles consumed between a TRACE_POINT_START and TRACE_POINT_STOP will be stored in an in-kernel log. Entries of this log consist of a key (the argument to TRACE_POINT_START and TRACE_POINT_STOP) and a value (the number of cycles counted between TRACE_POINT_START an TRACE_POINT_STOP).

Functionality for extracting and processing entries from this buffer is provided in libsel4bench (https://github.com/seL4/libsel4bench).

An example of this feature in use can be found in the irq path benchmark in the sel4bench app(https://github.com/seL4/libsel4bench).

=== Tracepoint Overhead ===
==== Measuring Overhead ====
Using tracepoints adds a small amount of overhead to the kernel. To measure this overhead, use a pair of nested tracepoints:

{{{#!cplusplus numbers=off
TRACE_POINT_START(0);
TRACE_POINT_START(1);
TRACE_POINT_STOP(1);
TRACE_POINT_STOP(0);
}}}
The outer tracepoints will measure the time taken to start and stop the inner tracepoints. The cycle count recorded by the outer tracepoints will be slightly skewed, as starting and stopping itself (the outer tracepoints) takes some number of cycles. To determine how many, we look to the inner tracepoints. Since this pair is empty, it will record the number of cycles added to a result by the tracepoint instrumentation. Thus, to compute the total overhead of starting and stopping a tracepoint, subtract the values measured by the inner tracepoints from those measured by the outer tracepoints.

==== Results ====
All results are in cycles. Results were obtained using the method described above. The total overhead is the number of cycles added to execution per tracepoint start/stop pair (inner pair result subtracted from outer pair result). The effective overhead is the number of cycles added to a measurement by the tracepoint instrumentation (inner pair result).
||<tablestyle="margin-top:10px;margin-left:0px;overflow-x:auto;color:rgb(51, 51, 51);font-family:Arial, sans-serif;font-size:14px;line-height:20px;" tableclass="confluenceTable"#F0F0F0 class="confluenceTh" style="border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;white-space:pre-wrap;       ;text-align:center" |2>Machine ||<#F0F0F0 class="confluenceTh" style="border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;white-space:pre-wrap;       ;text-align:center" |2># Samples ||||||||||||<#F0F0F0 class="confluenceTh" style="border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;white-space:pre-wrap;       ;text-align:center">Total Overhead ||||||||||||<#F0F0F0 class="confluenceTh" style="border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;white-space:pre-wrap;       ;text-align:center">Effective Overhead ||
||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Min ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Max ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Mean ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Variance ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Std Dev ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Std Dev % ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Min ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Max ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Mean ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Variance ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Std Dev ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Std Dev % ||
||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Sabre ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">740 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">18 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">18 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">18 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">0 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">0 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">0% ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">4 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">4 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">4 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">0 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">0 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">0 ||
||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Haswell2 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">740 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">532 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">852 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">550.33 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">295.16 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">17.19 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">3% ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">208 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">212 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">208.69 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">2.75 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">1.66 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">1% ||




=== Advanced Use ===
==== Conditional Logging ====
A log is stored when TRACE_POINT_STOP(i) is called, only if a corresponding TRACE_POINT_START(i) was called since the last call to TRACE_POINT_STOP(i) or system boot. This allows for counting cycles of a particular path through some region of code. Here are some examples:

The cycles consumed by functions f and g is logged with the key 0, only when the condition c is true:

{{{#!cplusplus numbers=off
TRACE_POINT_START(0);
f();
if (c) {
   g();
   TRACE_POINT_STOP(0);
}
}}}
The cycles consumed by functions f and g is logged with the key 1, only when the condition c is true:

{{{#!cplusplus numbers=off
if (c) {
   f();
   TRACE_POINT_START(1);
}
g();
TRACE_POINT_STOP(1);
}}}
These two techniques can be combined to record cycle counts only when a particular path between 2 points is followed. In the following example, cycles consumed by functions f, g and h is logged, only when the condition c is true. Cycle counts are stored with 2 keys (2 and 3) which can be combined after extracting the data to user level.

{{{#!cplusplus numbers=off
TRACE_POINT_START(2);
f();
if (c) {
    h();
    TRACE_POINT_STOP(2);
    TRACE_POINT_START(3);
}
g();
TRACE_POINT_STOP(3);
}}}
==== Interleaving/Nesting ====
It's possible to interleave tracepoints:

{{{#!cplusplus numbers=off
TRACE_POINT_START(0);
...
TRACE_POINT_START(1);
...
TRACE_POINT_STOP(0);
...
TRACE_POINT_STOP(1);
}}}
and to nest tracepoints:

{{{#!cplusplus numbers=off
TRACE_POINT_START(0);
...
TRACE_POINT_START(1);
...
TRACE_POINT_STOP(1);
...
TRACE_POINT_STOP(0);
}}}
When interleaving or nesting tracepoints, be sure to account for the overhead that will be introduced.

== CPU Utilisation ==
Threads (including the idle thread) and the overall system time (in cycles) can be tracked by enabling the "track CPU utilisation feature". This feature can be enabled from the menuconfig list (seL4 Kernel > Enable benchmarks > Track threads and kernel CPU utilisation time).

By enabling CPU utilisation tracking, the kernel is instrumented with some variables and functions to log the utilisation time for each thread (thus TCBs have additional variables for this purpose); the in-kernel buffer is not used. During each context switch, the kernel adds how long this heir thread has run before being switched, and resets the start time of the next thread.

==== How to use ====

After enabling this feature, some few system calls can be used to start, stop, and retrieve data.

'''seL4_BenchmarkResetLog() ''' This system call resets global counters (since the previous call to the same function) and idleThread counters that hold utilisation values, and starts CPU utilisation tracking.

'''seL4_BenchmarkResetThreadUtilisation(seL4_CPtr thread_cptr)''' resets the utilisation counters for the requested thread. It's the resposibility of the user to reset the thread's counters using this system call before calling seL4_BenchmarkResetLog(), especially if seL4_BenchmarkResetLog() is called multiple times to track the same thread(s).

'''seL4_BenchmarkFinalizeLog()''' Stops the CPU tracking feature but doesn't reset the counters. Calling this system call without a previous seL4_BenchmarkResetLog() call has no effect.


'''seL4_BenchmarkGetThreadUtilisation(seL4_CPtr thread_cptr)''' Gets the utilisation time of the thread that '''thread_cptr '''capability points to between calls to seL4_BenchmarkResetLog() and seL4_BenchmarkFinalizeLog(). The utilisation time is dumped to the IPCBuffer (first 64-bit word) of the calling thread into a fixed position. Additionally idle thread and overall CPU utilisation times are dumped to subsequent 64-bit words in the IPCBuffer.

Example code of using this feature:

{{{#!cplusplus numbers=off
#include <sel4/benchmark_utilisation_types.h>

uint64_t *ipcbuffer = (uint64_t *) &(seL4_GetIPCBuffer()->msg[0]);

seL4_BenchmarkResetThreadUtilisation(seL4_CapInitThreadTCB);

seL4_BenchmarkResetLog();
...
seL4_BenchmarkFinalizeLog();

seL4_BenchmarkGetThreadUtilisation(seL4_CapInitThreadTCB);
printf("Init thread utilisation = %llu\n", ipcbuffer[BENCHMARK_TCB_UTILISATION]);
printf("Idle thread utilisation = %llu\n", ipcbuffer[BENCHMARK_IDLE_UTILISATION]);
printf("Overall utilisation = %llu\n", ipcbuffer[BENCHMARK_TOTAL_UTILISATION]);
}}}

=== Hints ===
If you want only entry or exit times instead of function call durations, modify line 56 of kernel/include/benchmark.h. This might be useful if you wish to time hardware events. For example, should you wish to time how long it takes for hardware to generate a fault to the kernel, perhaps record the cycle counter before causing the fault in userspace, then store the `ksEntry` as soon as you enter somewhere relevant in the kernel, and then compare the difference of these two once you return to userspace, by reading out the value and taking the difference.
