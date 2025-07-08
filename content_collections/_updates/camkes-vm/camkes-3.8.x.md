---
project: camkes-vm
title: "camkes-3.8.x-compatible"
archive: true
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# Updates to camkes-vm from camkes-3.7.x to camkes-3.8.0


## camkes-vm

- `FileServer`: Move `fsclient` to `libFileServer-client`.
  `libFileServer-client` is now a library bundled with the `FileServer`
  component. Components that are clients of the RPC interface provided by
  the `FileServer` can now link this client library and initialise it with
  the name of the local-client interface binding (`fs` for `Init`) to set up
  the `muslc` syscall bindings.
- Update RPC templates with new `grantreply` right (rather than `grant`).
- `Ethdriver`: Fix DMA physical and virtual DMA address assumption.
  Previously, the component assumed that the physical and virtual DMA
  addresses are the same. This is supposedly the case on x86 platforms but
  not on ARM platforms. This commit fixes this assumption and correctly
  passes the physical DMA addresses down to the Ethernet device driver.
- `Ethdriver`: Add ARM `Ethdriver` component and platform specific definitions
- Add PicoServer component for providing a UDP/TCP socket client interface and
  consuming a `seL4Ethernet` interface.
- `Ethdriver`: Use new `seL4DTBHardware` connector.
  This commit updates the ARM versions of the `Ethdriver` component to use
  the new `seL4DTBHardware` connector. This is done to remove the additional
  boilerplate code needed to initialise hardware resources.
- Move `Ethdriver` and `PicoServer` components, templates and interfaces to `global-components` repository.
- remove global `Configuration` library.
- Update `virtio_net_switch` to new `libvirtqueue`.
  Introduces the necessary changes for the `virtio_net_switch` to work with
  the new multi buffer virtqueue.
- CMake: Add Findcamkes-vm.cmake module


## camkes-vm-examples

- Add griddle support for easy project configuration and building.
- CMake: Update project to use CMake modules
