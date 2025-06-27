---
permalink: /releases/capDL.html
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# capDL Releases

{% assign coll = site['releases'] | where: "project", "capdl" %}

{% for release in coll reversed %}
- [{{ release.title }}]({{ release.url | relative_url }}) {% if forloop.first %}(latest){% endif %}
{% endfor %}
