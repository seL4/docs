---
version: camkes-3.11.0
title: camkes-3.11.0
project: camkes
parent: /releases/camkes.html
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2024 seL4 Project a Series of LF Projects, LLC.
---

# CAmkES Version camkes-3.11.0 Release

#### 2024-07-01

Announcing the release of `camkes-3.11.0`, using seL4 version 13.0.0.

### Changes

#### Added/Removed

* Added support for SMC capabilities
* Allow camkes components to know affinity; add build time error check for affinity
* dataport: Add getter for frame size
* `libsel4camkes`: expose `get_virtqueue_channel`
* Added RISC-V in `is_64_bit_arch()`
* Added helpers `is_arch_arm()` and `is_arch_riscv()`
* Added an additional parameter with the current architectures for the macros
  `parse_dtb_node_interrupts()` and `global_endpoint_badges()`.
* Added support for C++ source files in CAmkES components
* parser: Support address translation ranges
* `serial:` add config options for different ports
* Extended DTB interrupt property parsing to support either one value or three
  values per interrupt. For three values, ignore the first value on RISC-V.
* Add vulnerability reporting policy
* Name frames in a region for easy sorting: When generating a set of frames to
  cover a region, use as many digits as necessary so that the capDL tool, when
  it sorts alphabetically, will still leave frames that are meant to be
  contiguous contiguous.
* Remove references to and support of ARMv6 and the `kzm` platform

#### Fixed

* component.simple: fix mismatched type size, which may cause data overflow when
  `CONFIG_WORD_SIZE` is 64. Use the `CLZL()` macro to correctly handle the
  specified `CONFIG_WORD_SIZE`.
* parser,fdtQueryEngine: Fix parser bug with DTB queries
* Make sure fault handler and control run on same core as component
* Improve error messages
* cmake: add missing parameter `DTB_FILE_PATH`
* fix `CAMKES_ROOT_DTS_FILE_PATH` check
* serial: rename Serial.camkes files. This fixes an "unknown reference to
  'Serial'" issue seen on MacOS.
* Fix IOAPIC vs MSI check in `irq.c`
* `component.common:` align morecore region to 0x1000. This region is used for
  mmap and brk allocations. If the 4k implementation alignment assumption isn't
  obeyed then memory errors are possible.
* Avoid printing internal debug info
* Consistently use CONFIG_PLAT in `camkes_sys_uname()` for all architectures.
* More robust catching of `objcopy` errors during build
* parser: fix attribute_reference regex
* python: sanitize number formatting

#### Dependencies, Tests, Docs

* `libsel4camkes`: Add markdown documentation
* parser: Add unit test for range translations
* Add CAmkES unit and app tests to GitHub CI
* Make more CAmkES tests available on pull requests
* Small tutorial fixes
* Improve thread priority description in docs
* Remove unused python dependencies
* Replace obsolete `orderedset` python dependency with maintained `ordered_set`
* Update `camkes-deps` description and instructions
* `camkes-deps`: set minimum `jinja2` version


### Upgrade Notes

* No special upgrade requirements.


## Full changelog

 Use `git log camkes-3.10.0..camkes-3.11.0` in
<https://github.com/seL4/camkes-tool>

## More details

 See the
[documentation](https://github.com/seL4/camkes-tool/blob/camkes-3.11.0/docs/index.md)
or ask on the mailing list!
