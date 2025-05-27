---
redirect_from:
  - /SeL4Libraries

project: user_libs
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Internal Libraries


We have four major collections of libraries developed in house:

- **[seL4_libs](https://github.com/seL4/seL4_libs)**:
      seL4 specific libs that were started before the open sourcing of
      seL4
- **[util_libs](https://github.com/seL4/util_libs)**: OS
      independent libs that were started before the open sourcing of
      seL4
- **[seL4_projects_libs](https://github.com/seL4/seL4_projects_libs)**:
      seL4 specific libs that were started after the open sourcing of
      seL4 - new libraries should go here.
- **[projects_libs](https://github.com/seL4/projects_libs)**:
      OS independent libs that were started after the open source of
      seL4 - new OS independent libs should go here.

Please see the specific readmes of each library collection for more
detail.

# External libraries


We keep external libraries in non-condensed repos so that it is trivial
to pull in upstream changes.

- **[libmuslc](https://github.com/seL4/libmuslc)** - the
      c library we use.
- ...

