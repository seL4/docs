---
version: camkes-3.2.0
redirect_from:
  - /camkes_release/CAmkES_3.2.0/
  - /camkes_release/CAmkES_3.2.0.html
project: camkes
parent: /releases/camkes.html
seL4: 8.0.0
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# CAmkES Version camkes-3.2.0 Release


Announcing the release of `camkes-3.2.0` with the following changes:

camkes-3.2.0 2018-01-17

Using seL4 version 8.0.0

# Changes


- New ADL Syntax: Allow struct elements to have defaults.

    See the following ADL files for examples of Struct and
    Attribute behavior.
    <https://github.com/seL4/rumprun/blob/master/platform/sel4/camkes/rumprun.camkes>
    <https://github.com/seL4/camkes/tree/master/apps/structs>
    <https://github.com/seL4/camkes/tree/master/apps/attributes>

- Added experimental Rumprun support:

    This functionality is experimental and may not work
    as expected. See the following examples:
    <https://github.com/seL4/camkes/tree/master/apps/rumprun_ethernet>
    <https://github.com/seL4/camkes/tree/master/apps/rumprun_hello>
    <https://github.com/seL4/camkes/tree/master/apps/rumprun_pthreads>
    <https://github.com/seL4/camkes/tree/master/apps/rumprun_rust>

    More information about the Rumprun unikernel on seL4 can be
    found here:
    <https://research.csiro.au/tsblog/using-rump-kernels-to-run-unmodified-netbsd-drivers-on-sel4/>

- New Templates: Remote GDB debugging support

    On ia32 platforms a GDB server can be used to debug a
    component using the GDB server remote serial protocol.
    documentation:
    <https://github.com/seL4/camkes-tool/blob/master/docs/DEBUG.md>

- Added "hardware_cached" attribute to hardware dataports

    This feature had been added to camkes-2.x.x but hadn't been
    forward ported to camkes-3.x.x. Documentation in the [manual](../../projects/camkes/manual.html#cached-hardware-dataports)

# Known issues


- Hardware dataports that are large enough to use larger frame
        sizes are currently broken. There is an issue with

large frame promotion and hardware dataports where the capDL loader is
unable to map the promoted memory. This can be demonstrated by running
the testhwdataportlrgpages app on either
arm_testhwdataportlrgpages_defconfig or
x86_testhwdataportlrgpages_defconfig configurations. If this
functionality is required, hold off upgrading until this issue is fixed.

# Upgrade notes


- ADL files: ADL syntax changes in this release should not break
        any existing ADL files.
-

        Templates:

            seL4HardwareMMIO template now has an option to map hardware
            memory as cached. The default setting is uncached

which is the same as the old behaviour.

# Full changelog
 Use `git log camkes-3.2.0..camkes-3.1.0` in
<https://github.com/seL4/camkes-tool>

# More details
 See the
[documentation](https://github.com/seL4/camkes-tool/blob/camkes-3.2.0/docs/index.md)
or ask on the mailing list!
