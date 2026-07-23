---
permalink: /releases/microkit.html
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025 Proofcraft Pty Ltd
---

# Microkit releases

This page documents tagged releases of the seL4 [Microkit](../projects/microkit/) and their
corresponding SDK downloads and GPG signatures.

The downloads are signed by Julia Vassiliki `<julia.vassiliki@unsw.edu.au>` with
the key fingerprint `FE91 4864 43B0 F4EB 9ECC 3652 4D86 8A34 EDF3 FDCA`. [This
key is available from
https://keys.openpgp.org/](https://keys.openpgp.org/search?q=julia.vassiliki@unsw.edu.au).

Releases 2.2.0 and before are signed by
[Ivan Velickovic](https://keys.openpgp.org/search?q=i.velickovic@unsw.edu.au)
`<i.velickovic@unsw.edu.au>` instead.

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
