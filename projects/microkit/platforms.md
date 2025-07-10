---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025 Proofcraft Pty Ltd
---

# Microkit Supported Platforms

The following platforms are supported by the seL4 Microkit. See also the section
on [Board Support Packages](manual/latest/#bsps) in the Microkit manual.

Microkit currently supports [Arm](#arm) AArch64 and [RISC-V](#risc-v) boards. x64
support is on the [roadmap](roadmap.html).

{%- assign platforms = site.data.projects.microkit-data.platforms.platforms %}

## Arm

| Platform | System-on-chip | Core | Microkit platform |
| -        |  -             | -    | -                 |

{%- assign has_upcoming = false %}
{%- for p in platforms %}
{%-   if p.since == 'dev' %}
{%-     assign has_upcoming = true %}
{%-     continue %}
{%-   endif %}
{%-   assign pages = site.pages | where: "cmake_plat", p.cmake_plat %}
{%-   if pages.size == 1 %}
{%-     assign pg = pages[0] %}
{%-     if pg.arm_hardware != true %}
{%-       continue %}
{%-     endif %}
{%-     assign display_name = pg.platform %}
{%-     assign soc = pg.soc %}
{%-     assign cpu = p.cpu | default: pg.cpu %}
{%-   else %}
{%-     assign display_name = p.name %}
{%-     assign soc = "" %}
{%-     assign cpu = p.cpu | default: "" %}
{%-    endif %}
| [{{ display_name }}](manual/latest/#{{p.name}}) | {{ soc }} | {{ cpu }} | `{{ p.name }}` |
{%- endfor %}

## RISC-V

| Platform | System-on-chip | Core | Microkit platform |
| -        |  -             | -    | -                 |

{%- for p in platforms %}
{%-   if p.since == 'dev' %}
{%-     assign has_upcoming = true %}
{%-     continue %}
{%-   endif %}
{%-   assign pages = site.pages | where: "cmake_plat", p.cmake_plat %}
{%-   if pages.size == 1 %}
{%-     assign pg = pages[0] %}
{%-     if pg.riscv_hardware != true %}
{%-       continue %}
{%-     endif %}
{%-     assign display_name = pg.platform %}
{%-     assign soc = pg.soc %}
{%-     assign cpu = p.cpu | default: pg.cpu %}
{%-     assign arch = pg.arch %}
{%-   else %}
{%-     assign display_name = p.name %}
{%-     assign soc = "" %}
{%-     assign cpu = p.cpu | default: "" %}
{%-    endif %}
| [{{ display_name }}](manual/latest/#{{p.name}}) | {{ soc }} | {{ cpu }} | `{{ p.name }}` |
{%- endfor %}

{%- if has_upcoming %}

## Upcoming in the next release

| Platform | System-on-chip | Core | Microkit platform |
| -        |  -             | -    | -                 |

{%- for p in platforms %}
{%-   if p.since != 'dev' %}
{%-     continue %}
{%-   endif %}
{%-   assign pages = site.pages | where: "cmake_plat", p.cmake_plat %}
{%-   if pages.size == 1 %}
{%-     assign pg = pages[0] %}
{%-     assign url = pg.url | relative_url %}
{%-     assign display_name = '[' | append: pg.platform | append: '](' | append: url | append: ')' %}
{%-     assign soc = pg.soc %}
{%-     assign cpu = p.cpu | default: pg.cpu %}
{%-   else %}
{%-     assign display_name = p.name %}
{%-     assign soc = "" %}
{%-     assign cpu = p.cpu | default: "" %}
{%-    endif %}
| {{ display_name }} | {{ soc }} | {{ cpu }} | `{{ p.name }}` |
{%- endfor %}

{%- endif %}

## Not in the list above?

See the section on [adding platform
support](manual/latest#adding-platform-support) for how to add a new platform to
Microkit. To add a platform to Microkit it must be supported by seL4 first. See
the seL4 page on [supported platforms](../../Hardware/#not-in-the-lists-above) for options on that.
