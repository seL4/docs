---
toc: true
redirect_from:
  - /CAmkESInternals
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# CAmkES Internals

## Overview


From the top, the CAmkES tool (typically found in "tools/camkes/camkes.sh") is a program that generates a **single** file that makes up part of the source of an seL4 application. There are a variety of types of files it can generate:

- a capdl spec describing the cap distribution of the entire
        CAmkES spec
- a C file containing generated glue code for a component or
        connector
- a Makefile that knows how to invoke the CAmkES tool to generate
        all the files required to compile the application (besides the
        Makefile itself)

A typical build of a CAmkES application looks like:

1.  Generate makefile (this file will be called "camkes-gen.mk")

2. Invoke generated makefile

    1.  Copy sources into build directory
    2.  Generated glue code for components and connectors
    3.  Compile each component
    4.  Run CapDL filters
    5.  Generate CapDL spec
    6.  Compile CapDL loader

## Caching


Remember that the CAmkES tool only generates one file each time it's
run, and in a single build it's typically run many times. This means,
all the input files must be parsed again for each output file. The CapDL
database is built up by logic in the templates that generate glue code,
which means that when the capdl spec is generated, all the templates
must be re-instantiated to get the spec into the right state. This all
seems to unnecessarily repeat a lot of work.

To get around this, CAmkES contains several caches:

### CAmkES Accelerator


Output files are cached with keys computed from hashes of the CAmkES
spec. This prevents re-generating most files during a single build of a
CAmkES app.

### Data Structure Cache


This stores the AST and CapDL database persistently (using pickle)
across each invocation of the CAmkES tool in a single build of a CAmkES
app. This removes the need to parse the CAmkES spec multiple times in a
single build, and also removes the need to re-instantiate component and
connector templates to re-build the CapDL database.

## Creating Component Address Spaces


CAmkES creates a CapDL spec representing the entire application (ie. all
components and connections). Part of the spec is the hierarchy of paging
objects comprising the address space of each component. This is actually
done by the python CapDL library. After each component is compiled, but
before the CapDL Filters (see below) are applied,
[the python capdl library is invoked (search for get_spec)](https://github.com/seL4/camkes-tool/blob/master/camkes/runner/__main__.py) to inspect
the ELF file produced by compiling the component and create all the
paging structures it needs.


### Collapse Shared Frames


Dataport connections in CAmkES establish a region of shared memory
between components. When a pair of components share memory, there must
be common frames mapped into both of their address spaces. When each
component gets compiled, any dataports are just treated as an
appropriately sized buffer. We need a way to inform the system
initializer (the CapDL Loader) that when setting up these components'
address spaces, to make the vaddr of the symbol associated with the
dataport in each component map to the same physical memory. During
template instantiation, a database of shared memory regions is
populated. The dataport templates all update this database with the
regions of shared memory they require. The "Collapse Shared Frames"
filter queries this database to find all the regions of shared memory,
then updates the CapDL database, changing memory mappings in the address
space of one component, so it points to the frames already mapped into
the address space of the other component. The frames in the first
component are then removed from the spec.

### Remove TCB Caps


CAmkES has the option to prevent components from being given a cap to
their own TCB. This is implemented as a CapDL Filter, which examines the
cspace (CNode hierarchy) of each component (really each TCB, as
components may have several threads), and removes any caps to any TCBs
that are part of that component.

### Guard Pages


This filter adds guard pages around the stacks of all threads. For each
thread in the system, the ELF that contains the program that will run on
that thread contains a symbol identifying the stack for that thread.
This filter looks up the vaddr and size of that symbol in the ELF, and
modifies the CapDL spec to make sure there's no frame mapped in
immediately before or after the stack.

## Template Context


The python-looking functions called from within templates (e.g.
`alloc_cap`, `register_shared_variable`) are actually keys in a dict
defined here:
<https://github.com/seL4/camkes-tool/blob/master/camkes/runner/Context.py>.
There are even some values (such as `seL4_EndpointObject`), modules (such
as `sys`), and seemingly built-in functions (e.g. `zip`) passed through
using this dict. You can update this dict to add new functions to the
template context. Some of these functions are called "in the context" of
the template they are instantiating. That is, for component and
connector templates, the generated code will be part of a single
component (each connector has a separate template for each side of the
connection). The most common example of this is when allocating a cap,
the cnode/cspace that will contain the cap isn't passed to `alloc_cap` in
the template code, but rather implied by the component for which the
template is being instantiated.

### Object Space and Cap Space


A template context is created with an "object space" and "cap space".
These are terms from the python CapDL library. An object space tracks
all the objects that will exist in the system the CapDL spec describes.
There is a single object space for an entire CAmkES application. A cap
space tracks all the caps that will be placed in a particular cspace.
There is one cap space for each component. When calling `alloc_cap` in a
template on behalf of a component, the cap is placed in that component's
cap space. The resulting CapDL spec will include in one of that
component's CNodes, an entry for the allocated cap.

### Template Functions


Here are some of the complicated functions in the template context:

#### alloc_obj(name, type)


Updates the CapDL database to contain a new object with a given name and
type, returning a (python) reference to that object. Doesn't create any
caps.

```
/*- set ep = alloc_obj("my_ep", seL4_EndpointObject) -*/
```

#### alloc_cap(name, object)


Updates the CapDL database, adding a named cap to a given object to the
current component's cap space, returning the CPtr of the cap.
```
// continues from above
/*- set ep_cap = alloc_cap("my_ep_cap", ep) -*/
seL4_Wait(/*? ep_cap ?*/);
```

#### alloc(name, type)


Effectively equivalent `to alloc_cap(name, alloc_obj(name, type))`

## Simple


Simple is an interface in the seL4 libraries for accessing information
about your environment, typically about which capabilities are
available. CAmkES has an implementation of simple which a component can
use to access (some of) its caps. It's implemented as a jinja template:
<https://github.com/seL4/camkes-tool/blob/master/camkes/templates/component.simple.c>

A component instance can be built with this simple implementation by
adding the following to the assembly:
```
configuration {
   instance_name.simple = true;
}
```

## Template Instantiation Order


CAmkES instantiates templates in the following order: makefile,
components, connections, simple, capdl. The makefile has to come first
since it defines the build rules that instantiate all the other
templates. Simple must come after components and connections as it needs
to generate code to give access to caps allocated in component and
connection templates. Capdl must be last as it needs to be run after
compiling all components (including code generated by the simple
template). Since each template may be instantiated while producing any
output file, in order for caching to work correctly, the order of
template instantiation must be deterministic, at least in a single
invocation of the CAmKES-tool.

Note that components and connections will be instantiated in arbitrary
(but deterministic) order. An implication of this, is that if multiple
components want a cap to the same object (e.g. an endpoint which two
components use to communicate), each template that needs to talk about a
cap to the object must first allocate it unless it's already allocated.
This is because you can't talk about a cap to an object until that
object has been allocated. Typically in such a situation, you'll see the
following template code on both sides of the connection:
```
/*- set ep = alloc_obj('ep_obj_name', seL4_EndpointObject) -*/
/*- set ep_cap = alloc_cap('this_components_ep_cap', ep) -*/

// do something with ep_cap
```

Looking at the code, it appears the endpoint will be allocated twice, as
both sides of the connection will call `alloc_obj`. Digging deeper into
the implementation of `alloc_obj`, we see it calls a function called
`guard`. `guard` is a bit of a misnomer. A more appropriate name might be
`allocate_unless_already_allocated`. It checks whether there's already
an object by the given name, returns the object if it exists, otherwise
allocates and returns it.
