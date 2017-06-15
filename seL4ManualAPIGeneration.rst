= seL4 Manual API Generation =

The documentation of the seL4 API in the [[http://sel4.systems/Info/Docs/seL4-manual-latest.pdf|seL4 manual]] is automatically generated from comments in [[https://github.com/seL4/seL4/tree/master/libsel4|libsel4]]'s source code. This page documents this process.

<<TableOfContents()>>

== File Paths ==

This page will use file paths relative to the root of the [[https://github.com/seL4/seL4|seL4 repository]]. In projects cloned using a repo manifest, this will correspond to the `kernel` subdirectory of the top-level directory.

== Types of API ==

seL4 has two types of API:
 * System Calls, mostly concerned with message-passing between threads. Some examples are `Send` and `Recv`
   * In addition to the message-passing syscalls, there are debugging and benchmarking syscalls which can be enabled with a build flag. These are true syscalls, rather than object invocations.
 * Object Invocations, which are regular message-passing system calls, but whose recipient is effectively the kernel itself, and the message encodes some operation on a Kernel Object. Some examples are `TCB_Resume` and `CNode_Copy`.
   * Some kernel objects and object invocations are specific to a particular processor architecture. Some examples are `X86_Page_Map`, and `ARM_VCPU_InjectIrq`.

The process of generating API docs is different between System Calls and Object Invocations, though each process has some parts in common.

== Common ==

=== Approach ===

Documentation for each seL4 API is written in the form of doxygen comments in C header files. The rest of the seL4 manual is written in LaTeX. To generate API documentation for the manual, we generate LaTeX files from doxygen comments which are then included in the manual.

Rather than using doxygen's LaTeX output directly, we use doxygen to generate XML files. A custom script then parses the XML and produces the final LaTeX output. This is because we already have an established style for API documentation in our manual, and it was easier to generate LaTeX in this style ourselves from some simple (ie. easy to parse) intermediate format (ie. XML) rather than try to coerce doxygen into generating perfectly-styled LaTeX.

The script that translates doxygen-generated xml into LaTeX is in: [[https://github.com/seL4/seL4/blob/master/manual/tools/parse_doxygen_xml.py|manual/tools/parse_doxygen_xml.py]].

=== Custom Notation in Doxygen Comments ===

Some parts of the API documentation reference other parts of the manual. Additionally, there are some custom formatting rules we'd like to apply to the API docs in the manual that aren't understood by doxygen. To achieve both these goals, we introduce some additional XML tags which we explicitly add to doxygen comments inside `@xmnonly ... @endxmlonly` blocks.

Here's a description of all the custom tags:
||`<manual name="NAME" label="LABEL"/>`||Introduces documentation for a new function. The title of the section documenting the function will be `NAME`. Other parts of the manual can refer to this function's documentation with `\autoref{sec:LABEL}`||
||`<autoref sec="SEC"/>`||Translated to the latex `\autoref{sec:SEC}`||
||`<shortref sec="SEC"/>`||Translated to the latex `\ref{sec:SEC}`||
||`<errorenumdesc/>`||Translated to the latex `\errorenumdesc`, a custom command defined in [[https://github.com/seL4/seL4/blob/master/manual/parts/api.tex|manual/parts/api.tex]]||
||`<obj name="NAME"/>`||Translated to the latex `\obj{NAME}`, a custom command defined in [[https://github.com/seL4/seL4/blob/master/manual/manual.tex|manual/manual.tex]]||
||`<texttt text="TEXT"/>`||Translated to the latex `\texttt{TEXT}`||

Note that these must appear within `@xmlonly ... @endxmlonly` blocks in order to function.

=== Required Documentation ===

Each function in the API must have the following documentation:
 * a `@xmlonly <manual name="..." label=".../> @endxmlonly` tag with the `name` for use in the manual's text, and a `label` for creating references within the manual
 * a `@brief` description
 * a detailed description
 * a `@param` description of each argument
 * a `@return` description of the return value, unless the function is `void`

=== Detecting Missing Documentation ===

If a required part of a function's documentation is empty, the translation script will insert the LaTeX command `\todo`, defined in [[https://github.com/seL4/seL4/blob/master/manual/parts/api.tex|manual/parts/api.tex]]. It generates the text "TODO" to help readers of the manual identify which parts of the API are undocumented.

== System Calls ==

A prototype for each system call is declared in [[https://github.com/seL4/seL4/blob/master/libsel4/include/sel4/syscalls.h|libsel4/include/sel4/syscalls.h]]. Each prototype is accompanied by a doxygen comment
