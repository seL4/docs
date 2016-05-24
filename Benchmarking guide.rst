= Benchmarking seL4 =
== In kernel log buffer ==
=== Caveats ===
Only works on Sabre, Odroid-XU and the Haswells at the moment.

=== How to use ===
Set "Maximum number of tracepoints" in Kconfig (seL4 > seL4 System Parameters) to a non-zero value.

Wrap the regions you wish to time with TRACE_POINT_START(i) and TRACE_POINT_STOP(i) where i is an integer from 0 to 1 less than the value of "Maximum number of tracepoints".

The number of cycles consumed between a TRACE_POINT_START and TRACE_POINT_STOP will be stored in an in-kernel log. Entries of this log consist of a key (the argument to TRACE_POINT_START and TRACE_POINT_STOP) and a value (the number of cycles counted between TRACE_POINT_START an TRACE_POINT_STOP).

Functionality for extracting and processing entries from this buffer is provided in libsel4bench (https://github.com/seL4/libsel4bench).

An example of this feature in use can be found in the irq path benchmark in the sel4bench app(https://github.com/seL4/libsel4bench).

=== Tracepoint Overhead ===
==== Measuring Overhead ====
Using tracepoints adds a small amount of overhead to the kernel. To measure this overhead, use a pair of nested tracepoints:

{{{
TRACE_POINT_START(0);
TRACE_POINT_START(1);
TRACE_POINT_STOP(1);
TRACE_POINT_STOP(0);
}}}
The outer tracepoints will measure the time taken to start and stop the inner tracepoints. The cycle count recorded by the outer tracepoints will be slightly skewed, as starting and stopping itself (the outer tracepoints) takes some number of cycles. To determine how many, we look to the inner tracepoints. Since this pair is empty, it will record the number of cycles added to a result by the tracepoint instrumentation. Thus, to compute the total overhead of starting and stopping a tracepoint, subtract the values measured by the inner tracepoints from those measured by the outer tracepoints.

==== Results ====
All results are in cycles. Results were obtained using the method described above. The total overhead is the number of cycles added to execution per tracepoint start/stop pair (inner pair result subtracted from outer pair result). The effective overhead is the number of cycles added to a measurement by the tracepoint instrumentation (inner pair result).
||<tablestyle="margin-top:10px;margin-left:0px;overflow-x:auto;color:rgb(51, 51, 51);font-family:Arial, sans-serif;font-size:14px;line-height:20px;" tableclass="confluenceTable"#F0F0F0 class="confluenceTh" style="border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;white-space:pre-wrap;   ;text-align:center" |2>Machine ||<#F0F0F0 class="confluenceTh" style="border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;white-space:pre-wrap;   ;text-align:center" |2># Samples ||||||||||||<#F0F0F0 class="confluenceTh" style="border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;white-space:pre-wrap;   ;text-align:center">Total Overhead ||||||||||||<#F0F0F0 class="confluenceTh" style="border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;white-space:pre-wrap;   ;text-align:center">Effective Overhead ||
||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Min ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Max ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Mean ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Variance ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Std Dev ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Std Dev % ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Min ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Max ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Mean ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Variance ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Std Dev ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Std Dev % ||
||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Sabre ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">740 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">18 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">18 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">18 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">0 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">0 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">0% ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">4 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">4 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">4 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">0 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">0 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">0 ||
||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">Haswell2 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">740 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">532 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">852 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">550.33 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">295.16 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">17.19 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">3% ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">208 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">212 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">208.69 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">2.75 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">1.66 ||<class="confluenceTd" style="white-space:pre-wrap;border-style:solid;border-color:rgb(221, 221, 221);padding:7px 10px;vertical-align:top;">1% ||




=== Advanced Use ===
==== Conditional Logging ====
A log is stored when TRACE_POINT_STOP(i) is called, only if a corresponding TRACE_POINT_START(i) was called since the last call to TRACE_POINT_STOP(i) or system boot. This allows for counting cycles of a particular path through some region of code. Here are some examples:

The cycles consumed by functions f and g is logged with the key 0, only when the condition c is true:

{{{
TRACE_POINT_START(0);
f();
if (c) {
   g();
   TRACE_POINT_STOP(0);
}
}}}

The cycles consumed by functions f and g is logged with the key 1, only when the condition c is true:

{{{
if (c) {
   f();
   TRACE_POINT_START(1);
}
g();
TRACE_POINT_STOP(1);
}}}

These two techniques can be combined to record cycle counts only when a particular path between 2 points is followed. In the following example, cycles consumed by functions f, g and h is logged, only when the condition c is true. Cycle counts are stored with 2 keys (2 and 3) which can be combined after extracting the data to user level.

{{{
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

{{{
TRACE_POINT_START(0);
...
TRACE_POINT_START(1);
...
TRACE_POINT_STOP(0);
...
TRACE_POINT_STOP(1);
}}}

and to nest tracepoints:

{{{
TRACE_POINT_START(0);
...
TRACE_POINT_START(1);
...
TRACE_POINT_STOP(1);
...
TRACE_POINT_STOP(0);
}}}

When interleaving or nesting tracepoints, be sure to account for the overhead that will be introduced.

=== Hints ===
If you want only entry or exit times instead of function call durations, modify line 56 of kernel/include/benchmark.h. This might be useful if you wish to time hardware events. For example, should you wish to time how long it takes for hardware to generate a fault to the kernel, perhaps record the cycle counter before causing the fault in userspace, then store the ksEntry as soon as you enter somewhere relevant in the kernel, and then compare the difference of these two once you return to userspace, by reading out the value and taking the difference.

== Running seL4 bench ==
TODO release sel4 bench, describe how to run
