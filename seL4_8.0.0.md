# seL4 Version 8.0.0 Release
 Announcing the release of {{{seL4
8.0.0}}} with the following changes:

# Changes


:   -   Support for additional zynq platform Zynq UltraScale+ MPSoC
        (Xilinx ZCU102, ARMv8a, Cortex A53)
    -   Support for multiboot2 bootloaders on x86 (contributed change
        from Genode Labs)
    -   Deprecate seL4\_CapData\_t type and functions related to it
    -   A fastpath improvement means that when there are two runnable
        threads and the target thread is the highest priority

in the scheduler, the fastpath will be hit. Previously the fastpath
would not be used on IPC from a high priority thread to a low priority
thread. \* As a consequence of the above change, scheduling behaviour
has changed in the case where a non-blocking IPC is sent between two
same priority threads: the sender will be scheduled, rather than the
destination. \* Benchmarking support for armv8/aarch64 is now available.
\* Additional x86 extra bootinfo type for retrieving frame buffer
information from multiboot 2 \* Debugging option to export x86
Performance-Monitoring Counters to user level

# Upgrade notes


:   -   seL4\_CapData\_t should be replaced with just seL4\_Word.
        Construction of badges should just be x instead
        of seL4\_CapData\_Badge\_new(x) and guards should
        be seL4\_CNode\_CapData\_new(x, y) instead
        of seL4\_CapData\_Guard\_new(x, y)
    -   Code that relied on non-blocking IPC to switch between threads
        of the same priority may break.

# Full changelog
 Refer to the git log in
<https://github.com/seL4/seL4> using {{{git log 7.0.0..8.0.0}}}

# More details
 See the
\[\[<http://sel4.systems/Info/Docs/seL4-manual-8.0.0.pdf%7C8.0.0>
manual\]\] included in the release or ask on the mailing list!
