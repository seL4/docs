---
redirect_from:
  - /BenchmarkingGuide
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Benchmarking Tools


We have developed a set of tools which can be used to analyse kernel and
workload performance. See the
[sel4bench-manifest](https://github.com/seL4/sel4bench-manifest) for the set of
microbenchmarks for seL4.


## CPU Utilisation
 Threads (including the idle thread) and the overall system time (in cycles) can
be tracked by enabling the "track CPU utilisation feature". This feature can be
enabled by setting the CMake configuration option `KernelConfiguration` to
`track_utilisation`.

By enabling CPU utilisation tracking, the kernel is instrumented with
some variables and functions to log the utilisation time for each thread
(thus TCBs have additional variables for this purpose); the in-kernel
buffer is not used. During each context switch, the kernel adds how long
this heir thread has run before being switched, and resets the start
time of the next thread.

### How to use


After enabling this feature, some few system calls can be used to start,
stop, and retrieve data.

**seL4_BenchmarkResetLog()** This system call resets global counters
(since the previous call to the same function) and idleThread counters
that hold utilisation values, and starts CPU utilisation tracking.

**seL4_BenchmarkResetThreadUtilisation(seL4_CPtr thread_cptr)**
resets the utilisation counters for the requested thread. It's the
resposibility of the user to reset the thread's counters using this
system call before calling seL4_BenchmarkResetLog(), especially if
seL4_BenchmarkResetLog() is called multiple times to track the same
thread(s).

**seL4_BenchmarkFinalizeLog()** Stops the CPU tracking feature but
doesn't reset the counters. Calling this system call without a previous
seL4_BenchmarkResetLog() call has no effect.

**seL4_BenchmarkGetThreadUtilisation(seL4_CPtr thread_cptr)** Gets
the utilisation time of the thread that **thread_cptr** capability
points to between calls to seL4_BenchmarkResetLog() and
seL4_BenchmarkFinalizeLog(). The utilisation time is dumped to the
IPCBuffer (first 64-bit word) of the calling thread into a fixed
position. Additionally idle thread and overall CPU utilisation times are
dumped to subsequent 64-bit words in the IPCBuffer.

Example code of using this feature:
```cpp
#include <sel4/benchmark_utilisation_types.h>

uint64_t *ipcbuffer = (uint64_t*) &(seL4_GetIPCBuffer()->msg[0]);

seL4_BenchmarkResetThreadUtilisation(seL4_CapInitThreadTCB);

seL4_BenchmarkResetLog();
...
seL4_BenchmarkFinalizeLog();

seL4_BenchmarkGetThreadUtilisation(seL4_CapInitThreadTCB);
printf("Init thread utilisation = %llun", ipcbuffer[BENCHMARK_TCB_UTILISATION]);
printf("Idle thread utilisation = %llun", ipcbuffer[BENCHMARK_IDLE_UTILISATION]);
printf("Overall utilisation = %llun", ipcbuffer[BENCHMARK_TOTAL_UTILISATION]);
```

## In kernel log-buffer


An in-kernel log buffer can be provided by the user when the `KernelBenchmarks`
CMake config option is set to `track_kernel_entries` or `tracepoints` with the
system call `seL4_BenchmarkSetLogBuffer`. Users must provide a large frame
capability for the kernel to use as a log buffer. This is mapped write-through
to avoid impacting the caches, assuming that the kernel only writes to the log
buffer and doesn't read to it during benchmarking. Once a benchmark is
complete, data can be read out at user level.

We provide several benchmarking tools that use the log buffer (trace
points and kernel entry tracking).

## Tracepoints
 We allow the user to specify tracepoints in the kernel
to track the time between points.

### How to use
 Set the `KernelBenchmarks` CMake config option to `tracepoints`. Then set the
`KernelMaxNumTracePoints` CMake config option to a non-zero value.

Wrap the regions you wish to time with TRACE_POINT_START(i) and
TRACE_POINT_STOP(i) where i is an integer from 0 to 1 less than the
value of "Maximum number of tracepoints".

The number of cycles consumed between a TRACE_POINT_START and
TRACE_POINT_STOP will be stored in an in-kernel log. Entries of this
log consist of a key (the argument to TRACE_POINT_START and
TRACE_POINT_STOP) and a value (the number of cycles counted between
TRACE_POINT_START an TRACE_POINT_STOP).

Functionality for extracting and processing entries from this buffer is
provided in libsel4bench (<https://github.com/seL4/libsel4bench>).

An example of this feature in use can be found in the irq path benchmark
in the sel4bench app(<https://github.com/seL4/libsel4bench>).

### Tracepoint Overhead

#### Measuring Overhead
Using tracepoints adds a small amount of overhead to the kernel. To measure
this overhead, use a pair of nested tracepoints:
```cpp
TRACE_POINT_START(0);
TRACE_POINT_START(1);
TRACE_POINT_STOP(1);
TRACE_POINT_STOP(0);
```
The outer tracepoints will measure the time taken to start and stop
the inner tracepoints. The cycle count recorded by the outer tracepoints
will be slightly skewed, as starting and stopping itself (the outer
tracepoints) takes some number of cycles. To determine how many, we look
to the inner tracepoints. Since this pair is empty, it will record the
number of cycles added to a result by the tracepoint instrumentation.
Thus, to compute the total overhead of starting and stopping a
tracepoint, subtract the values measured by the inner tracepoints from
those measured by the outer tracepoints.

#### Results
 All results are in cycles. Results were obtained using
the method described above. The total overhead is the number of cycles
added to execution per tracepoint start/stop pair (inner pair result
subtracted from outer pair result). The effective overhead is the number
of cycles added to a measurement by the tracepoint instrumentation
(inner pair result).

* Total Overhead

|Machine |# Samples |Min|Max|Mean|Variance|Std Dev|Std Dev %|
|-|-|-|-|-|-|-|-|
|Sabre|740|18|18|18|0|0|0%|
|Haswell2|740|532|852|550.33|295.16|17.19|3%|

* Effective overhead

|Machine |# Samples |Min|Max|Mean|Variance|Std Dev|Std Dev %|
|-|-|-|-|-|-|-|-|
|Sabre|740|4|4|4|0|0|0 |
|Haswell2|740|208|212|208.69|2.75|1.66|1% |


### Advanced Use
#### Conditional Logging
A log is stored when
TRACE_POINT_STOP(i) is called, only if a corresponding
TRACE_POINT_START(i) was called since the last call to
TRACE_POINT_STOP(i) or system boot. This allows for counting cycles of
a particular path through some region of code. Here are some examples:

The cycles consumed by functions f and g is logged with the key 0, only
when the condition c is true:
```cpp
TRACE_POINT_START(0);
f();
if (c) {
    g();
    TRACE_POINT_STOP(0);
}
```
The cycles consumed by functions f and g is
logged with the key 1, only when the condition c is true:
```cpp
if (c) {
    f();
    TRACE_POINT_START(1);
}
g();
TRACE_POINT_STOP(1);
```
These two techniques can be combined to
record cycle counts only when a particular path between 2 points is
followed. In the following example, cycles consumed by functions f, g
and h is logged, only when the condition c is true. Cycle counts are
stored with 2 keys (2 and 3) which can be combined after extracting the
data to user level.
```cpp
TRACE_POINT_START(2);
f();
if (c) {
    h();
    TRACE_POINT_STOP(2);
    TRACE_POINT_START(3);
}
g();
TRACE_POINT_STOP(3);
```
#### Interleaving/Nesting
It's possible to interleave tracepoints:
```cpp
TRACE_POINT_START(0);
...
TRACE_POINT_START(1);
...
TRACE_POINT_STOP(0);
...
TRACE_POINT_STOP(1);
```
and to nest tracepoints:
```cpp
TRACE_POINT_START(0);
...
TRACE_POINT_START(1);
...
TRACE_POINT_STOP(1);
...
TRACE_POINT_STOP(0);
```
When interleaving or nesting tracepoints, be
sure to account for the overhead that will be introduced.

## Kernel entry tracking
 Kernel entries can be tracked, registering info about interrupts, syscall,
timestamp, invocations and capability types. The number of kernel entries is
restricted by the log buffer size. The kernel provides a reserved area within
its address space to map the log buffer. It's the responsibility of the user to
allocate a user-level log buffer (currently can be only of seL4_LargePageBits
size) and pass it to the kernel to use before doing any operations that involve
the log buffer, otherwise an error will be triggered having incorrect
user-level log buffer. To enable this feature, set the `KernelBenchmarks` CMake
config option to `track_kernel_entries`.

An example how to create a user-level log buffer (using sel4 libraries)
and tell the kernel about it is as follows:
```cpp
#ifdef CONFIG_BENCHMARK_TRACK_KERNEL_ENTRIES

#include <sel4/benchmark_track_types.h>

  /* Create large page to use for benchmarking and give to kernel */
  void*log_buffer = vspace_new_pages(&env.vspace, seL4_AllRights, 1, seL4_LargePageBits);
  if (log_buffer == NULL) {
    ZF_LOGF("Could not map log_buffer page");
  }
  seL4_CPtr buffer_cap = vspace_get_cap(&env.vspace, log_buffer);
  if (buffer_cap == NULL) {
    ZF_LOGF("Could not get cap for log buffer");
  }
  int res_buf = seL4_BenchmarkSetLogBuffer(buffer_cap);
  if (res_buf) {
    ZF_LOGF("Could not set log buffer");
  }

#endif CONFIG_BENCHMARK_TRACK_KERNEL_ENTRIES
```

seL4_BenchmarkResetLog() can be used then to reset the log buffer index
and start tracking. To stop tracking, call seL4_BenchmarkFinalizeLog()
which returns the log buffer index. Note, if the buffer is
full/saturated, it will return the last entry index of the log buffer.
Finally, the log buffer can be analyzed to extract desired info. For
reference, there are utility functions to extract such information in
[sel4utils/benchmark_track.h](https://github.com/seL4/seL4_libs/blob/master/libsel4utils/include/sel4utils/benchmark_track.h).

### Hints
 If you want only entry or exit times instead of function
call durations, modify line 56 of kernel/include/benchmark.h. This might
be useful if you wish to time hardware events. For example, should you
wish to time how long it takes for hardware to generate a fault to the
kernel, perhaps record the cycle counter before causing the fault in
userspace, then store the `ksEntry` as soon as you enter somewhere
relevant in the kernel, and then compare the difference of these two
once you return to userspace, by reading out the value and taking the
difference.
