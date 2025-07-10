---
version: camkes-3.10.0
project: camkes
parent: /releases/camkes.html
version_digits: 2
seL4: 12.1.0
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2021 seL4 Project a Series of LF Projects, LLC.
---
# CAmkES Version camkes-3.10.0 Release

Announcing the release of `camkes-3.10.0` with the following changes:

camkes-3.10.0 2021-06-10
Using seL4 version 12.1.0

## Changes

* Fixed new line generation in `show_attribute_value`.
* Added const expression attributes to help convert CAmkES attributes to literals.
* Fixed broken Python nosetests that weren't updated when moving to Python3 from Python2.
* Added caching when querying DMA frame physical addresses to avoid unnecessary kernel context switch overheads.
* Changed templates and libraries to be DMA cache-aware and to not ignore requests for cache-able memory
  allocations.
* Added a macro function for every dataport to query its size.
* Changed DMA bookkeeping to keep track of pools of frames and not individual frames.
* Added code to sanitize the names of nested components for the naming of a components' DMA pool.
* Converted the repository to use SPDX license tags.
* Fixed the passing of LD flags to the linker from CAmkES generation tools.
* Added the failing C pre-processor command to an exception in the CAmkES parser tools for easier diagnosis.
* Moved the CAmkES component interface header contents away from `camkes.h` and into separate header files that is
  included by `camkes.h`.
* Simplified the `sys_uname` library function.
* Fix handling of array parameters for the CAmkES templates.
* Sped up proofs for cdl-refine.
* Fixed a CMake argument marshalling bug in the `execute_process_with_stale_check` function.

### Upgrade Notes

* DMA pools now require an option to be set explicitly to be made to be cache-able. In a `.camkes` CAmkES assembly
  file, add the following `<component name>.dma_pool_cached = True;` in the 'configuration' block to make a component's
  DMA pool to be cached. Additionally, use `camkes_dma_alloc` in libsel4camkes with the correct arguments to allocate
  cached DMA memory from that pool.

# Full changelog
 Use `git log camkes-3.9.0..camkes-3.10.0` in
<https://github.com/seL4/camkes-tool>

# More details
 See the
[documentation](https://github.com/seL4/camkes-tool/blob/camkes-3.10.0/docs/index.md)
or ask on the mailing list!
