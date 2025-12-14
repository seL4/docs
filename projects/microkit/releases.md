---
permalink: /releases/microkit.html
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025 Proofcraft Pty Ltd
---

# Microkit releases

This page documents tagged releases of the seL4 [Microkit](../projects/microkit/) and their
corresponding SDK downloads and GPG signatures.

The downloads are signed by Ivan Velickovic <i.velickovic@unsw.edu.au> with the
key fingerprint `EFC6 142C FE61 C255 B4CD  E959 6FBD 87E8 4FA8 89BB`. The key
is available from <https://keys.openpgp.org/>.

{% assign coll = site['releases'] | where: "project", "microkit" %}
{% comment %}
Sort sorts by string sorting so a version of 2.3.0 is higher than 10.0.0.
Because of this we need to split the list into two before sorting.
{% endcomment %}
{% assign releases_1 = coll | where_exp:"item", "item.version_digits != 2" | sort: "version"  %}
{% assign releases_2 = coll | where_exp:"item", "item.version_digits == 2" | sort: "version" %}
{% assign releases =  releases_1 | concat: releases_2 %}

{% assign sdk_downloads = site.data.projects.microkit.sdk_downloads %}

{% for release in releases reversed -%}

## {{ release.title }} {% if forloop.first %}(latest){% endif %}

[Release notes]({{ release.url | relative_url }})

<table>
  <thead>
    <tr>
      <th scope="col">OS</th>
      <th scope="col">Arch</th>
      <th scope="col">Download</th>
      <th scope="col">Signature</th>
    </tr>
  </thead>
  <tbody>
{%- assign sdks = sdk_downloads | where: "version", release.title %}
{%- assign sdks = sdks[0] %}
{%-  for sdk in sdks.sdks %}
    <tr>
      <th scope="row">{{ sdk.os }}</th>
      <th scope="row">{{ sdk.arch }}</th>
      <th scope="row"><a href="{{ sdk.url }}">{{ sdk.label }}</a></th>
      <th scope="row"><a href="{{ sdk.url }}.asc">sig</a></th>
    </tr>
{%-   endfor %}
  </tbody>
</table>

{% endfor %}
