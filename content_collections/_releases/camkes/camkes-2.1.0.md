---
version: camkes-2.1.0
redirect_from:
  - /camkes_release/CAmkES_2.1.0/
  - /camkes_release/CAmkES_2.1.0.html
title: camkes-2.1.0
project: camkes
parent: /releases/camkes.html
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# CAmkES 2.1.0 Release Notes


## New Features


- runner takes an `--architecture` command line argument which selects
      the target architecture. Valid arguments are: aarch32, arm_hyp,
      ia32
- added the ability to specify a hardware dataport as cached.
      Previously all hardware dataports were mapped uncached. This
      feature is intended to be used on dataports backed by DMA-able
      memory to improve access times. Functions to flush dataports from
      the cache are also provided.
- support for seL4 3.0.0

## Removed Features


- `--hyp` command line argument is replaced with
      `--architecture arm_hyp`

## API Removals


### Unmarshalling Helpers
These were intended for use in templates, but are no longer used in any internal templates:
 * `camkes_marshal`
 * `camkes_marshal_string`
 * `camkes_unmarshal`
 * `camkes_unmarshal_string`

### DMA Utilities
 These had been deprecated for a long period and are now being removed:
 * `camkes_dma_page_alloc`
 * `camkes_dma_page_free`
