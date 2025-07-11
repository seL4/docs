---
redirect_from:
  - /DebuggingUserspace
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Hardware debugging of user-space threads

This guide is for debugging user-level code on top of seL4. See the [kernel
debugging guide](debugging-guide.html) for how to debug the kernel itself.

## Overview

The seL4 microkernel leverages the hardware debugging capabilities of modern
processors, and exports hardware breakpoint, watchpoint, and single-stepping to
user threads via conditionally compiled-in APIs. These kernel-level APIs can be
used as the backend for implementing a full-featured debugger, or porting an
existing one such as the GNU Debugger.

## Enabling this feature

You can enable and disable the hardware debugging API by going through the
kernel's configuration system by passing `-DHardwareDebugAPI=1`.

Not all platforms support this feature for two main reasons:

- The feature is gated behind certain hardware signals, such as `#DBGEN`, being
  active. If the hardware isn't asserting these signals, the kernel will be
  unable to use them.
- Your processor supports only the "Baseline" set of Coprocessor 14 registers,
  and doesn't reliably expose the debug features through the debug coprocessor.

{% include note.html kind="Caution" %}
If you compile the kernel with support for the debug API, and your ARM platform
doesn't support it, **your kernel will abort at boot**.
{% include endnote.html %}

## Summary of the invocations

The invocations are documented in detail in the seL4 manual. This article will
cover how to practically call them and use them in a prospective debugger.

To view a current version of the seL4 manuals, please download the kernel source
code and then `cd manual` and execute `make`.

Additionally, there is available source code that demonstrates how the
invocations can be used practically: the seL4-Test repository holds code tests
the debug APIs, and shows how to use them to set breakpoints, watchpoints and
single-stepping, on both x86 and ARM:

- <https://github.com/seL4/sel4test/blob/master/apps/sel4test-tests/src/tests/breakpoints.c>
- <https://github.com/seL4/sel4test/blob/master/apps/sel4test-tests/src/arch/x86/tests/breakpoints.c>

The invocations take capabilities to TCBs, and perform operations on the TCB
register context to virtualise the hardware debug feature for each thread.

- `seL4_TCB_SetBreakpoint`: Takes a capability to a TCB, and a hardware
  breakpoint register ID, and sets a breakpoint on a specified virtual address,
  for a range of addresses, for a certain access type (Read, Write, or both).
- `seL4_TCB_UnsetBreakpoint`: Takes a capability to a TCB, and both disables and
  clears the specific hardware breakpoint for that thread.
- `seL4_TCB_GetBreakpoint`: Takes a capability to a TCB, and returns information
  on whether or not the hardware breakpoint is enabled, and if enabled, what
  virtual address it will trigger on, and what types of accesses will trigger
  it.
- `seL4_TCB_ConfigureSingleStepping`: Takes a capability to a TCB, and
  configures a hardware debugging register to break on every instruction (or
  every Nth instruction), and send a message on the thread's fault endpoint
  everytime it faults. You may reply to the fault endpoint to resume the
  thread's execution.


