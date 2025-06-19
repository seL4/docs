---
title: Microkit releases
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025 Proofcraft Pty Ltd
---

# Microkit releases

This page documents tagged releases of the seL4 [Microkit](./).

{% assign coll = site['releases'] | where: "project", "microkit" %}
{% comment %}
Sort sorts by string sorting so a version of 2.3.0 is higher than 10.0.0.
Because of this we need to split the list into two before sorting.
{% endcomment %}
{% assign releases_1 = coll | where_exp:"item", "item.version_digits != 2" | sort: "version"  %}
{% assign releases_2 = coll | where_exp:"item", "item.version_digits == 2" | sort: "version" %}
{% assign releases =  releases_1 | concat: releases_2 %}

{% for release in releases reversed %}
- Release [{{ release.title }}]({{ release.url }}) {% if forloop.first %}(current){% endif %}
{% endfor %}
