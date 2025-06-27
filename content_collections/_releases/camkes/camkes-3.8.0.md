---
version: camkes-3.8.0
title: camkes-3.8.0
project: camkes
parent: /releases/camkes.html
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# CAmkES Version camkes-3.8.0 Release

Announcing the release of `camkes-3.8.0` with the following changes:

camkes-3.8.0 2019-11-19
Using seL4 version 11.0.0

## Changes

* Support for the new seL4 Endpoint GrantReply access right for CAmkES connector types.
  - This allows multi-sender/single-receiver connectors such as `seL4RPCCall` that don't also provide the ability for
    arbitrary capability transfer from sender to receiver. Previously the `seL4RPC` connector was used instead of
    `seL4RPCCall` to create an Endpoint without a Grant right. This used a combination of `seL4_Send` and `seL4_Wait`
    to communicate without the ability for capability transfer, however this only supports a single sender and single
    receiver.
* Better support for configuring components with a provided devicetree.
  - This support includes adding an seL4DTBHardware connector that can be used instead of seL4HardwareMMIO and
  seL4HardwareInterrupt and can be used to extract IRQs and MMIO register information out of the devicetree node rather
  than specifying the info directly. This connector can also be used to access a devicetree within a component for
  querying further device information. There is also a connector seL4VMDTBPassthrough that can be used for specifying
  devices to pass through to a `camkes-arm-vm` VM component.
* CapDL Refinement framework (cdl-refine).
  These are generated Isabelle proof scripts to prove that the generated capDL respects the isolation properties
  expected from its CAmkES system specification. Only the AARCH32 platform is supported. The generated capDL is a
  specification of seL4 objects and capabilities that will implement the CAmkES system specification. This
  specification is then given to a system initialiser to create the objects and capabilities and load the system.
* Support for RISC-V systems.
* Port libsel4camkes environments to the sel4runtime
* CAmkES can be used on any seL4 platform that uses a camkes supported seL4 architecture (x86, Arm, RISC-V)
* By default the C preprocessor will be run over CAmkES ADL files
  - The Camkes syntax excludes lines starting with `#` due to the integration of CPP. This can sometimes cause
    confusion where #ifdef is used but the CPP isn't configured to run. Projects are still able to disable the CPP.
* capDL Static initialisation
  - Using the capDL support for static allocation of objects from an Untyped list, Camkes supports generating specs
    with all objects preallocated. This can then be loaded by a static loader.
  - This is only supported on Arm by setting CAmkESCapDLStaticAlloc=ON.
* Use large pages for dataports if able
  - Instead of rounding the dataports to 4K pages all the time, try to use multiples of larger frames to back the
    dataports if the size of the dataports are a multiple of the larger frames.
* Fix cache flush for seL4HardwareMMIO connectors
  - This was a feature that was available in 2.x.x but removed in 3.0.0.


# Full changelog
 Use `git log camkes-3.7.0..camkes-3.8.0` in
<https://github.com/seL4/camkes-tool>

# More details
 See the
[documentation](https://github.com/seL4/camkes-tool/blob/camkes-3.8.0/docs/index.md)
or ask on the mailing list!
