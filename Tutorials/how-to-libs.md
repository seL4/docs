---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2024 seL4 Project a Series of LF Projects, LLC.
---

# How-to guide for the seL4 C libraries

This guide provides links to tutorial solutions as quick references for the seL4
C prototyping libraries.

{% assign url = "libraries-1.html?tut_expand" %}

## [Initialisation  & threading]({{ url }})

- [Obtain BootInfo]({{ url }}#obtain-bootinfo)
- [Initialise simple]({{ url }}#initialise-simple)
- [Use simple to print BootInfo]({{ url }}#use-simple-to-print-bootinfo)
- [Initialise an allocator]({{ url }}#initialise-an-allocator)
- [Obtain a generic allocation interface (vka)]({{ url }}#obtain-a-generic-allocation-interface-vka)
- [Find the CSpace root cap]({{ url }}#find-the-cspace-root-cap)
- [Find the VSpace root cap]({{ url }}#find-the-vspace-root-cap)
- [Allocate a TCB Object]({{ url }}#allocate-a-tcb-object)
- [Configure the new TCB]({{ url }}#configure-the-new-tcb)
- [Name the new TCB]({{ url }}#name-the-new-tcb)
- [Set the instruction pointer]({{ url }}#set-the-instruction-pointer)
- [Set the stack pointer]({{ url }}#set-the-stack-pointer)
- [Write the registers]({{ url }}#write-the-registers)
- [Start the new thread]({{ url }}#start-the-new-thread)
- [Print]({{ url }}#print-something)

{% assign url = "libraries-2.html?tut_expand" %}

## [IPC]({{ url }})

- [Allocate an IPC buffer]({{ url }}#allocate-an-ipc-buffer)
- [Allocate a page table]({{ url }}#allocate-a-page-table)
- [Map a page table]({{ url }}#map-a-page-table)
- [Map a page]({{ url }}#map-a-page)
- [Allocate an endpoint]({{ url }}#allocate-an-endpoint)
- [Badge an endpoint]({{ url }}#badge-an-endpoint)
- [Set a message register]({{ url }}#message-registers)
- [Send and wait for a reply]({{ url }}#ipc)
- [Receive a reply]({{ url }}#receive-a-reply)
- [Receive an IPC]({{ url }}#receive-an-ipc)
- [Validate a message]({{ url }}#validate-the-message)
- [Write the message registers]({{ url }}#write-the-message-registers)
- [Reply to a message]({{ url }}#reply-to-a-message)

{% assign url = "libraries-3.html?tut_expand" %}

## [Processes & Elf loading]({{ url }})

- [Create a VSpace object]({{ url }}#virtual-memory-management)
- [Configure a process]({{ url }}#configure-a-process)
- [Get a CSpace path]({{ url }}#get-a-cspacepath)
- [Badge a capability]({{ url }}#badge-a-capability)
- [Spawn a process]({{ url }}#spawn-a-process)
- [Receive a message]({{ url }}#receive-a-message)
- [Send a reply]({{ url }}#send-a-reply)
- [Initiate communications by using seL4_Call]({{ url }}#client-call)

{% assign url = "libraries-4.html?tut_expand" %}

## [Timer]({{ url }})

- [Allocate a notification object]({{ url }}#allocate-a-notification-object)
- [Initialise a timer]({{ url }}#initialise-the-timer)
- [Use a timer]({{ url }}#use-the-timer)
- [Handle an interrupt]({{ url }}#handle-the-interrupt)
- [Destroy a timer]({{ url }}#destroy-the-timer)
