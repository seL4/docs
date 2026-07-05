---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2026 Proofcraft Pty Ltd
---

# seL4 Manual

* [Latest version of the seL4 Manual (PDF)](https://sel4.systems/Info/Docs/seL4-manual-latest.pdf)

{%- assign sel4_releases = site.releases | where: "project", "sel4" -%}

{%- comment -%}

* liquid has no array literals, hence the split on the empty string to
  get an empty array and the split in `one` to generate a one-element array.
* explicitly leave out development versions
* manually add version 1.0.4, which has an archived manual, but no release
  page or change log available in the seL4 repo.

{%- endcomment -%}
{%- assign onedigit = "" | split: "," -%}
{%- assign twodigit = "" | split: "," -%}
{%- for r in sel4_releases -%}
  {%- assign major = r.version | split: "." | first -%}
  {%- assign suffix = r.version | split: "-" | last -%}
  {%- assign one = r.version | split: "|" -%}
  {%- if major.size == 1 -%}
    {%- if suffix != "dev" -%}
      {%- assign onedigit = onedigit | concat: one -%}
    {%- endif -%}
  {%- else -%}
    {%- assign twodigit = twodigit | concat: one -%}
  {%- endif -%}
{%- endfor -%}

{%- assign one = "1.0.4" | split: "|" -%}
{%- assign onedigit = onedigit | concat: one -%}

{%- assign twodigit = twodigit | sort | reverse -%}
{%- assign onedigit = onedigit | sort | reverse -%}
{%- assign sorted = twodigit | concat: onedigit %}

* Available versions of the seL4 Manual:

{%- for entry in sorted %}
  * Version [{{ entry }}](https://sel4.systems/Info/Docs/seL4-manual-{{ entry }}.pdf)
{%- endfor -%}
