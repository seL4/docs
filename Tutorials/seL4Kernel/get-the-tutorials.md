---
toc: true
layout: tutorial
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2024 seL4 Project a Series of LF Projects, LLC.
---

# Tutorials
## Python Dependencies
Additional python dependencies are required to build [tutorials](ReworkedTutorials). To install you can run:
```
pip install --user aenum
pip install --user pyelftools
```
*Hint:* This step only needs to be done once, i.e. before doing your first tutorial

## Get the code
All tutorials are in the <a href="https://github.com/seL4/sel4-tutorials-manifest">sel4-tutorials-manifest</a>. Get the code with:
```
mkdir sel4-tutorials-manifest
cd sel4-tutorials-manifest
repo init -u https://github.com/seL4/sel4-tutorials-manifest
repo sync
```

`repo sync` may take a few moments to run

*Hint:* The **Get the code** step only needs to be done once, i.e. before doing your first tutorial.

<p>
    Next: <a href="hello-world">Hello world</a>
</p>
