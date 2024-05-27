// SPDX-License-Identifier: CC-BY-SA-4.0
// Copyright 2024 seL4 Project a Series of LF Projects, LLC.

// Expand all solutions if previous link was how-to page

let text = document.referrer;
let result = text.includes("Tutorials/Resources/how-to");

if (result==true){
    document.body.querySelectorAll('details')
      .forEach((e) => {(e.hasAttribute('open')) ?
        e.removeAttribute('open') : e.setAttribute('open',true);
        console.log(e.hasAttribute('open'))
      })
}