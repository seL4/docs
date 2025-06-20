---
layout: tutorial
description: how-to guide with links to tutorial solutions
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2024 seL4 Project a Series of LF Projects, LLC.
---
# <em>How to:</em> A quick solutions guide
This guide provides links to tutorial solutions as quick references for seL4 calls and methods.

[//]: # (<html><a href="no-javascript.html" title="Get some foo!">Show me some foo</a></html>)

## The seL4 kernel

{% assign url = "capabilities?tut_expand" %}
### [Capabilities]({{ url }})

 - [Calculate the size of a CSpace]({{ url }}#how-big-is-your-cspace)
 - [Copy a capability between CSlots]({{ url }}#copy-a-capability-between-cslots)
 - [Delete a capability]({{ url }}#how-do-you-delete-capabilities)
 - [Suspend a thread]({{ url }}#suspend-a-thread)

{% assign url = "untyped?tut_expand" %}
### [Untyped]({{ url }})

 - [Create an untyped capability]({{ url }}#create-an-untyped-capability)
 - [Create a TCB object]({{ url }}#create-a-tcb-object)
 - [Create an endpoint object]({{ url }}#create-an-endpoint-object)
 - [Create a notification object]({{ url }}#create-a-notification-object)
 - [Delete an object]({{ url }}#delete-the-objects)

{% assign url = "mapping?tut_expand" %}
### [Mapping]({{ url }})
- [Map a page directory]({{ url }}#map-a-page-directory)
- [Map a page table]({{ url }}#map-a-page-table)
- [Remap a page]({{ url }}#remap-a-page)
- [Unmap a page]({{ url }}#unmapping-pages)

{% assign url = "threads?tut_expand" %}
### [Threads]({{ url }})
- [Configure a TCB]({{ url }}#configure-a-tcb)
- [Change the priority of a thread]({{ url }}#change-priority-via-sel4_tcb_setpriority)
- [Set initial register state]({{ url }}#set-initial-register-state)
- [Start the thread]({{ url }}#start-the-thread)
- [Set the arguments of a thread]({{ url }}#passing-arguments)
- [Resolve a fault]({{ url }}#resolving-a-fault)

{% assign url = "ipc?tut_expand" %}
### [IPC]({{ url }})
 - [Use capability transfer to send the badged capability]({{ url }}#use-capability-transfer-to-send-the-badged-capability)
 - [Get a message]({{ url }}#get-a-message)
 - [Reply and wait]({{ url }}#reply-and-wait)
 - [Save a reply and store reply capabilities]({{ url }}#save-a-reply-and-store-reply-capabilities)

{% assign url = "notifications?tut_expand" %}
### [Notifications]({{ url }})
 - [Set up shared memory]({{ url }}#set-up-shared-memory)
 - [Signalling]({{ url }}#signal-the-producers-to-go)
 - [Differentiate signals]({{ url }}#differentiate-signals)

{% assign url = "interrupts?tut_expand" %}
### [Interrupts]({{ url }})
 - [Invoke IRQ control]({{ url }}#invoke-irq-control)
 - [Set NTFN]({{ url }}#set-ntfn)
 - [Acknowledge an interrupt]({{ url }}#acknowledge-an-interrupt)

{% assign url = "fault-handlers?tut_expand" %}
### [Fault handling]({{ url }})
 - [Set up an endpoint for thread fault IPC messages]({{ url }}#setting-up-the-endpoint-to-be-used-for-thread-fault-ipc-messages)
 - [Receive an IPC message from the kernel]({{ url }}#receiving-the-ipc-message-from-the-kernel)
 - [Get information about a thread fault]({{ url }}#finding-out-information-about-the-generated-thread-fault)
 - [Handle a thread fault]({{ url }}#handling-a-thread-fault)
 - [Resume a faulting thread]({{ url }}#resuming-a-faulting-thread)

{% assign url = "mcs?tut_expand" %}
## [MCS Extensions]({{ url }})
 - [Set up a periodic thread]({{ url }}#periodic-threads)
 - [Unbind a scheduling context]({{ url }}#unbinding-scheduling-contexts)
 - [Experiment with sporadic tasks]({{ url }}#sporadic-threads)
 - [Use passive servers]({{ url }}#passive-servers)
 - [Configure fault endpoints]({{ url }}#configuring-a-fault-endpoint-on-the-mcs-kernel)

{% assign url = "libraries-1?tut_expand" %}
## [Dynamic libraries]({{ url }})

### [Initialisation  & threading]({{ url }})
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

{% assign url = "libraries-2?tut_expand" %}
### [IPC]({{ url }})
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

{% assign url = "libraries-3?tut_expand" %}
### [Processes & Elf loading]({{ url }})
  - [Create a VSpace object]({{ url }}#virtual-memory-management)
  - [Configure a process]({{ url }}#configure-a-process)
  - [Get a CSpace path]({{ url }}#get-a-cspacepath)
  - [Badge a capability]({{ url }}#badge-a-capability)
  - [Spawn a process]({{ url }}#spawn-a-process)
  - [Receive a message]({{ url }}#receive-a-message)
  - [Send a reply]({{ url }}#send-a-reply)
  - [Initiate communications by using seL4_Call]({{ url }}#client-call)

{% assign url = "libraries-4?tut_expand" %}
### [Timer]({{ url }})
  - [Allocate a notification object]({{ url }}#allocate-a-notification-object)
  - [Initialise a timer]({{ url }}#initialise-the-timer)
  - [Use a timer]({{ url }}#use-the-timer)
  - [Handle an interrupt]({{ url }}#handle-the-interrupt)
  - [Destroy a timer]({{ url }}#destroy-the-timer)

## [CAmkES](hello-camkes-0?tut_expand)

{% assign url = "hello-camkes-1?tut_expand" %}
### [A basic CAmkES application]({{ url }})
  - [Define an instance in the composition section of the ADL]({{ url }}#define-an-instance-in-the-composition-section-of-the-adl)
  - [Add a connection]({{ url }}#add-a-connection)
  - [Define an interface]({{ url }}#define-an-interface)
  - [Implement an RPC function]({{ url }}#implement-a-rpc-function)
  - [Invoke a RPC function]({{ url }}#invoke-a-rpc-function)

{% assign url = "hello-camkes-2?tut_expand" %}
### [Events in CAmkES]({{ url }})
  - [Specify an events interface]({{ url }}#specify-an-events-interface)
  - [Add connections]({{ url }}#add-connections)
  - [Wait for data to become available]({{ url }}#wait-for-data-to-become-available)
  - [Signal that data is available]({{ url }}#signal-that-data-is-available)
  - [Register a callback handler]({{ url }}#register-a-callback-handler)
  - [Specify dataport interfaces]({{ url }}#specify-dataport-interfaces)
  - [Specify dataport connections]({{ url }}#specify-dataport-connections)
  - [Copy strings to an untyped dataport]({{ url }}#copy-strings-to-an-untyped-dataport)
  - [Read the reply data from a typed dataport]({{ url }}#read-the-reply-data-from-a-typed-dataport)
  - [Send data using dataports]({{ url }}#send-data-using-dataports)
  - [Read data from an untyped dataport]({{ url }}#read-data-from-an-untyped-dataport)
  - [Put data into a typed dataport]({{ url }}#put-data-into-a-typed-dataport)
  - [Read data from a typed dataport]({{ url }}#read-data-from-a-typed-dataport)
  - [Set component priorities]({{ url }}#set-component-priorities)
  - [Restrict access to dataports]({{ url }}#restrict-access-to-dataports)
  - [Test the read and write permissions on the dataport]({{ url }}#test-the-read-and-write-permissions-on-the-dataport)

{% assign url = "hello-camkes-timer?tut_expand" %}
### [CAmkES Timer]({{ url }})
  - [Instantiate a Timer and Timerbase]({{ url }}#instantiate-a-timer-and-timerbase)
  - [Connect a timer driver component]({{ url }}#connect-a-timer-driver-component)
  - [Configure a timer hardware component instance]({{ url }}#configure-a-timer-hardware-component-instance)
  - [Call into a supplied driver to handle the interrupt]({{ url }}#call-into-a-supplied-driver-to-handle-the-interrupt)
  - [Stop a timer]({{ url }}#stop-a-timer)
  - [Acknowledge an interrupt]({{ url }}#acknowledge-an-interrupt)
  - [Get a timer handler]({{ url }}#get-a-timer-handler)
  - [Start a timer]({{ url }}#start-a-timer)
  - [Implement an RPC interface]({{ url }}#implement-a-rpc-interface)
  - [Set a timer interrupt]({{ url }}#set-a-timer-interrupt)
  - [Instantiate a TimerDTB component]({{ url }}#instantiate-a-timerdtb-component)
  - [Connect interfaces using the seL4DTBHardware connector]({{ url }}#connect-interfaces-using-the-sel4dtbhardware-connector)
  - [Configure the TimerDTB component]({{ url }}#configure-the-timerdtb-component)
  - [Handle the interrupt]({{ url }}#handle-the-interrupt)
  - [Stop the timer]({{ url }}#stop-the-timer)

{% assign url = "camkes-vm-linux?tut_expand" %}
### [CAmkES VM Linux]({{ url }})
  - [Add a program]({{ url }}#adding-a-program)
  - [Add a kernel module]({{ url }}#adding-a-kernel-module)
  - [Create a hypercall]({{ url }}#creating-a-hypercall)

{% assign url = "camkes-vm-crossvm?tut_expand" %}
### [CAmkeES Cross VM Connectors]({{ url }})
  - [Add modules to the guest]({{ url }}#add-modules-to-the-guest)
  - [Define interfaces in the VMM]({{ url }}#define-interfaces-in-the-vmm)
  - [Define the component interface]({{ url }}#define-the-component-interface)
  - [Instantiate the print server]({{ url }}#instantiate-the-print-server)
  - [Implement the print server]({{ url }}#implement-the-print-server)
  - [Implement the VMM side of the connection]({{ url }}#implement-the-vmm-side-of-the-connection)
  - [Update the build system]({{ url }}#update-the-build-system)
  - [Add interfaces to the Guest]({{ url }}#add-interfaces-to-the-guest)
  - [Create a process]({{ url }}#create-a-process)