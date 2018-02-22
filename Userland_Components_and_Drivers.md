# Userland Components and Drivers


This page lists and tracks the various user-level libraries and
components that are available to use in seL4 system.

## Libraries vs Components


We generally put generic device driver and component code into
libraries, so that they can be used in various scenarios (in native seL4
processes, in CAmkES components, linked directly with clients, etc.).

Specific CAmkES components, seL4 processes, etc. wrap around the
functionality provided by these libraries, performing relevant
initialisation, etc. and providing the library's functionality as a
service.

Below we list the various drives and other userland functionality we
provide, and note whether it is available as a library, as a component,
or in some other form. We also link to where it can be found.

## Device Drivers


|| '''description''' || '''platform''' || '''type''' || '''location'''
|| ''' comment''' || || CAN (MCP2515) || N/A || component || || || ||
Ethernet (e1000) || x86 || library || || || || Ethernet (...) ||
Sabre-Lite || library || || || || MMC (...) || Obroid-XU || component?
|| || || || I2C (...) || Odroid-XU || component || || || || SD (...) ||
Sabre-Lite || library? || || || || SPI (...) || Odroid-XU || component?
|| || || || SPI (...) || TK1 || component? || || || || timer (PIT) ||
x86 || library || || || || timer (EPIT) || Sabre-Lite || library || ||
|| || timer (PWM) || Odroid-XU || library || || || || timer (NVTMR) ||
TK1 || library || || || || UART (...) || x86 || library || || || || UART
(...) || Sabre-Lite || library || || || || UART (...) || Odroid-XU ||
library || || || || UART (...) || TK1 || library || || || || USB (...)
|| x86, Odroid-XU || library || || ||

## Other Libraries and Components


|| '''description''' || ''platform''' || '''type''' ||'''location''' ||
|| TCP/IP (LwIP) || x86 || library || || || TCP/IP (picoTCP) || x86 ||
library || || || UDP Server (LwIP) || x86 || component || || || UDP
Server (picoTCP) || x86 || component || || VMM & VM || x86 || library,
component || || || VMM & VM || Odroid-XU, TK1 || library, component ||
