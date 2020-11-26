{% comment %}
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
{% endcomment %}
{% assign update_where_exp = "item.url contains '/updates/" | append: include.project | append: "/'" %}
{% assign updates = site['updates'] | where_exp:"item", update_where_exp %}
{% for update in updates | sort: "date" %}
[{{ update.title }}]({{ update.url }})
{% endfor %}
