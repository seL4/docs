---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Rust: Releases

For the latest features, along with compatibility with the latest versions of the Rust toolchain, consider using the `main` branch of the [seL4/rust-sel4](https://github.com/seL4/rust-sel4) repository.

Releases serve as snapshots of that branch:

{%- assign releases = site.data.projects.rust.releases %}

{%- for release in releases reversed -%}
{%- assign kernel_url = '/releases/sel4/' | append: release.kernel_version |
                        append: '.html' | relative_url %}
{%- assign microkit_url = '/releases/microkit/' | append: release.microkit_version |
                        append: '.html' | relative_url %}
- Release [rust-sel4 {{ release.version }}]({{ release.url }})
    (compatible with seL4 version [{{ release.kernel_version }}]({{kernel_url}})
     and Microkit version [{{ release.microkit_version }})]({{microkit_url}})
    {% if forloop.first %}**(latest)**{% endif %}

{%- endfor %}
