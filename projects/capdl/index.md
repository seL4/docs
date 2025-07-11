---
redirect_from:
  - /CapDL

project: capdl
repo_link: https://github.com/sel4/capdl/blob/master
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
mathjax: true
---

# Capability Distribution Language (capDL)

capDL stands for *capability distribution language*. It is used to describe the
kernel objects an seL4 application needs and the distribution of capabilities in
the system. This defines which parts of the system have capabilities to which
other parts of the system, and therefore defines the access control boundaries
of the system for integrity and confidentiality.

capDL specifications provide a clean interface for system initialisation and
capability reasoning. Their key feature is that they describe the desired state
of the system declaratively. That means, creating such system states via seL4
system calls is done by a separate loader application that can be formally
verified once. In addition, capability distributions in seL4 determine what
future states of the system are possible. This allows formal reasoning tools to,
directly from a capDL specification, decide questions such as
*"Can component X ever gain access to resource Y in the future?"*.

The next few sections give an overview of the [tools and
libraries](#capdl-translator) that are available and show an [example capDL
specification](#example-spec).

Sources for the capDL tools and libraries are available here:
<https://github.com/sel4/capdl>

See the research paper by [Kuz et al (2010)] for more in-depth information on
the purpose and design of capDL.

## capDL Translator

This program transforms a capDL spec into several formats:

- a C header file for linking against the capDL Loader to create a program that
  instantiates the system described by the spec
- a dot file for visualisation with `graphviz`
- an XML file for further manipulation
- an formal model in the Isabelle/HOL proof assistant for use in proofs about
  the system described by the spec

The tool is written Haskell and can be used as a stand-alone binary. See the
repository [README]({{page.repo_link}}/translator/README.md) for information on
how to build and run the tool.

## capDL Loader

The capDL Loader is a program that initialises the seL4 user-level environment
to match the system described by a capDL spec, and loads programs from ELFs in a
provided `cpio` archive. It is intended to be run as the root task, that is, the
first user-level thread, which has access to all resources.

The capDL Loader must be linked against a capDL spec - the C output of the capDL
Translator. It must also be linked against a cpio archive containing ELF images.
It creates objects and distributes caps as per the spec (if enough resources are
available), and then loads programs into memory at locations specified by the
spec. Finally, it starts all the threads it created and sleeps forever.

See also the separate [capDL loader page](c-loader-app.html).

## Python capDL Library

This library is useful for building up a representation of a capDL state
programmatically in memory and then writing that as a specification to disk. It
allows the programmer to incrementally add information about kernel objects and
capability distribution. The library is used by [CAmkES](../camkes/) to build up a
spec describing the entire system, covering all components and connections.

See the repository [README]({{page.repo_link}}/python-capdl-tool/README.md)
for information on this library.

There is also a `cmake` target for generating object sizes and various utilities
for using capDL in build scrips available in the [repository](https://github.com/sel4/capdl).


## Example Spec

Below is an example capDL specification that describes an AArch32 system
with five kernel objects: a TCB, a CNode of size $2^3$, one 4K Frame with a
specified physical address, one page table, and one page directory. The
`caps` section of the spec describes the content of those objects in terms
of references (capabilities) to other objects.

The capDL translator tool can transform this specification into other formats,
for instance for consumption by the capDL loader. These specifications do not
need to be written manually, they are typically generated from other tools, for
instance with the help of the Python capDL library.

For more detail on how these specification work, see also the [language
specification for capDL](lang-spec.html).

```capdl
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

[Kuz et al (2010)]: https://trustworthy.systems/publications/nicta_full_text/3679.pdf "capDL: A language for describing capability-based systems"
