---
archive: true
redirect_from:
  - /HardwareHacks
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Hardware Hacks
We have built various bits and pieces to enable easier use of our
hardware. Some of these are documented here in case others might find
them useful. The issue is that we want our embedded hardware to be
shareable between multiple users and an automated test harness. The
manufacturers of most of our gadgets assume we're going to be using a
TTL to USB serial converter and Fastboot; this doesn't scale, as when
you have several plugged in, the enumeration order is not fixed, so
there's no way to tell which of many gadgets you are talking to.

The general approach we take is:

1.  As far as possible, boot everything on power-up via DHCP and
    TFTP
2.  Connect a debug serial port via a [Level Converter](level-converter) to a Lantronix
    serial concentrator. An ETS16P for example provides 16
    RS422/RS232 ports, and can be obtained for less than $100
    on eBay.
3.  Connect power for each device via a network-controllable switch.
    For most of our gadgets we're using a cubieTruck and an pair of
    arduino-connected 8-way relay boards, hooked up to an old AT
    power supply top give 5V or 12V depending on each
    board's requirements. It doesn't matter much provided that via
    the network, one can turn on, turn off, and query the power
    state of a particular port.

We use a set of MachineQueue scripts to arbitrate access to the various
gadgets.

A few machines already have a base-management-controller; if they have
it we use it.

One machine, the CMA34D, needed some extras; they are documented on
[CMA34DBMC](../../CMA34DBMC/).
