---
version: camkes-3.3.0
redirect_from:
  - /camkes_release/CAmkES_3.3.0/
  - /camkes_release/CAmkES_3.3.0.html
project: camkes
parent: /releases/camkes.html
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# CAmkES Version camkes-3.3.0 Release


Announcing the release of `camkes-3.3.0` with the following changes:

camkes-3.3.0 2018-04-11

Using seL4 version 9.0.0

## Changes
* Hardware dataport with large frame sizes issue has been fixed
* Bug fix: Enumerating connections for hierarchical components with custom connection types is now done correctly
* Bug fix: Data structure caching is now correctly invalidated between builds
* Initial CMake implementation for CAmkES.  See the CAmkES test apps for examples.

## Upgrade notes
* No special upgrade requirements.

## Known issues
* Hierarchical components that export dataport connectors create compilation errors as the templates cannot accurately
  tell that the connector of the parent component is exported from the child and no code should be generated.  A
  temporary workaround involves making the dataport connection explicitly available to the parent component.

---



# Full changelog
 Use `git log camkes-3.2.0..camkes-3.3.0` in
<https://github.com/seL4/camkes-tool>

# More details
 See the
[documentation](https://github.com/seL4/camkes-tool/blob/camkes-3.3.0/docs/index.md)
or ask on the mailing list!
