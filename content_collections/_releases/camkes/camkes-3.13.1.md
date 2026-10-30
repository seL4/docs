---
version: camkes-3.13.1
version_digits: 2
project: camkes
seL4: 17.0.0
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2026 seL4 International
---

# CAmkES Version camkes-3.13.1 Release

Announcing the release of `camkes-3.13.1` with the following changes:

## camkes-3.13.1 2026-10-30

Using seL4 version 17.0.0

### Changes

#### CAmkES Tool

* No changes in the CAmkES tool itself

#### CAmkES VMM

* Fix a potential stack overflow in `virtio_block_emul`
* Add BCM2711 platform support
* Update for the additional register access traps in the new seL4 version:
  ignore reads and writes to co-processor registers from Linux.
* Remove platform support for Arndale `exynos5250` (see RFC-19)
* Remove platform support for Odroid-X `exynos4` (see RFC-19)

### Upgrade Notes

* No special upgrade requirements.

## Full changelog

Use `git log camkes-3.13.0..camkes-3.13.1` in
<https://github.com/seL4/camkes-tool>

## More details

See the
[documentation](https://github.com/seL4/camkes-tool/blob/camkes-3.13.1/docs/index.md)
or ask on the mailing list!
