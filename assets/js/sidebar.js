/*
 * Copyright 2025 Proofcraft Pty Ltd
 * Adapted from mdBook book.js
 *
 * Copyright 2025 Mathieu David <mathieudavid@mathieudavid.org>
 *                Michael-F-Bryan <michaelfbryan@gmail.com>
 *                Matt Ickstadt <mattico8@gmail.com>
 * SPDX-License-Identifier: MPL-2.0
 */

/* Sidebar resizing */

(function sidebar() {
    var body = document.querySelector("body");
    var sidebar = document.getElementById("sidebar");
    var sidebarResizeHandle = document.getElementById("sidebar-handle");
    var sidebarToggle = document.getElementById("burger");
    var firstContact = null;

    sidebarResizeHandle.addEventListener('mousedown', initResize, false);
    sidebarToggle.addEventListener('click', toggleSidebar, false);

    function initResize(e) {
        e.preventDefault();
        window.addEventListener('mousemove', resize, false);
        window.addEventListener('mouseup', stopResize, false);
        body.classList.add('sidebar-resizing');
    }
    function resize(e) {
        var pos = (e.clientX - sidebar.offsetLeft);
        pos = Math.min(pos, window.innerWidth - 100);
        document.documentElement.style.setProperty('--sidebar-width', pos + 'px');
    }
    //on mouseup remove windows functions mousemove & mouseup
    function stopResize(e) {
        body.classList.remove('sidebar-resizing');
        window.removeEventListener('mousemove', resize, false);
        window.removeEventListener('mouseup', stopResize, false);
    }

    function toggleSidebar() {
        let small = window.matchMedia("(width < 64rem)");
        if ((sidebar.classList.contains('lg:flex') && !small.matches) ||
            (sidebar.classList.contains('flex') && small.matches)) {
            hideSidebar();
        } else {
            showSidebar();
        }
    }
    function showSidebar() {
        sidebar.classList.remove('hidden');
        sidebar.classList.add('flex');
        sidebar.classList.add('lg:flex');
    }
    function hideSidebar() {
        sidebar.classList.add('hidden');
        sidebar.classList.remove('flex');
        sidebar.classList.remove('lg:flex');
    }

    document.addEventListener('touchstart', function (e) {
        firstContact = {
            x: e.touches[0].clientX,
            time: Date.now()
        };
    }, { passive: true });

    document.addEventListener('touchmove', function (e) {
        if (!firstContact)
            return;

        var curX = e.touches[0].clientX;
        var xDiff = curX - firstContact.x,
            tDiff = Date.now() - firstContact.time;

        if (tDiff < 250 && Math.abs(xDiff) >= 150) {
            if (xDiff >= 0 && firstContact.x < Math.min(document.body.clientWidth * 0.25, 300))
                showSidebar();
            else if (xDiff < 0 && curX < 300)
                hideSidebar();

            firstContact = null;
        }
    }, { passive: true });
})();


(function tabs() {
    var tabGroups = document.querySelectorAll('.tab-group');

    tabGroups.forEach(function (group) {
        var children = group.children;
        children[2].classList.add('active'); // Activate the first tab by default
        children[3].classList.remove('hidden'); // Show the first tab
    });

    var tabButtons = document.querySelectorAll('.tab-header');
    tabButtons.forEach(function (button) {
        button.addEventListener('click', function () {
            var content = button.nextElementSibling;

            var group = button.parentElement;
            var tabs = group.getElementsByClassName('tab-header');

            for (let tab of tabs) {
                tab.classList.remove('active');
                tab.nextElementSibling.classList.add('hidden');
            };

            button.classList.add('active');
            content.classList.remove('hidden');
        });
    });
})();

(function toc() {
    var toc = document.getElementById('the-toc');
    var tocOpen = document.getElementById('toc-open');
    var tocClose = document.getElementById('toc-close');
    var mainDiv = document.getElementById('main-div');

    if (tocClose) {
        tocClose.addEventListener('click', function () {
            toc.classList.add('hidden');
            toc.classList.remove('xl:block');
            mainDiv.classList.remove('sm:mr-64');
            mainDiv.classList.remove('xl:mr-64');
        });
    }
    if (tocOpen) {
        tocOpen.addEventListener('click', function () {
            toc.classList.remove('hidden');
            mainDiv.classList.add('sm:mr-64');
        });
    }
})();
