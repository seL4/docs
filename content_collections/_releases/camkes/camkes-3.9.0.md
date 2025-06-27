---
version: camkes-3.9.0
title: camkes-3.9.0
project: camkes
parent: /releases/camkes.html
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# CAmkES Version camkes-3.9.0 Release

Announcing the release of `camkes-3.9.0` with the following changes:

camkes-3.9.0 2020-10-26
Using seL4 version 12.0.0

## Changes

Below is a lightly edited list of all PRs merged into master for this release.

* Enforce system-V stack ordering for libc.
    - This allows `musllibc` to initialise and infer the location of `auxv` from `envp` consistently.
* Add `uint64_t` and `int64_t` types to language.
    - This introduced two new data types into the CAmkES language to support larger types.
* Remove `elf.h`, now defined in sel4runtime.
* Camkes,rumprun: fix tls management implementation:
    - `.tdata*` and `.tbss*` linker symbol declarations are suppressed until the final link step.
* Fix `generate_seL4_SignalRecv` in `Context.py` and update `rpc-connector.c` template accordingly.
    - `seL4SignalRecv` only exists on MCS, split the two calls for compatibility.
* Save preprocessed camkes files to allow for easier debugging.
* CMake: Skip fetching gpio list for pc99 platforms.
    - Most PC99 platforms do not have GPIO pins.
* Support for running odroidc2 in camkes-arm-vm. Get the IRQ trigger type through the interrupt node in the dts.
* Add gpio query engine.
    - The engine takes in a YAML file containing a list of GPIO pins and sorts out the 'gpio' queries so that the connector templates for the `seL4GPIOServer` can generate the appropriate structures and functions.
* Add option `CAmkESNoFPUByDefault`.
    - By enabling CAmkESNoFPUByDefault camkes will compile all user-level libraries (except musllibc) with compilation flags to not use the FPU. A component that wishes to use the FPU must override the flags itself.
* Update `seL4InitHardware` template for api change.
    - The configuration name for the list of devices to bind is now a component attribute instead of an interface attribute.
* `libsel4camkes` Support registering DMA memory that is both cached and uncached.
* Add sel4bench dependency into `camkes/templates` to allow for cycle counting.
* `component.common.c`: use correct label for dma pool.
    - When calling `register_shared_variable` from a component context the label needs to be provided.
* Add `seL4DTBHW` connector. This connector variant is similar to `seL4DTBHardware`, but takes a hardware component on the from end.
* `seL4DTBHardware` bug fix, use global interface name. This prevents the allocator from throwing an error when the same interface name is used in a different component.
* Camkes connector extensions + DMA improvements:
    - libsel4camkes: Implement DMA cache for Arm
    - component.common.c: Support additional DMA setting. Allow setting the cache and base paddr value of the DMA pool.
    - Add single_threaded attribute which when set adds the `seL4SingleThreadedComponent` templates.
    - Allow connectors to declare CMake libraries for each end of the connection. This allows a connector to have most of its implementation in a library and only use the template for initialisation and configuration.
    - camkes-gen.cmake: Create component target stub. This is equivalent to creating a Component with no customization but would still contain things based on its Camkes definition, such as connector artifacts.
* Component.common.c: Move init() to C constructor
    - Connectors that don't use threads use runtime constructors for their initialisation.
* Libsel4camkes: camkes_call_hardware_init_modules
Provide this public function for starting hardware modules that have been registered.
* Add `global_rpc_endpoint_badges` macro.
    - This macro assigns badges for different connectors that share the global-rpc-endpoint object for a component instance.
* Libsel4camkes: irq backend for global-connectors. This adds a way for calling registered IRQ notification handlers for connectors that don't have their own threads.
* Add seL4DMASharedData connector and add appropriate library functionality in `libsel4camkes`.
    - This connector sets up a dataport connector that is added to the DMA pool that the camkes runtime tracks for each component.
* Add support for connector header files and component header templates.
    - A connector can now define template header files that will be included by `camkes.h`. Similarly, component header templates will be instantiated and then automatically included by `camkes.h`.
* Support creating TCB pools and assigning domains to them in camkes templates.
    - Assign domain IDs for TCBs in the thread pool based on values provided by the config option array values.
* Generalise jinja linter to support non-camkes use cases. The Jinja linter can now be used on any arbitrary Jinja template.
* Add support in `libsel4camkes` for matching interrupts even if they are defined
with different base types.
* Add interface registration to `libsel4camkes` via `interface_registration.h` as part of the driver framework.
* Revive graph.dot output file for each asssembly. This can be loaded with a
program like `xdot` to view a diagram of the camkes system.
* Virtqueues:
    - Add virtqueue recieve.
    - Set virtqueue size on creation to the number of rings and descriptor tables have.
    - Add `virtqueue_get_client_id` macro for automatically assigning client IDs to distinguish different virtqueue channels within a single component instance.
    - Link channel ID to name, this allows components to bind to channels via naming them rather than knowing their IDs.
* Add Arm irq type support to `seL4HardwareInterrupt` template. This allows IRQs on Arm to have the trigger mode and target core configured.
* Allow `size` to be number as well as a string in `marshal.c` template.
* Add `global_endpoint_badges` macro used by the global-endpoints mechanism to assign badge
values based on a full system composition.
* Make `public allocate_badges` method which is used to standardize badge allocation across many connectors.
* Add support for a component definition to specify a template C source file. This file will be passed through the template tool before passed to the C compiler.
    - This is how components can allocate objects required from a loader without having to define special connector types.
* Add `msgqueue` mechanism which allows componets to sent messages. This is essentially another layer ontop of the virtqueue functionality.
* Accept Red Hat ARM cross-compilers in `check_deps.py`.
* Simplify the logic for combining the connections in the stage9 parser. This improves processing times.
* Camkes-tool:
    - Add priority to muslc so that its initialsation comes after camkes. This relates to recent changes in sel4runtime.
    - Add an interface `dataport_caps` for accessing dataport caps that is used by the seL4SharedDataWithCaps template.
* Tools: define `camkes_tool_processing` when running the C preprocessor.
* Remove `template` keyword from camkes language.
    - This is driven by wanting to make it easier to extend camkes generation build rules with more inputs than a single template file and make it possible better manage non-template code that needs to run when generating templates.

## Upgrade Notes


# Full changelog
 Use `git log camkes-3.8.0..camkes-3.9.0` in
<https://github.com/seL4/camkes-tool>

# More details
 See the
[documentation](https://github.com/seL4/camkes-tool/blob/camkes-3.9.0/docs/index.md)
or ask on the mailing list!
