---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Maintained repositories

This page contains a list of the repositories on GitHub that we make an effor to maintain and keep up to date.

All other repositories can be considered unmaintained.

----

{% for project in site.data.maintained.github %}
- [{{project.name}}](https://github.com/{{project.name}})
	{% for repo in project.repos %}
   - [{{repo}}](https://github.com/{{project.name}}/{{repo}})
	{% endfor %}
{% endfor %}
