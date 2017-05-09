= seL4 Driver API Persistent Device Naming Scheme =

Recommended prior reading for this page is the seL4 Driver API's [[seL4 Driver API/Child Enumeration#Addressing Names|Device location addressing scheme]].

== Contents ==
<<TableOfContents()>>

== Constants ==

== Functions ==

== Data structures ==

== Description ==

The seL4 Driver API requires the use of a persistent naming scheme which forms the basis of the IPC connection system between device instances. It is through this naming scheme that a device instance can call to its parent devices, and communicate with devices with which it has lateral dependencies.

Devices are named by the parent driver that enumerates them. Child device enumeration is discussed in detail in the [[seL4 Driver API/Child Enumeration#Addressing Names|Child Enumeration]] article.
