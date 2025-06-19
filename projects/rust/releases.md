---
parent: /projects/rust/

SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Rust: Releases

For the latest features, along with compatibility with the latest versions of the Rust toolchain, consider using the `main` branch of the [seL4/rust-sel4](https://github.com/seL4/rust-sel4) repository.

Releases serve as snapshots of that branch:

{% assign releases = site.data.projects.rust.releases %}

{% for release in releases reversed -%}

- Release [{{ release.version }}]({{ release.url }})
    (compatible with seL4 version {{ release.kernel_version }} and Microkit version {{ release.microkit_version }})
    {% if forloop.first %}**(latest)**{% endif %}

{% endfor %}
