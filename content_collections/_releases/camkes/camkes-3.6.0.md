---
version: camkes-3.6.0
redirect_from:
  - /camkes_release/Camkes_3.6.0/
  - /camkes_release/Camkes_3.6.0.html
project: camkes
parent: /releases/camkes.html
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# Camkes Version camkes-3.6.0 Release

Announcing the release of `camkes-3.6.0` with the following changes:

camkes-3.6.0 2018-11-07
Using seL4 version 10.1.0

## Changes

* AARCH64 is now supported.
* CakeML components are now supported.
* Added `query` type to Camkes ADL to allow for querying plugins for component configuration values.
* Components can now make dtb queries to parse device information from dts files.
* Component definitions for serial and timer added on exynos5422, exynos5410, pc99.
* Preliminary support for Isabelle verification of generated capDL.
    - See cdl-refine-tests/README for more information
* Simplify and refactor the alignment and section linking policy for generated Camkes binaries.
* Dataports are now required to declare their size in the ADL.
* Templates now use seL4_IRQHandler instead of seL4_IRQControl, which is consistent with the seL4 API.
    - This change is BREAKING.
* Remove Kbuild based build system.
* Remove caches that optimised the Kbuild build system, which are not required with the new Cmake build system.
* Added virtqueue infrastructure to libsel4camkes, which allows virtio style queues between components.


## Upgrade Notes

* Any dataport definitions that did not specify a size must be updated to use a size.
* Any template that used seL4_IRQControl must be updated to use seL4_IRQHandler.
* Projects must now use the new Cmake based build system.



# Full changelog
 Use `git log camkes-3.5.0..camkes-3.6.0` in
<https://github.com/seL4/camkes-tool>

# More details
 See the
[documentation](https://github.com/seL4/camkes-tool/blob/camkes-3.6.0/docs/index.md)
or ask on the mailing list!
