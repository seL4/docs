---
redirect_from:
  - /BenchmarkingGuide
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Benchmarking Tools

The [sel4bench-manifest](https://github.com/seL4/sel4bench-manifest) repository
collection provides a set of tools which can be used to analyse kernel and
workload performance. The use the kernel benchmarking extensions that can be
enabled via kernel build configuration option.

## CPU Utilisation

Threads, including the idle thread, and the overall system time can be tracked
by enabling the "track CPU utilisation feature". This feature can be enabled by
setting the CMake configuration option `KernelConfiguration` to
`track_utilisation`.

By enabling CPU utilisation tracking, the kernel is instrumented with variables
and functions to log the utilisation time for each thread in cycles.

This means TCB kernel objects gain additional fields and TCB size may increase
in benchmarking configurations in general and for `track_utlisation` in
particular. During each context switch, the kernel adds how long the current
thread has run before being switched, and resets the start time for the next
thread. The in-kernel buffer is not used for CPU utilisation tracking.

### How to use

After enabling this feature, new system calls can be used to start, stop, and
retrieve data.

#### `seL4_BenchmarkResetLog()`

This system call resets global counters as well as idle thread counters since
the previous call to the same function, and (re)starts CPU utilisation tracking.
It does not reset counters for individual threads.

#### `seL4_BenchmarkResetThreadUtilisation(seL4_CPtr thread_cptr)`

Resets the utilisation counters for the requested thread. It is the responsibility
of the user to reset the thread's counters using this system call before calling
`seL4_BenchmarkResetLog()`, especially if `seL4_BenchmarkResetLog()` is called
multiple times to track the same set of threads.

#### `seL4_BenchmarkFinalizeLog()`

Stops the CPU tracking feature but does not reset the counters. Performing this
system call without a previous `seL4_BenchmarkResetLog()` call has no effect.

#### `seL4_BenchmarkGetThreadUtilisation(seL4_CPtr thread_cptr)`

Gets the utilisation time of the thread that `thread_cptr` capability points to
between calls to `seL4_BenchmarkResetLog()` and `seL4_BenchmarkFinalizeLog()`.
The utilisation time is written to the first 64-bit word of IPC buffer of the
calling thread. The idle thread and overall CPU utilisation times are written to
the subsequent 64-bit words in the IPCBuffer.

Example code of using this feature:

```c
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

## In-kernel log buffer

An in-kernel log buffer can be provided by the user when the `KernelBenchmarks`
CMake config option is set to `track_kernel_entries` or `tracepoints` with the
system call `seL4_BenchmarkSetLogBuffer`. Users must provide a capability to a
large frame for the kernel to use as a log buffer. The frame will be mapped
write-through to avoid impacting the caches. The kernel only writes to the log
buffer and does not read from it during benchmarking. Once a benchmark is
complete, data can be read out at user level.

The trace-points and kernel-entry tracking features of the `sel4bench` suite use
the in-kernel log buffer.

## Tracepoints

These allow the user to specify tracepoints in the kernel to track the time
between points.

### How to use

Set the `KernelBenchmarks` CMake config option to `tracepoints`. Then set the
`KernelMaxNumTracePoints` CMake config option to a non-zero value.

Wrap the regions you wish to time with `TRACE_POINT_START(i)` and
`TRACE_POINT_STOP(i)` where `i` is an integer from 0 to less than the value of
"Maximum number of tracepoints".

The number of cycles consumed between a `TRACE_POINT_START` and
`TRACE_POINT_STOP` will be stored in an in-kernel log. Entries of this
log consist of a key (the argument to `TRACE_POINT_START` and
`TRACE_POINT_STOP`) and a value (the number of cycles counted between
`TRACE_POINT_START` and `TRACE_POINT_STOP`).

Functionality for extracting and processing entries from this buffer is provided
in `libsel4bench` located in
[seL4/seL4_libs](https://github.com/seL4/seL4_libs).

An example of this feature in use can be found in the IRQ path benchmark
in [sel4bench](https://github.com/seL4/sel4bench/blob/master/apps/irq/src/main.c).

### Tracepoint Overhead

#### Measuring Overhead

Using tracepoints adds a small amount of overhead to the kernel. To measure
this overhead, use a pair of nested tracepoints:

```c
TRACE_POINT_START(0);
TRACE_POINT_START(1);
TRACE_POINT_STOP(1);
TRACE_POINT_STOP(0);
```

The outer tracepoints will measure the time taken to start and stop the inner
tracepoints. The cycle count recorded by the outer tracepoints will be slightly
skewed, as starting and stopping itself (the outer tracepoints) takes some
number of cycles. To determine how many, we look to the inner tracepoints. Since
this pair is empty, it will record the number of cycles added to a result by the
tracepoint instrumentation. Thus, to compute the total overhead of starting and
stopping a tracepoint, subtract the values measured by the inner tracepoints
from those measured by the outer tracepoints.

#### Results

All results are in cycles. Results were obtained using the method described
above. The total overhead is the number of cycles added to execution per
tracepoint start/stop pair (inner pair result subtracted from outer pair
result). The effective overhead is the number of cycles added to a measurement
by the tracepoint instrumentation (inner pair result).

##### **Total Overhead**

<div class="overflow-x-auto" markdown="1">
|Machine |# Samples |Min|Max|Mean|Std Dev|Std Dev %|
|-|-|-|-|-|-|-|-|
|Sabre|740|18|18|18|0|0%|
|Haswell2|740|532|852|550.33|17.19|3%|

</div>

##### **Effective overhead**

<div class="overflow-x-auto" markdown="1">
|Machine |# Samples |Min|Max|Mean|Std Dev|Std Dev %|
|-|-|-|-|-|-|-|-|
|Sabre|740|4|4|4|0|0 |
|Haswell2|740|208|212|208.69|1.66|1% |

</div>

### Advanced Use

#### Conditional Logging

A log is stored when `TRACE_POINT_STOP(i)` is called, only if a corresponding
`TRACE_POINT_START(i)` was called since the last call to `TRACE_POINT_STOP(i)`
or system boot. This allows for counting cycles of a particular path through
some region of code. Here are some examples:

The cycles consumed by functions `f` and `g` are logged with the key 0, only
when the condition `c` is true:

```c
TRACE_POINT_START(0);
f();
if (c) {
    g();
    TRACE_POINT_STOP(0);
}
```

The cycles consumed by functions `f` and `g` are
logged with the key 1, only when the condition `c` is true:

```c
if (c) {
    f();
    TRACE_POINT_START(1);
}
g();
TRACE_POINT_STOP(1);
```

These two techniques can be combined to record cycle counts only when a
particular path between 2 points is followed. In the following example, cycles
consumed by functions `f`, `g` and `h` are logged, only when the condition `c`
is true. Cycle counts are stored with 2 keys (2 and 3) which can be combined
after extracting the data to user level.

```c
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

```c
TRACE_POINT_START(0);
...
TRACE_POINT_START(1);
...
TRACE_POINT_STOP(0);
...
TRACE_POINT_STOP(1);
```

and to nest tracepoints:

```c
TRACE_POINT_START(0);
...
TRACE_POINT_START(1);
...
TRACE_POINT_STOP(1);
...
TRACE_POINT_STOP(0);
```

When interleaving or nesting tracepoints, be sure to account for the overhead
that will be introduced.

## Kernel entry tracking

Kernel entries can be tracked, registering info about interrupts, syscall,
timestamp, invocations and capability types. The number of kernel entries is
restricted by the log buffer size. The kernel provides a reserved area within
its address space to map the log buffer. It is the responsibility of the user to
allocate a user-level log buffer (currently can be only of seL4_LargePageBits
size) and pass it to the kernel to use before doing any operations that involve
the log buffer, otherwise an error will be triggered. To enable this feature,
set the `KernelBenchmarks` CMake config option to `track_kernel_entries`.

An example how to create a user-level log buffer (using the seL4 libraries) and
tell the kernel about it is as follows:

```c
#ifdef CONFIG_BENCHMARK_TRACK_KERNEL_ENTRIES

#include <sel4/benchmark_track_types.h>

  /* Create large page to use for benchmarking and give to kernel */
  void* log_buffer = vspace_new_pages(&env.vspace, seL4_AllRights, 1, seL4_LargePageBits);
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

`seL4_BenchmarkResetLog()` can be used to reset the log buffer index and start
tracking. To stop tracking, call `seL4_BenchmarkFinalizeLog()` which returns the
log buffer index. Note that, if the buffer is full/saturated, it will return the
last entry index of the log buffer. Finally, the log buffer can be analysed to
extract desired info. For reference, there are utility functions to extract such
information in
[sel4utils/benchmark_track.h](https://github.com/seL4/seL4_libs/blob/master/libsel4utils/include/sel4utils/benchmark_track.h).

### Hints

If you want only entry or exit times instead of function call durations, modify
[line
63](https://github.com/seL4/seL4/blob/b63043c41a5db1f64253ea98b104eab54c256c56/include/benchmark/benchmark.h#L63)
of `include/benchmark.h` in function `trace_point_stop` in the kernel. This
might be useful if you wish to time hardware events. For example, should you
wish to time how long it takes for hardware to generate a fault to the kernel,
perhaps record the cycle counter before causing the fault in userspace, then
store the `ksEntry` as soon as you enter somewhere relevant in the kernel, and
then compare the difference of these two once you return to userspace.
