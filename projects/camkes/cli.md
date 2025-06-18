---
parent: /projects/camkes/
redirect_from:
  - /CAmkESCLI
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# CAmkES CLI


The CAmkES CLI is a command line tool for initialising and managing
CAmkES projects. It's loosely based on the rust build tool "cargo". It's
structured as a command line tool with numerous subcommands. Usage for
each can be viewed with `camkes-cli <subcommand> --help`.

For an example project that can be managed by the CLI, see:
<https://github.com/SEL4PROJ/camkes-cli-example>

## Examples


### Create a new project from a template (creates new directory named
"hello")


```
camkes-cli new hello --template hello_world
```

### Initialise a fresh checkout of existing project
```
git clone https://github.com/SEL4PROJ/camkes-cli-example
cd camkes-cli-example
camkes-cli init
```

### Build a project for x86 (run from inside project directory)


```
camkes-cli build x86
```

### Run a project in qemu-system-i386 (builds first)


```
camkes-cli run x86
```

### Generate boilerplate for a component named BlahServer with some
interfaces
```
camkes-cli component BlahServer --dataport Buf b --consumes Signal sig
```
