---
toc: true
title: Getting the tutorials
layout: tutorial
description: steps and code for getting tutorials
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2024 seL4 Project a Series of LF Projects, LLC.
---

## Python Dependencies

*Hint:* This step only needs to be done once, i.e. before doing your first tutorial.

The CAmkES python dependencies are required to build the [tutorials](ReworkedTutorials). To install you can run:

```sh
pip3 install --user camkes-deps
```

{% include pip-instructions.md %}

## Get the code
All code for the tutorials is described in the <a href="https://github.com/seL4/sel4-tutorials-manifest">sel4-tutorials-manifest</a>. Get the code with:
```
mkdir sel4-tutorials-manifest
cd sel4-tutorials-manifest
repo init -u https://github.com/seL4/sel4-tutorials-manifest
repo sync
```

`repo sync` may take a few moments to run

*Hint:* The **Get the code** step only needs to be done once, i.e. before doing your first tutorial.
