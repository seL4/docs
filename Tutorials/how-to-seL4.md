---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2024 seL4 Project a Series of LF Projects, LLC.
---

# How-to guide for seL4

This guide provides links to the seL4 tutorial solutions as a quick references
for seL4 calls and methods.

{% assign url = "capabilities.html?tut_expand" %}

## [Capabilities]({{ url }})

- [Calculate the size of a CSpace]({{ url }}#how-big-is-your-cspace)
- [Copy a capability between CSlots]({{ url }}#copy-a-capability-between-cslots)
- [Delete a capability]({{ url }}#how-do-you-delete-capabilities)
- [Suspend a thread]({{ url }}#suspend-a-thread)

{% assign url = "untyped.html?tut_expand" %}

## [Untyped]({{ url }})

- [Create an untyped capability]({{ url }}#create-an-untyped-capability)
- [Create a TCB object]({{ url }}#create-a-tcb-object)
- [Create an endpoint object]({{ url }}#create-an-endpoint-object)
- [Create a notification object]({{ url }}#create-a-notification-object)
- [Delete an object]({{ url }}#delete-the-objects)

{% assign url = "mapping.html?tut_expand" %}

## [Mapping]({{ url }})

- [Map a page directory]({{ url }}#map-a-page-directory)
- [Map a page table]({{ url }}#map-a-page-table)
- [Remap a page]({{ url }}#remap-a-page)
- [Unmap a page]({{ url }}#unmapping-pages)

{% assign url = "threads.html?tut_expand" %}

## [Threads]({{ url }})

- [Configure a TCB]({{ url }}#configure-a-tcb)
- [Change the priority of a thread]({{ url }}#change-priority-via-sel4_tcb_setpriority)
- [Set initial register state]({{ url }}#set-initial-register-state)
- [Start the thread]({{ url }}#start-the-thread)
- [Set the arguments of a thread]({{ url }}#passing-arguments)
- [Resolve a fault]({{ url }}#resolving-a-fault)

{% assign url = "ipc.html?tut_expand" %}

## [IPC]({{ url }})

- [Use capability transfer to send the badged capability]({{ url }}#use-capability-transfer-to-send-the-badged-capability)
- [Get a message]({{ url }}#get-a-message)
- [Reply and wait]({{ url }}#reply-and-wait)
- [Save a reply and store reply capabilities]({{ url }}#save-a-reply-and-store-reply-capabilities)

{% assign url = "notifications.html?tut_expand" %}

## [Notifications]({{ url }})

- [Set up shared memory]({{ url }}#set-up-shared-memory)
- [Signalling]({{ url }}#signal-the-producers-to-go)
- [Differentiate signals]({{ url }}#differentiate-signals)

{% assign url = "interrupts.html?tut_expand" %}

## [Interrupts]({{ url }})

- [Invoke IRQ control]({{ url }}#invoke-irq-control)
- [Set NTFN]({{ url }}#set-ntfn)
- [Acknowledge an interrupt]({{ url }}#acknowledge-an-interrupt)

{% assign url = "fault-handlers.html?tut_expand" %}

### [Fault handling]({{ url }})

- [Set up an endpoint for thread fault IPC messages]({{ url }}#setting-up-the-endpoint-to-be-used-for-thread-fault-ipc-messages)
- [Receive an IPC message from the kernel]({{ url }}#receiving-the-ipc-message-from-the-kernel)
- [Get information about a thread fault]({{ url }}#finding-out-information-about-the-generated-thread-fault)
- [Handle a thread fault]({{ url }}#handling-a-thread-fault)
- [Resume a faulting thread]({{ url }}#resuming-a-faulting-thread)

{% assign url = "mcs.html?tut_expand" %}

## [MCS]({{ url }})

- [Set up a periodic thread]({{ url }}#periodic-threads)
- [Unbind a scheduling context]({{ url }}#unbinding-scheduling-contexts)
- [Experiment with sporadic tasks]({{ url }}#sporadic-threads)
- [Use passive servers]({{ url }}#passive-servers)
- [Configure fault endpoints]({{ url }}#configuring-a-fault-endpoint-on-the-mcs-kernel)
