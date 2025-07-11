---
redirect_from:
  - /Developing/Building/
project: buildsystem
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# System configuration and building

seL4, CAmkES, and the C support libraries use the [CMake](https://cmake.org/)
family of tools to implement their build system. The seL4 build system refers to a
collection of CMake scripts that manage:

- **system configuration:** configuration options such as platform flags and application settings,
- **dependency structures:** tracking build order dependencies, and
- **builds:** generating binary artefacts that can then be deployed on hardware.

This document covers how to use the seL4 build system to:

- perform system configuration and builds,
- incorporating the build system into a project, and
- produce kernel stand-alone configuration and builds

## CMake basics

For a complete guide to CMake see the [extensive
documentation](https://cmake.org/cmake/help/latest/), but for the purposes here
we will assume a particular workflow with CMake involving out-of-tree builds.

CMake is not itself a build tool, but rather is a build generator. This means
that it generates build scripts, typically Makefiles or Ninja scripts, which
will be then used by a tool like Make or Ninja to perform the actual build.

### Pre-requisites

It is assumed that

- CMake of an appropriate version is installed.
- You are using the Ninja CMake generator.
- You have the [required dependencies](host-dependencies.html) installed to
  build your project and understand how to check out
  [repo](repo-cheatsheet.html) collections.

### Steps

- [Configuring and building seL4 projects](using.html)
- [Incorporating the build system into a project](incorporating.html)

## Interfacing with other build systems

The page on [standalone kernel builds](standalone.html) shows how to generate a
bare kernel binary without user-level image or loader, for use in other build
system or in formal verification. The kernel build system produces `.json` and
`.yaml` files with information on the configuration that was used to produce the
binary, for consumption in other build systems.

## Gotchas

List of easy mistakes that can be made when using CMake

- Configuration files passed to to cmake with `-C` *must* end in `.cmake`,
  otherwise CMake will silently throw away your file
