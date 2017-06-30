= seL4 Version 6.0.0 Release =

Announcing the release of {{{seL4 6.0.0}}} with the following changes:

== Highlights ==

=== ARM 32-bit Multicore ===
 

=== ARM FPU ===


== Changes ==

* 


= Upgrade notes =

 * This release is not source compatible with previous releases.
 * seL4_DebugDumpScheduler has had its only argument removed as it was unused.
 * On x86 some structs in the Bootinfo have been rearranged.  This only affects seL4_VBEModeInfoBlock_t which is used if VESA BIOS Extensions (VBE) information is being used.


= Full changelog =

Use {{{git log 5.2.0..6.0.0}}} in https://github.com/seL4/seL4

= More details =

See the [[http://sel4.systems/Info/Docs/seL4-manual-6.0.0.pdf|6.0.0 manual]] included in the release or ask on the mailing list!
