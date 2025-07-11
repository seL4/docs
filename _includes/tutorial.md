{% comment %}
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
{% endcomment %}

{%- assign file = '_processed/tutes/' | append: page.tutorial | append: '.md' %}
{%- include include_external_markdown.md file=file %}
