= Introducing seL4 5.0.0 = Announcing the release of {{{seL4 5.0.0}}}
with the following changes:

Below are the changes to the seL4 ABI and API: Generic changes: \* Add
missing case to seL4\_getFault (seL4\_Fault\_DebugException) \*
Explicitly pack bootinfo data structures \* Modify FinalizeLog syscall -
Now returns a number of entries in the log \* Extend bootinfo to support
potentially arbitrary additional structures \* Deprecate bootinfo
management in libsel4 - a replacement, platsupport\_get\_bootinfo can be
found in libsel4platsupport

x86 specific changes:

:   -   Pass VBE information from multiboot through bootinfo
    -   Remove PAE support

x86-64 specific changes:

:   -   VT-x related cap and object definitions added
    -   seL4\_VMEnter syscall added

arm specific changes:

:   -   ARM-HYP: VCPU interface for manipulating banked registers added
    -   plat: added nvidia tx1 support
    -   ARM-HYP: Add support for save/restore of debug registers
    -   Add aarch64 implementation

= Upgrade notes =

> -   This release breaks both API and ABI and is not source compatible
>     with the earlier versions.

= Full changelog =

Use {{{git log 4.0.0..5.0.0}}} in <https://github.com/seL4/seL4>

= More details =

See the
\[\[<http://sel4.systems/Info/Docs/seL4-manual-5.0.0.pdf%7C5.0.0>
manual\]\] included in the release for detailed descriptions of the new
features. Or ask on the mailing list!
