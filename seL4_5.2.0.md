# Introducing seL4 5.2.0
 Announcing the release of {{{seL4 5.2.0}}}
with the following changes:

Below are the changes to libsel4:

:   -   Add seL4\_FastMessageRegisters: Exposes number of registers used
        in IPC for more optimised user-level IPC stubs.
    -   Additional kernel entry types VMExit and VCPUFault added for
        bench-marking kernel entries.

x86 specific changes:

:   -   multiboot memory map information passed to user-level through
        bootinfo extended regions
    -   Expose more seL4 constants

# Upgrade notes


> -   This release potentially breaks ABI with the earlier versions if
>     using benchmarking kernel configurations.

# Full changelog


Use {{{git log 5.1.0..5.2.0}}} in <https://github.com/seL4/seL4>

# More details


See the
\[\[<http://sel4.systems/Info/Docs/seL4-manual-5.2.0.pdf%7C5.2.0>
manual\]\] included in the release or ask on the mailing list!
