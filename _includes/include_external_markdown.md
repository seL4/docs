{% comment %}
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
{% endcomment %}
{% capture file %}
{% include_absolute {{include.file}} %}
{% endcapture %}
{% assign file = file | replace: site.static_url, site.baseurl %}
{% assign file = file | replace: '.md)', '.html)' %}

{% if include.indent_headings %}
{% assign file = file | replace: '# ', '## ' %}
{% endif %}
{{ file }}
