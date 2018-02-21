= seL4 3.0.1 Release Notes =

This release adds support for the NVIDIA Tegra K1, along with other
minor improvements.

== Implementation improvements ==

> -   Support for NVIDIA Nvidia Tegra K1 added.
> -   more reduction of duplication between kernel and libsel4.
> -   Beagle now uses GPT9 instead of GPT11 as the kernel timer, which
>     is much more accurate.
> -   Fixes a bug where x86 would fault when built using -O0.

== Upgrade notes ==

This change is source and binary compatible.

== Full changelog ==

Use git log 3.0.0..3.0.1
