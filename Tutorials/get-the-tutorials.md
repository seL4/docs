---
layout: tutorial
description: steps and code for getting tutorials
nav_next: hello-world.html
nav_prev: setting-up.html
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2024 seL4 Project a Series of LF Projects, LLC.
---

# Getting the tutorials

{% include note.html %}
The steps on this page only need to be done once, before doing your first tutorial.
{% include endnote.html %}

## Python Dependencies

The CAmkES python dependencies are required to build the seL4 tutorials. To install you can run:

```sh
pip3 install --user camkes-deps
```

{% include pip-instructions.md %}

## Get the code

The collection of code needed for the tutorials is defined in the [sel4-tutorials-manifest]. Get the code with:

```bash
mkdir tutorials
cd tutorials
repo init -u https://github.com/seL4/sel4-tutorials-manifest
repo sync
```

`repo sync` may take a few moments to run

[sel4-tutorials-manifest]: https://github.com/seL4/sel4-tutorials-manifest
