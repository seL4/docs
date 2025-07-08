---
permalink: sitemap.html
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Sitemap

{%- assign pages = page.static_files | where_exp:'page','page.name != "404.html"' %}
{%- assign collections = site.collections | where_exp:'collection','collection.output != false' %}
{%- for collection in collections %}
  {%- assign docs = collection.docs | where_exp:'doc','doc.sitemap != false' %}
  {%- assign pages = pages | concat: docs %}
{%- endfor %}

## Pages

{%- assign site_pages = site.html_pages | where_exp:'doc','doc.sitemap != false' | where_exp:'doc','doc.url != "/404.html"' %}
{% assign pages = pages | concat: site_pages | sort: "url" %}
{%- for page in pages %}
  {%- unless page.archive %}
- [{{ page.url }}]({{ page.url | replace:'/index.html','/' }}) -- {{ page.title }}
  {%- endunless %}
{%- endfor %}

## Archived Pages

{%- for page in pages %}
  {%- if page.archive %}
- [{{ page.url }}]({{ page.url | replace:'/index.html','/' }}) -- {{ page.title }}
  {%- endif %}
{%- endfor %}
