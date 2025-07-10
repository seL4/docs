---
permalink: /releases/capDL.html
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# capDL Releases

{% assign coll = site['releases'] | where: "project", "capdl" %}

{% for release in coll reversed %}
{%- assign seL4_link = '[' | append: release.seL4 | append: '](' |
                       append: '/releases/sel4/' | append: release.seL4 |
                       append: '.html)' %}
- capDL Release [{{ release.title }}]({{ release.url | relative_url }}) for seL4 {{seL4_link}} {% if forloop.first %}(latest){% endif %}
{% endfor %}
