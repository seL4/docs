---
redirect_from:
  - /SeL4Libraries
toc: true
wide: true
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# User-level C libraries

The following collection of C libraries is useful for prototyping directly on
the seL4 API. They are meant for trying things out, not for production code.
They are not verified and come with no particular code assurance. They are
provided because they might be useful for experimentation.

For production code we recommend the seL4  [Microkit], or [CAmkES] when the
Microkit is not applicable, and the [Rust] libraries for more dynamic systems.

Microkit does not use these libraries and expects a separate development
environment for user-level code. Some CAmkES example applications do use the
libraries below. Most of the CAmkES applications and also the libraries above
use the seL4 port of [libmuslc](https://github.com/seL4/musllibc).

The library collections maintained by the seL4 Foundation are
[util_libs](#util_libs), [projects_libs](#projects_libs),
[seL4_libs](#sel4_libs), [seL4_projects_libs](#sel4_projects_libs),
and [libplatsupport](#libplatsupport).

## OS independent libraries

OS independent low-level utilities in the repositories [util_libs] and
[projects_libs]. New libraries should go into `project_libs`.

[util_libs]: https://github.com/seL4/util_libs
[projects_libs]: https://github.com/seL4/projects_libs

### util_libs

Sources: <https://github.com/seL4/util_libs>

{% include component_list.md
           project='user_libs' type='util_libs' filter='active' no_status=true %}

### projects_libs

Sources: <https://github.com/seL4/projects_libs>

{% include component_list.md
           project='user_libs' type='projects_libs' filter='active' no_status=true %}

## seL4-specific libraries

Basic libraries with abstractions for interacting with seL4 from C.

### seL4_libs

Sources: <https://github.com/seL4/seL4_libs>

{% include component_list.md
           project='user_libs' type='seL4_libs' filter='active' no_status=true %}

### seL4_projects_libs

Sources: <https://github.com/seL4/seL4_projects_libs>

{% include component_list.md
           project='user_libs' type='seL4_projects_libs' filter='active' no_status=true %}


## Platform support {#libplatsupport}

Drivers for some of the devices on boards that seL4 supports.

The categories below are [Serial](#serial), [Timer](#timer), [Clock](#clock),
[I2C](#i2c), [Pinmux](#pinmux), [Reset](#reset), [GPIO](#gpio),
[ltimer](#ltimer), [Ethernet](#ethernet), and [Other](#other). Not all drivers
are supported on all boards. Serial and Timer/ltimer drivers are necessary to
support the `sel4test` and `sel4bench` test suites and are supported on nearly
all boards.

The seL4-independent parts of the `libpatsupport` libraries live in `util_libs`,
and the seL4-specific parts in `sel4_libs`.

Sources:

- <https://github.com/seL4/util_libs/tree/master/libplatsupport>
- <https://github.com/seL4/seL4_libs/tree/master/libsel4platsupport>

### Serial

{% include component_list.md project='user_libs' type='user-driver-serial' %}

### Timer

{% include component_list.md project='user_libs' type='user-driver-timer' %}

### Clock

{% include component_list.md project='user_libs' type='user-driver-clock' %}

### I2C

{% include component_list.md project='user_libs' type='user-driver-i2c' %}

### Pinmux

{% include component_list.md project='user_libs' type='user-driver-pinmux' %}

### Reset

{% include component_list.md project='user_libs' type='user-driver-reset' %}

### GPIO

{% include component_list.md project='user_libs' type='user-driver-gpio' %}

### ltimer

{% include component_list.md project='user_libs' type='user-driver-ltimer' %}

### Ethernet

{% include component_list.md project='user_libs' type='user-driver-ethernet' %}

### Other

{% include component_list.md project='user_libs' type='user-driver-other' %}




[Microkit]: {{ '/projects/microkit/' | relative_url }}
[CAmkES]: {{ '/projects/camkes/' | relative_url }}
[Rust]: {{ '/projects/rust/' | relative_url }}
