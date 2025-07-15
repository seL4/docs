/*
 * Copyright 2025 Proofcraft Pty Ltd
 * SPDX-License-Identifier: BSD-2-Clause
 */

(function menu() {
  const menu_titles = document.querySelectorAll('.menu-title');
  for (var i = 0; i < menu_titles.length; i++) {
    menu_titles[i].addEventListener("click", toggleMenu, false);
  }

  function toggleMenu(event) {
    var theButton = event.target.closest('.menu-title');
    var theChevron = theButton.parentElement.getElementsByClassName('menu-chevron')[0];
    var theMenu = theButton.parentElement.getElementsByClassName('menu-content')[0];
    var wasOn = theMenu.classList.contains('on');

    if (wasOn) {
      theMenu.classList.remove("on");
      theChevron.classList.add("rotate-270");
    }
    else {
      theMenu.classList.add("on");
      theChevron.classList.remove("rotate-270");
    }
  }
})();

(function initCopyButtons() {
  const codeBlocks = document.querySelectorAll('div > pre > code');

  for (let codeBlock of codeBlocks) {
    preBlock = codeBlock.parentElement;
    divBlock = preBlock.parentElement;
    const copyButton = document.createElement('button');
    copyButton.setAttribute('aria-label', 'Copy code to clipboard');
    copyButton.setAttribute('title', 'Copy code to clipboard');
    copyButton.setAttribute('type', 'button');
    copyButton.className = 'code-copy';
    copyButton.innerHTML = "Copy";
    divBlock.classList.add('relative');
    divBlock.classList.add('group');
    divBlock.insertBefore(copyButton, preBlock);

    copyButton.addEventListener('click', function () {
      copyToClipboard(copyButton, codeBlock)
    });
  }

  async function copyToClipboard(button, codeBlock) {
    const codeToCopy = codeBlock.innerText;
    try {
      await navigator.clipboard.writeText(codeToCopy);
      button.innerHTML = "Copied!";
      setTimeout(function() {
        button.innerHTML = "Copy";
      }, 1000);
    }
    catch (_) {
      console.warn("Clipboard write failed.");
    }
  }
})();
