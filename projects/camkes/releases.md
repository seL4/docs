---
permalink: /releases/camkes.html
redirect_from:
  - /camkes_release
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# CAmkES releases

{% assign coll = site['releases'] | where: "project", "camkes" %}
{% comment %}
Sort sorts by string sorting so a version of 2.3.0 is higher than 10.0.0.
Because of this we need to split the list into two before sorting.
{% endcomment %}
{% assign releases_1 = coll | where_exp:"item", "item.version_digits != 2" | sort: "version"  %}
{% assign releases_2 = coll | where_exp:"item", "item.version_digits == 2" | sort: "version" %}
{% assign releases =  releases_1 | concat: releases_2 %}

{% for release in releases reversed %}
{%- assign seL4_link = '[' | append: release.seL4 | append: '](' |
                       append: '/releases/sel4/' | append: release.seL4 |
                       append: '.html)' %}
- Release [{{ release.title }}]({{ release.url | relative_url }}), for seL4 {{seL4_link}} {% if forloop.first %}(latest){% endif %}
{% endfor %}
