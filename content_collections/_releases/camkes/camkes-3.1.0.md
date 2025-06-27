---
version: camkes-3.1.0
redirect_from:
  - /camkes_release/CAmkES_3.1.0/
  - /camkes_release/CAmkES_3.1.0.html
title: camkes-3.1.0
project: camkes
parent: /releases/camkes.html
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# CAmkES 3.1.0 Release Notes


## Default Values for Attributes


It's now possible to give a default value when specifying an attribute
of a component in a `component { ... }` block.

Specific details from manual:

* It is possible to give an attribute a default value when it
  is declared. If there are no settings for an attribute, the default
  setting will be used. If an attribute is aliased to a different
  attribute that also has a default, then the different attribute's
  default will override the original default.

### Meaningful Thread Names


In seL4 threads can be named. A thread's name appears in the kernel's
debugging printouts when the thread faults. Names of threads created by
CAmkES are now named
`<component_instance_name>:<interface_name>` for interface
threads, and `<component_instance_name>:control` for control
threads.

### Scheduling Context Size Bits Attribute


When using CAmkES realtime extensions, the `size_bits` field of a
scheduling context can be set in CAmkES ADL. For interface threads,
specify the size bits of bound scheduling contexts with
`<component_instance_name>.<interface_name>_sc_size_bits = ...;`.
For control threads, specify the size bits of bound scheduling contexts
with `<component_instance_name>._sc_size_bits = ...;`.

### Documentation Fixes


- Removed outdated information about dependencies

### Bug Fixes


- Fixed bug in parser preventing empty lists of the form `[]` from
      parsing correctly
