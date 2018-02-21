= seL4 3.0.0 Release Notes = This release is a minor release that brings
structural improvements to the kernel in preparation for 64bit
architecture support. Although changes do break the API, the breakages
are small (see API Changes and API Removals below) and should not effect
most users.

== Implementation improvements ==

:   -   python3 compatability for our python scripts.
    -   more source code restructuring in preparation for 64-bit ports
        of seL4
    -   idle thread is run in system mode for all ARM platforms except
        for the KZM11.
    -   more work to remove duplication between libsel4 and kernel.

== API Additions ==

:   -   seL4\_IRQControl\_GetIOAPIC for x86.
    -   seL4\_IRQControl\_GetMSI for x86.

== API Changes ==

:   -   Total number of ASIDs for x86 reduced from 2\^16\^ to 2\^12\^
        (max ASID 2\^12\^).
    -   seL4\_BootInfo struct: userImagePDs and userImagePTs combined
        into userImagePaging in preparation for multilevel paging
        structures for 64 bit kernel support.
    -   Diminish rights removed from IPC

== API Removals ==

:   -   seL4\_IRQ\_SetMode removed (This only effects users who use the
        IOAPIC on x86, which is turned off by default).

== API deprecations ==

:   -   seL4\_IA32\_PageDirectory\_Map deprecated for
        seL4\_X86\_PageDirectory\_Map
    -   seL4\_IA32\_PageDirectory\_Unmap deprecated for
        seL4\_X86\_PageDirectory\_Unmap
    -   seL4\_IA32\_PageTable\_Map deprecated for
        seL4\_X86\_PageTable\_Map
    -   seL4\_IA32\_PageTable\_Unmap deprecated for
        seL4\_X86\_PageTable\_Unmap
    -   seL4\_IA32\_IOPageTable\_Map deprecated for
        seL4\_X86\_IOPageTable\_Map
    -   seL4\_IA32\_IOPageTable\_Unmap deprecated for
        seL4\_X86\_IOPageTable\_Unmap
    -   seL4\_IA32\_IOPageTable\_Map deprecated for
        seL4\_X86\_IOPageTable\_Map
    -   seL4\_IA32\_IOPageTable\_Unmap deprecated for
        seL4\_X86\_IOPageTable\_Unmap
    -   seL4\_IA32\_Page\_Map deprecated for seL4\_X86\_Page\_Map
    -   seL4\_IA32\_Page\_Unmap deprecated for seL4\_X86\_Page\_Unmap
    -   seL4\_IA32\_Page\_Remap deprecated for seL4\_X86\_Page\_Remap
    -   seL4\_IA32\_Page\_MapIO deprecated for seL4\_X86\_Page\_MapIO
    -   seL4\_IA32\_Page\_GetAddress deprecated for
        seL4\_X86\_Page\_GetAddress
    -   seL4\_IA32\_ASIDControl\_MakePool deprecated for
        seL4\_X86\_ASIDControl\_MakePool
    -   seL4\_IA32\_ASIDPool\_Assign deprecated for
        seL4\_X86\_ASIDPool\_Assign
    -   seL4\_IA32\_IOPort\_In8 deprecated for seL4\_X86\_IOPort\_In8
    -   seL4\_IA32\_IOPort\_In16 deprecated for seL4\_X86\_IOPort\_In16
    -   seL4\_IA32\_IOPort\_In32 deprecated for seL4\_X86\_IOPort\_In32
    -   seL4\_IA32\_IOPort\_Out8 deprecated for seL4\_X86\_IOPort\_Out8
    -   seL4\_IA32\_IOPort\_Out16 deprecated for
        seL4\_X86\_IOPort\_Out16
    -   seL4\_IA32\_IOPort\_Out32 deprecated for
        seL4\_X86\_IOPort\_Out32
    -   seL4\_IA32\_4K deprecated for seL4\_X86\_4K
    -   seL4\_IA32\_LargePage deprecated for seL4\_X86\_LargePageObject
    -   seL4\_IA32\_PageTableObject deprecated for
        seL4\_X86\_PageTableObject
    -   seL4\_IA32\_PageDirectoryObject deprecated for
        seL4\_X86\_PageDirectoryObject
    -   seL4\_IA32\_IOPageTableObject deprecated for
        seL4\_X86\_IOPageTableObject
    -   seL4\_IA32\_ASIDControl deprecated for seL4\_X86\_ASIDControl
    -   seL4\_IA32\_ASIDPool deprecated for seL4\_X86\_ASIDPool
    -   seL4\_IA32\_IOSpace deprecated for seL4\_X86\_IOSpace
    -   seL4\_IA32\_IOPort deprecated for seL4\_X86\_IOPort
    -   seL4\_IA32\_Page deprecated for seL4\_X86\_Page
    -   seL4\_IA32\_PDPT deprecated for seL4\_X86\_PDPT
    -   seL4\_IA32\_PageDirectory deprecated for
        seL4\_X86\_PageDirectory
    -   seL4\_IA32\_PageTable deprecated for seL4\_X86\_PageTable
    -   seL4\_IA32\_IOPageTable deprecated for seL4\_X86\_IOPageTable
    -   seL4\_IA32\_Default\_VMAttributes deprecated for
        seL4\_X86\_Default\_VMAttributes
    -   seL4\_IA32\_WriteBack deprecated for seL4\_X86\_WriteBack
    -   seL4\_IA32\_WriteThrough deprecated for seL4\_X86\_WriteThrough
    -   seL4\_IA32\_CacheDisabled deprecated for
        seL4\_X86\_CacheDisabled
    -   seL4\_IA32\_Uncacheable  deprecated for \`
        seL4\_X86\_Uncacheable \`
    -   seL4\_IA32\_WriteCombining deprecated for
        seL4\_X86\_WriteCombining
    -   seL4\_IA32\_VMAttributes deprecated for seL4\_X86\_VMAttributes

== Upgrade notes == This change is not source or binary compatible.

Users will need to remove calls to seL4\_IRQ\_SetMode, and upgrade any
manual parsing of seL4\_BootInfo.

== Full changelog == Use git log 2.1.0..3.0.0
