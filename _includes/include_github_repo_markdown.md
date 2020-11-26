{% comment %}
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
{% endcomment %}

{% assign repo = include.repo | downcase %}
{% assign file = '_repos/' | append: repo | append: "/" | append: include.file %} 
{% assign view_url = 'https://github.com/' | append: repo | append: '/blob/master/' | append: include.file %}
{% assign edit_url = 'https://github.com/' | append: repo | append: '/edit/master/' | append: include.file %}

{% include include_external_markdown.md  file=file indent_headings=include.indent_headings %}

*File included from [github repo]({{view_url}}) [edit]({{edit_url}})*
