= CAmkES Internals =

== Overview ==

From the top, the CAmkES tool (typically found in "tools/camkes/camkes.sh") is a program that generates a '''single''' file that makes up part of the source of a seL4 application. There are a variety of types of files it can generate:
 * a capdl spec describing the cap distribution of the entire CAmkES spec
 * a C file containing generated glue code for a component or connector
 * a Makefile that knows how to invoke the CAmkES tool to generate all the files required to compile the application (besides the Makefile itself)

A typical build of a CAmkES application looks like:
 1. Generated makefile (this file will be called "camkes-gen.mk")
 2. Invoke generated makefile
  1. Copy sources into build directory
  2. Generated glue code for components and connectors
  3. Compile each component
  4. Run CapDL filters
  5. Generate CapDL spec
  6. Compile CapDL loader

== Caching ==

Remember that the CAmkES tool only generates one file each time it's run, and in a single build it's typically run many times. This means, all the input files must be parsed again for each output file. The CapDL database is built up by logic in the templates that generate glue code, which means that when the capdl spec is generated, all the templates must be re-instantiated to get the spec into the right state. This all seems to unnecessarily repeat a lot of work.

To get around this, CAmkES contains several caches:

=== CAmkES Accelerator ===

Output files are cached with keys computed from hashes of the CAmkES spec. This prevents re-generating most files during a single build of a CAmkES app.

=== Data Structure Cache ===

This stores the AST and CapDL database persistently (using pickle) across each invocation of the CAmkES tool in a single build of a CAmkES app. This removes the need to parse the CAmkES spec multiple times in a single build, and also removes the need to re-instantiate component and connector templates to re-build the CapDL database.

== Creating Component Address Spaces ==

CAmkES creates a CapDL spec representing the entire application (ie. all components and connections). Part of the spec is the hierarchy of paging objects comprising the address space of each component. This is actually done by the python CapDL library. After each component is compiled, but before the CapDL Filters (see below) are applied, [[https://github.com/seL4/camkes-tool/blob/master/camkes/runner/__main__.py#L521|the python capdl library is invoked]] to inspect the ELF file produced by compiling the component and create all the paging structures it needs.

== CapDL Filters ==

The [[https://github.com/seL4/camkes-tool/blob/master/camkes/runner/Filters.py|CapDL Filters]] stage of the CAmkES build process deserves special mention. These are transformations on the CapDL database that take place before creating the CapDL spec file and building the CapDL Loader. Here's a description of some of the filters:

=== Collapse Shared Frames ===

Dataport connections in CAmkES establish a region of shared memory between components. When a pair of components share memory, there must be common frames mapped into both of their address spaces. When each component gets compiled, any dataports are just treated as an appropriately sized buffer. We need a way to inform the system initializer (the CapDL Loader) that when setting up these components' address spaces, to make the vaddr of the symbol associated with the dataport in each component map to the same physical memory. 
