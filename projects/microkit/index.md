---
title: Microkit
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# The seL4 Microkit

The seL4 Microkit is an operating system framework on top of seL4 provides a small set of simple abstractions that ease the design and implementation of statically structured systems on seL4, while still leveraging the kernel’s benefits of security and performance.

The Microkit is distributed as an SDK that integrates with the build system of your choice, significantly reducing the barrier to entry for new users of seL4.

## More information
- [Microkit GitHub repository](https://github.com/sel4/microkit)
{% assign project = site.data.projects["microkit"] %}
{% for link in project.useful_urls %}
- [{{ link.label }}]({{ link.url }})
{% endfor %}
