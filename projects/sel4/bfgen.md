---
repo: seL4/seL4
include_file: tools/bitfield_gen.md
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# The seL4 Bitfield Generator

The seL4 kernel code and the libsel4 library use the so-called bitfield
generator to automatically produce code and formal proofs for tagged unions and
structs of bitfields from a higher-level specification.

The code for this tool is available in the [seL4 repository] in the [tools]
directory. This page contains the manual of the bitfield generator. The manual
sources are also available for the [tools] directory.

{% include include_github_repo_markdown.md indent_headings=1 %}

[seL4 repository]: https://github.com/seL4/seL4/
[tools]: https://github.com/seL4/seL4/blob/master/tools/
