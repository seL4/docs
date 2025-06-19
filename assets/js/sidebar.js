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
        if (sidebar.classList.contains('lg:flex')) {
            hideSidebar();
        } else {
            showSidebar();
        }
    }
    function showSidebar() {
        sidebar.classList.remove('hidden');
        sidebar.classList.add('flex');
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
