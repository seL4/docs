---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Licensing

The code and documentation in the repositories of the [seL4 GitHub
organisation][seL4-org] are available under standard open-source licenses,
identified by [SPDX license tags][SPDX].

The seL4 Foundation licenses and accepts contributions for

- the seL4 kernel itself under [GPL Version 2][GPL-2.0-only],
- user code and proof libraries under the [BSD 2 Clause license][BSD-2-Clause],
- code and proofs that depend on GPL-code or GPL-proofs under GPL,
- documentation under [Creative Commons Attribution-ShareAlike][CC-BY-SA-4.0].

Note that, as in the [Linux syscall note for the GPL][GPL-note], the seL4 kernel
GPL license does *not* cover user-level code that uses kernel services by normal
system calls - this is merely considered normal use of the kernel, and does
*not* fall under the heading of "derived work". Syscall headers are provided
under BSD.

For a longer explanation of how the seL4 license does or does not affect your
own code see also [this blog post][license-blog].

The repositories of the seL4 GitHub organisation also contain third-party code
under additional compatible open source licenses. See the individual file
headers for details, or use one of the publicly available [SPDX] tools to
generate a software bill of materials. The directory `LICENSES/` in each repository
contains the text for all licenses that are mentioned by files in that
repository.


[seL4-org]: https://github.com/seL4/
[GPL-2.0-only]: https://spdx.org/licenses/GPL-2.0-only.html
[BSD-2-Clause]: https://spdx.org/licenses/BSD-2-Clause.html
[CC-BY-SA-4.0]: https://spdx.org/licenses/CC-BY-SA-4.0.html
[SPDX]: https://spdx.org
[GPL-note]: https://spdx.org/licenses/Linux-syscall-note.html
[license-blog]: https://microkerneldude.wordpress.com/2019/12/09/what-does-sel4s-license-imply/
