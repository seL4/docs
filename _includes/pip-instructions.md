{% comment %}
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: Copyright 2025 UNSW, Sydney
{% endcomment %}
{% assign deps = include.deps | default: "camkes-deps" %}
{% assign venv = include.venv | default: "seL4-venv" %}

<details>
  <summary>Error: Python environment is externally managed</summary>
  <div markdown="1">

Some Linux distributions have changed how Python is managed. If you get an error
saying the Python 'environment is externally managed' follow the instructions
below. The first two steps are needed only once for setup.

```sh
python3 -m venv {{venv}}
./{{venv}}/bin/pip install {{deps}}
```

The following step is needed every time you start using the build environment
in a new shell.

```sh
source ./{{venv}}/bin/activate
```

It is not important where the `{{venv}}` directory is located.
  </div>
</details>
