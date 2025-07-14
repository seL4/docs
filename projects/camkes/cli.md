---
parent: /projects/camkes/
redirect_from:
  - /CAmkESCLI
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# CAmkES CLI

The CAmkES CLI is a command line tool for initialising and managing CAmkES
projects. It is loosely based on the rust build tool "cargo". It is structured
as a command line tool with various subcommands. Usage for each can be viewed
with `camkes-cli <subcommand> --help`.

For an example project that can be managed by the CLI, see:
<https://github.com/sel4proj/camkes-cli-example>

## Examples

### Create a new project from a template


This creates new directory named `hello`.

```sh
camkes-cli new hello --template hello_world
```

### Initialise a fresh checkout of existing project

```sh
git clone https://github.com/sel4proj/camkes-cli-example
cd camkes-cli-example
camkes-cli init
```

### Build a project for x86

Run from inside project directory:

```sh
camkes-cli build x86
```

### Run a project in qemu-system-i386 (builds first)

```sh
camkes-cli run x86
```

### Generate boilerplate for a component

Generate boilerplate for a component named BlahServer with some interfaces:

```sh
camkes-cli component BlahServer --dataport Buf b --consumes Signal sig
```
