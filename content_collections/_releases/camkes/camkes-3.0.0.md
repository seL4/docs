---
version: camkes-3.0.0
redirect_from:
  - /camkes_release/CAmkES_3.0.0/
  - /camkes_release/CAmkES_3.0.0.html
project: camkes
parent: /releases/camkes.html
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# CAmkES 3.0.0 Release Notes


This adds all the features from our development branch "next". Changes
include several syntactic and functional changes. The development of new
features will now continue on the "master" branch, and the "next" branch
will remain as is for compatibility reasons.

## Migrating


How you migrate will depend on your situation:

### I was using the "next" branch and want to switch to this release


Hopefully most people will be in this category. Now that we've
(finally!) done an official release of CAmkES 3, you can switch to a
stable tag with all the features of "CAmkES Next", without the risk of
api breaking changes. If you use repo, your manifest probably has a line
resembling:
```xml
<project name="camkes-tool.git" path="tools/camkes" revision="next">
```

Change it to:
```xml
<project name="camkes-tool.git" path="tools/camkes" revision="refs/tags/camkes-3.0.0">
```

Watch the mailing list for new releases, and update your version of
CAmkES when **you** want to.

### I was using the "next" branch, and want to stay on the bleeding edge

You need to switch to the "master" branch. The "next" branch will
continue to exist for a time for compatibility, but will no longer
receive updates. If you use repo, your manifest probably has a line
resembling:
```xml
<project name="camkes-tool.git" path="tools/camkes" revision="next">
```

Change it to:
```xml
<project name="camkes-tool.git" path="tools/camkes">
```

Note that tracking the tip of the "master" branch is risky. There's no
guarantee that it won't change in breaking ways in the future.

### I was using the "master" branch, and want to migrate


There's a guide on the changes introduces by this version here:
[CAmkESDifferences](../CAmkESDifferences)

### I was using the "master" branch, and don't want to migrate


That's fine! All the old versions of CAmkES will continue to be
available. The latest release of this branch is
[camkes-2.3.1](https://github.com/seL4/camkes-tool/releases/tag/camkes-2.3.1).
If you use repo, your manifest probably had a line resembling:
```xml
<project name="camkes-tool.git" path="tools/camkes">
```

Change it to:
``` <project name="camkes-tool.git" path="tools/camkes"
revision="refs/tags/camkes-2.3.1">
```

### I was using a released version of CAmkES


You don't have to do anything. Your project will continue to work.

## New Dependencies


CAmkES dependencies have changed. For a definitive (maintained) list,
see: [CAmkES#build-dependencies](/CAmkES/#build-dependencies)

## New Features


### Visualization Tool


CAmkES comes with a graphical tool for visualising the components and
connections in a CAmkES application. For installation and usage
instructions,
[see its README](https://github.com/seL4/camkes-tool/tree/camkes-3.0.0/camkes/visualCAmkES).

### Typed Settings


Previously, the values of settings (in "configuration" blocks) were
strings under the hood. Now they are stored as a value of the
appropriate (python) type, determined during parsing.
[Read more.](../CAmkESDifferences#rich-types-for-settings)

### Parametrised Buf Type


The "Buf" type for dataports can now be optionally parametrised with the
dataport's size in bytes.
[Read more.](../CAmkESDifferences#parametrised-buf-type)

### The seL4Asynch connector has been renamed to seL4Notification


This was to maintain consistency with the rest of our APIs.

### Non Volatile Dataports


Previously, the standard dataport connector, seL4SharedData, use
volatile pointers for accessing shared memory. This is no longer the
case, and components with dataport interfaces connected with
seL4SharedData must explicitly insert barriers around dataport access to
ensure the desired memory access ordering.
[Read more in the manual.](https://github.com/seL4/camkes-tool/blob/camkes-3.0.0/docs/index.md#an-example-of-dataports)

### Custom Attribute Types


You can now define custom types for attributes in CAmkES ADL. Custom
types resemble structs and arrays in C.
[Read more in the manual.](https://github.com/seL4/camkes-tool/blob/camkes-3.0.0/docs/index.md#an-example-of-structs-and-arrays-for-collections)

### Hierarchical Component Syntax Change


The syntax for declaring that a component exports an interface from one
of it sub-components has changed.
[See an example.](../CAmkESDifferences#hierarchical-components)

### Binary Semaphores


Binary Semaphores have been added as a new synchronization primitive.
This is in addition to the existing primitives: semaphores and mutexes.
[Read more in the manual.](https://github.com/seL4/camkes-tool/blob/camkes-3.0.0/docs/index.md#synchronization-primitives)

### Cache Accelerator


CAmkES now comes with a small tool for caching compilation results based
on source files. This should greatly reduce compilation times by not
unnecessarily recompiling code. It is enabled by default. Control it
with the `CONFIG_CAMKES_ACCELERATOR` config variable.
[Read more in the manual.](https://github.com/seL4/camkes-tool/blob/camkes-3.0.0/docs/index.md#cache-accelerator)

### Python 3 Support


Previously, CAmkES only worked with python2. It's now compatible with
python2 and python3.

### Refactored Parser


The internals of the CAmkES parser have been rewritten to be easier to
read and maintain. The parser is structured as a pipeline of
transformations.
[Read more in the manual.](https://github.com/seL4/camkes-tool/blob/camkes-3.0.0/docs/index.md#parser-internals)
