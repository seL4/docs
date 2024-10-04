// SPDX-License-Identifier: CC-BY-SA-4.0
// Copyright 2024 seL4 Project a Series of LF Projects, LLC.

// Expand all solutions
let param = new URLSearchParams(window.location.search);

if (param.has('tut_expand')) {
        document.body.querySelectorAll('details').forEach((e) => {
        e.setAttribute('open', true);
    })
}
