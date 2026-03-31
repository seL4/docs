---
version: camkes-3.12.0
version_digits: 2
project: camkes
seL4: 15.0.0
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025 seL4 International
---

# CAmkES Version camkes-3.12.0 Release

Announcing the release of `camkes-3.12.0` with the following changes:


## camkes-3.12.0 2026-03-31
Using seL4 version 15.0.0

### Changes

* Add an optional schedule declaration to assemblies. Only one overall schedule
  declaration is allowed. This uses the new dynamic domain schedule API in seL4
  and capDL to declare the provided schedule in the capDL specification and
  loader. Schedules no longer need to be provided separately or compiled in by
  the user.

### Upgrade Notes

No changes are necessary for kernel configurations that do not use the domain
scheduler. For kernel configurations with domain scheduler support, instead of
providing the schedule in a separate `.c` file, the domain schedule should be
provided in the assembly declaration. Schedules can be transcribed one to one
without change. The difference in intended behaviour is that the schedule will
only start running after the initialiser is finished. Schedules may previously
have included timing for initialisation --- consider if the schedule should be
adjusted accordingly.

See the `domains` app in the `camkes` repository for an example schedule
declaration, and commit [3de1c46] in that repository for an upgrade example.

[3de1c46]: https://github.com/seL4/camkes/commit/3de1c460



## Full changelog
 Use `git log camkes-3.11.1..camkes-3.12.0` in
<https://github.com/seL4/camkes-tool>

## More details
 See the
[documentation](https://github.com/seL4/camkes-tool/blob/camkes-3.12.0/docs/index.md)
or ask on the mailing list!
