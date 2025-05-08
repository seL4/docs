/*
 * Copyright 2025 Proofcraft Pty Ltd
 * SPDX-License-Identifier: BSD-2-Clause
 */

/* Menu showing/hiding for sidebar menu. No attempts at genericity, makes DOM
   and seL4.css class name assumptions. */

// global initialisation

const menu_titles = document.querySelectorAll('.menu-title');
for (var i = 0; i < menu_titles.length; i++) {
  menu_titles[i].addEventListener("click", openMenu)
}

// end global init

function firstParentWithClass(element, className) {
  if (element.classList && element.classList.contains(className)) {
    return element;
  }
  if (element.parentElement) {
    return firstParentWithClass(element.parentElement, className);
  }
  return null;
}

function openMenu(event) {
  event.stopPropagation();
  var theButton = firstParentWithClass(event.target, 'menu-title');
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
