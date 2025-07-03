---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2025 Proofcraft Pty Ltd
---

# Setting up your machine to use Microkit

The seL4 Microkit is distributed as a software development kit (SDK) for Linux
and Mac on Intel and Arm architectures and needs no further setup.

You are free to choose your own development environment and build system. For an
example, see the [Microkit tutorial](tutorial/welcome.html), or the `example`
folder in the SDK together with the [Microkit manual](manual/latest/).

The SDK for the latest release can be downloaded below:

{% assign coll = site['releases'] | where: "project", "microkit" %}
{% comment %}
Sort sorts by string sorting so a version of 2.3.0 is higher than 10.0.0.
Because of this we need to split the list into two before sorting.
{% endcomment %}
{% assign releases_1 = coll | where_exp:"item", "item.version_digits != 2" | sort: "version"  %}
{% assign releases_2 = coll | where_exp:"item", "item.version_digits == 2" | sort: "version" %}
{% assign releases =  releases_1 | concat: releases_2 | reverse %}
{% assign sdk_downloads = site.data.projects.microkit.sdk_downloads %}
{% assign release = releases[0] -%}

- Release [{{ release.title }}]({{ release.url | relative_url }})
{%- assign sdks = sdk_downloads | where: "version", release.title %}
{%- assign sdks = sdks[0] %}
{%-  for sdk in sdks.sdks %}
  - [{{ sdk.label }}]({{sdk.url}}) [[sig]({{sdk.url}}.asc)]
{%-   endfor %}
