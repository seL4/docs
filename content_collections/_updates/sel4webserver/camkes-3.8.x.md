---
project: sel4webserver
title: "camkes-3.8.x-compatible"
archive: true
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Updates to sel4webserver from camkes-3.7.x to camkes-3.8.0

- Created `sel4webserver` project containing an seL4 webserver application. Its purpose is to be a reference for implementing applications on seL4.
  - This project currently builds an odroid-xu4 VM that runs linux and gets some devices passed through to it.
- Add `lighttpd` module. This module will build and install a static binary of the `lighttpd`
  webserver into a VM overlay. It is currently configured to serve a
  static site on port `3000` out of `/run/site` in the VM.
- Add `docsite` package that downloads, builds and packages a
  `docs.sel4.systems` static website. It is intended for being served by the
  `lighttpd` webserver added previously.
