= Introducing seL4 3.2.0 =

 * ARM Hypervisor support.
 * ARM Jetson-TK1: Cleanups and fixes.
 * Benchmarking now supports tracking of syscalls.
 * Support for XSAVE feature set for x86 CPUs.
 * Simplified ARM platform selection during configuration.


= Implementation improvements =

= API Changes =

 * No API changes in this release

= ABI Changes =
 
 * {{{seL4_BootInfo}}} has a new entry for IOSpace caps for ARM SMMU.

= Upgrade notes =

 * This release is source compatible. 

= Full changelog =

Use {{{git log 3.1.0..3.2.0}}} in https://github.com/seL4/seL4

= More details =

See the [[http://sel4.systems/Info/Docs/seL4-manual-3.2.0.pdf|3.2.0 manual]] included in the release for detailed descriptions
of the new features. Or ask on the mailing list!
