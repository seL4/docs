{% comment %}
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
{% endcomment %}

{% assign repo = include.repo | default: page.repo | downcase %}
{% assign include_file = include.file | default: page.include_file %}
{% assign file = '_repos/' | append: repo | append: "/" | append: include_file %}

{% include include_external_markdown.md  file=file indent_headings=include.indent_headings %}
