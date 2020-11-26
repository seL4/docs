{% comment %}
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
{% endcomment %}
{%- if include.link != '' %}[{{include.text}}]({{include.link}}){% else %}{{include.text}}{% endif -%}
