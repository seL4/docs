= seL4 2.1.0 Release Notes = == New Features ==

> -   ability to generate libsel4 system calls without inlining them
> -   new kernel debugging feature added, which allows developers to
>     call debug\_printKernelEntryReason anywhere in the kernel which
>     will output the entry reason and relevant arguments.

== Implementation improvements ==

> -   Some duplication between kernel and libsel4 removed.
> -   Many changes refactoring the x86 code base in preparation for the
>     upcoming x86\_64 platform port.

== API Additions ==

> -   seL4\_MappingFailedLookupLevel() - get the page table level a
>     frame mapping failed at. This will always return 2 (second level
>     page table) for currently supported 32 bit platforms.
> -   seL4\_NumInitialCaps constant added to bootinfo.h to track the
>     first free slot in the initial task's cspace.

== Upgrade notes ==

Source compatible, some API additions.

== Full changelog ==

Use git log 2.0.0..2.1.0
