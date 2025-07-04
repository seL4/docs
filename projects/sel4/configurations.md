---
project: sel4
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025 Proofcraft Pty Ltd
---

# seL4 Configurations

seL4 has several different options available for configuring seL4 to execute in different
scenarios. Many of these options are only expected to used during application or kernel
development and may not be suitable for a final release deployment that wants to leverage
seL4's full capabilities.

*Due to the experimental nature of many of the options, there may be undocumented incompatibilities
when trying to configure several options together. seL4test, seL4bench or other user level examples
can be used to test a baseline level of configuration correctness.*

## Generic configuration options

{% include component_list.md project='sel4' list='configurations' type='generic' %}


## Scheduling configuration options
{% include component_list.md project='sel4' list='configurations' type='scheduling' %}


## Debug configuration options
{% include component_list.md project='sel4' list='configurations' type='debug' %}

## Performance analysis and profiling configuration options
{% include component_list.md project='sel4' list='configurations' type='profiling' %}

## Target hardware architecture/platform options

{% include component_list.md project='sel4' list='configurations' type='platform' %}

### x86

{% include component_list.md project='sel4' list='configurations' type='platform-x86' %}

### Arm
{% include component_list.md project='sel4' list='configurations' type='platform-arm' %}
