---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025 Proofcraft Pty Ltd
---

# Microkit Supported Platforms

The following platforms are supported by the seL4 Microkit. See also the section
on [Board Support Packages](manual/latest/#bsps) in the Microkit manual.

{%- assign platforms = site.data.projects.microkit.platforms.platforms %}

| Platform | System-on-chip | Core | Arch |
| -        |  -             | -    | -    |

{%- for p in platforms %}
{%-   for p_content in p %}
{%-   if p_content.cmake_plat %}
{%-     assign cmake_plat = p_content.cmake_plat %}
{%-     break %}
{%-   else %}
{%-     assign name = p_content %}
{%-   endif %}
{%-   endfor %}
{%-   assign pages = site.pages | where: "cmake_plat", cmake_plat %}
{%-   if pages.size == 1 %}
{%-     assign pg = pages[0] %}
{%-     assign display_name = pg.platform %}
{%-     assign soc = pg.soc %}
{%-     assign cpu = pg.cpu %}
{%-     assign arch = pg.arch %}
{%-   else %}
{%-     assign display_name = name %}
{%-     assign soc = "" %}
{%-     assign cpu = "" %}
{%-     assign arch = "" %}
{%-    endif %}
| [{{ display_name }}](manual/latest/#{{name}}) | {{ soc }} | {{ cpu }} | {{ arch }} |
{%- endfor %}

## Not in the list above?

See the section on [adding platform
support](manual/latest#adding-platform-support) for how to add a new platform to
Microkit. To add a platform to Microkit it must be supported by seL4 first. See
the seL4 page on [supported platforms](../../Hardware/#not-in-the-lists-above) for options on that.
