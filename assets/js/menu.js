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
