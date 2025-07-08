---
project: sel4-tutorials
title: "camkes-3.8.x-compatible"
archive: true
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# Updates to sel4-tutorials from camkes-3.7.x to camkes-3.8.0

## External

- Add `fault-handlers` tutorial for learning about fault handlers.
- `mcs`: Add section describing difference between mainline and mcs kernel APIs
  for registering fault handlers.
- `hello-camkes-timer` tutorial: Fix init script to pick the correct tutorial.
- `hello-camkes-[1-2]`: Hide tutorial files from instructions
- `interrupts`: Remove sample output that doesn't appear in practice.
- `hello-camkes-2`: Update exit text test to match actual output.
- `mcs`: reduce spinner budget for final task to ensure timeout behavior happens correctly.
- `libraries-4`: Correctly initalize a stack variable.
- `hello-camkes-timer`: Use device tree for binding timer component to device and update tutorial.
- `hello-camkes-timer`: Add part-2 to tutorial for describing how to use new seL4DTBHardware camkes connector.
- `camkes-vm-crossvm`: Add error message if build configuration is incorrect.
- `dynamic-4`: Remove duplicate vspace init function.
- `hello-camkes-2`: Fix error in hint in task 8.
- Refactor tutorial build system to better match typical usage in other project. Previously the tutorials indicated
  that their build scripts shouldn't be used outside of the tutorial project, but this is no longer the case.
- `libraries-4`: Update platform timer API's to use ltimer interface.
- `mcs`: Support running tutorial on kernel master branch since mcs branch was merged.
- `mapping`: Remove seL4_X86_Page_Remap invocation from tutorial as kernel function had been removed.
- `libraries-1`: fix completion text for task-3.
- `hello-camkes-1`: Update instructions to match source code layout.
- `untyped`: Make sure that untyped being used in tutorial doesn't correspond to a device.

## Internal
- Update usage of `capdl_linker` tool to newer API.
- Specify TCB CapDL attributes at allocation point.
- `capdl-ld`: Add newly required `--keys` argument.
- add `.stylefilter` for style tooling.
- Style scripts.
- Update scripts from `python2` to `python3`.
- `hello-camkes-timer`: Correctly configure device tree tooling.
- Port tutorials to use new `sel4runtime`.
- Add support for custom build configuration `settings.cmake` files for each tutorial.
- Remove dependence on global `Configuration` library.
