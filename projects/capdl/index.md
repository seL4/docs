---
toc: true
redirect_from:
  - /CapDL

project: capdl
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# CapDL

CapDL is the "Capability Distribution Language". It's used to describe
the kernel objects an seL4 application needs, and how capabilities to
those objects will be distributed.

All CapDL-related projects are in this repo:
<https://github.com/sel4/capdl>

## Example Spec
```
arch ia32

objects {

  my_tcb = tcb
  my_cnode = cnode (3 bits)
  my_frame = frame (4k, paddr: 0x12345000) // paddr is optional
  my_page_table = pt
  my_page_directory = pd

}

caps {

  // Specify cap addresses (ie. CPtrs) in cnodes.
  my_cnode {
    1: my_tcb
    2: my_frame
    3: my_page_table
    4: my_page_directory
  }

  // Specify address space layout.
  // With 4gb page directories, 4mb page tables, and 4kb frames,
  // the frame at paddr 0x12345000 will be mapped at vaddr 0xABCDE000.
  my_pd {
    0x2AF: my_pt
  }
  my_pt {
    0xDE: my_frame
  }

  // Specify root cnode and root paging structure of thread.
  my_tcb {
    vspace: my_pd
    cspace: my_cnode
  }

}
```

## CapDL Translator (capDL-tool) [[Readme](translator)]


This program transforms a CapDL spec into several formats:

- a C file for linking against the CapDL Loader to create a
        program that instantiates the system described by the spec
- a dot file for visualization with graphviz
- an XML file for further manipulation
- an isabelle model for use in proofs about the system described
        by the spec

## CapDL Loader (capdl-loader-app) [[Readme](c-loader-app)]


The CapDL Loader is a program that initializes the seL4 user-level
environment to match the system described by a CapDL spec, and loads
programs from ELFs in a provided cpio archive. It's intended to be run
as the root task (ie. first user-level thread with access to all
resources).

The CapDL Loader must be linked against a CapDL spec - the C output of
the CapDL Translator. It must also be linked against a cpio archive
containing ELF images. It creates objects and distributes caps as per
the spec (if enough resources are available), and then loads programs
into memory at locations specified by the spec. Finally, it starts all
the threads it created and sleeps forever.

## Python CapDL Library (python-capdl-tool) [[Readme](python-tool)]


This library allows one to build up an in-memory database storing the
same information as a capdl spec. This is useful as it allows capdl
specs to be generated programmatically, and allows the programmer to
incrementally add information about kernel objects and capability
distribution. This library is used by [CAmkES](/CAmkES/) to build up a spec
describing the entire system (all components and connections).

## CMake libsel4 object size yaml generation target [[Readme](object-sizes)]

This is a CMake target that generates a yaml file containing seL4 object-size
and other constant definitions that have been extracted from the libsel4
preprocessor macro definitions.

## CapDL util scripts [[Readme](cdl-utils)]

A collection of standalone scripts for using capDL in build scripts.
