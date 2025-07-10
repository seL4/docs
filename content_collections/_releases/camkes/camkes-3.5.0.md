---
version: camkes-3.5.0
redirect_from:
  - /camkes_release/CAmkES_3.5.0/
  - /camkes_release/CAmkES_3.5.0.html
project: camkes
parent: /releases/camkes.html
seL4: 10.0.0
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# CAmkES Version camkes-3.5.0 Release

Announcing the release of `camkes-3.5.0` with the following changes:

camkes-3.5.0 2018-05-28
Using seL4 version 10.0.0

This release is the last release with official support for Kbuild based projects.
This release and future releases use CMake as the build system for building applications.

## Changes
* Remove `crit` and `max_crit` fields from TCB CapDL Object
  These fields were previously added to support an earlier version of seL4-mcs that gave threads criticality fields.
  This feature was removed from seL4-mcs. This also means that the arguments to camkes-tool, `--default-criticality`
  and `--default-max-criticality`, have also been removed.

## Upgrade Notes
* Calls to `camkes.sh` that used the above arugments will need to be updated.



# Full changelog
 Use `git log camkes-3.4.0..camkes-3.5.0` in
<https://github.com/seL4/camkes-tool>

# More details
 See the
[documentation](https://github.com/seL4/camkes-tool/blob/camkes-3.5.0/docs/index.md)
or ask on the mailing list!
