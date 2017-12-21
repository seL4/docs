= Status of new and future seL4 features and projects =

This page tracks the status of various seL4 platform features that are in progress or not yet started (i.e. planned).

For status of existing kernel ports, features, drivers, and other userland components, see:
 * [[Hardware]]: for hardware platform ports
 * [[Kernel Features]]: for kernel features
 * [[Userland Components and Drivers]]: for device driver and userland components


== Kernel Features ==

||'''Feature'''||'''Status'''||'''Driven by'''||'''Repo'''||'''Comment'''||
|| AArch64 kernel || in development (released) || [[mailto:devel@sel4.systems|D61]] || https://github.com/seL4/seL4 || being developed on NVIDIA TX1 ||
|| AArch64 hyp || in development (unreleased) || [[mailto:devel@sel4.systems|D61]] || || being developed on NVIDIA TX1 ||
|| MCS kernel || in development || [[mailto:devel@sel4.systems|D61]] || || being developed for x32 and AArch32 on all supported platforms (?)||
|| SMP kernel || in development (released) || [[mailto:devel@sel4.systems|D61]] || https://github.com/seL4/seL4 || being developed for x32 and AArch32 on all supported platforms (?)||

== Kernel hardware platform ports ==

||'''Feature'''||'''Status'''||'''Driven by'''||'''Repo'''||'''Comment'''||
|| NVIDIA TX1 || in development (released) || [[mailto:devel@sel4.systems|D61]] || https://github.com/seL4/seL4 || AArch64 only ? ||
|| NVIDIA TX1 SMMU || planned || [[mailto:devel@sel4.systems|D61]] || || AArch64 only ? ||

== CAmkES Features ==

||'''Feature'''||'''Status'''||'''Driven by'''||'''Repo'''||'''Comment'''||
|| CAmkES AArch64 || planned || [[mailto:devel@sel4.systems|D61]] || || ||
|| CAmkES AArch64 & hyp || planned || [[mailto:devel@sel4.systems|D61]] || || ||


== Virtualisation ==

||'''Feature'''||'''Status'''||'''Driven by'''||'''Repo'''||'''Comment'''||
|| camkes-arm-vmm for AArch64 || planned || [[mailto:devel@sel4.systems|D61]] || || Including libsel4arm-vmm for AArch64 ||
|| camkes-arm-vmm for Nvidia Tx1 || planned || [[mailto:devel@sel4.systems|D61]] || || Including Linux running in a VM ||
|| multiple ARM VMs || planned || || || be able to run multiple VMMs, one VM per VMM. AArch32? AArch64? ||

== Userland Component and Drivers ==

||'''Feature'''||'''Status'''||'''Driven by'''||'''Repo'''||'''Comment'''||
