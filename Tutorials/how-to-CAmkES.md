---
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2024 seL4 Project a Series of LF Projects, LLC.
---

# How-to guide for CAmkES

This guide provides links to CAmkES tutorial solutions as quick how-to reference guide.

{% assign url = "hello-camkes-1?tut_expand" %}

## [A basic CAmkES application]({{ url }})

- [Define an instance in the composition section of the ADL]({{ url }}#define-an-instance-in-the-composition-section-of-the-adl)
- [Add a connection]({{ url }}#add-a-connection)
- [Define an interface]({{ url }}#define-an-interface)
- [Implement an RPC function]({{ url }}#implement-a-rpc-function)
- [Invoke a RPC function]({{ url }}#invoke-a-rpc-function)

{% assign url = "hello-camkes-2?tut_expand" %}

## [Events in CAmkES]({{ url }})

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

## [CAmkES Timer]({{ url }})

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

## [CAmkES VM Linux]({{ url }})

- [Add a program]({{ url }}#adding-a-program)
- [Add a kernel module]({{ url }}#adding-a-kernel-module)
- [Create a hypercall]({{ url }}#creating-a-hypercall)

{% assign url = "camkes-vm-crossvm?tut_expand" %}

## [CAmkeES Cross VM Connectors]({{ url }})

- [Add modules to the guest]({{ url }}#add-modules-to-the-guest)
- [Define interfaces in the VMM]({{ url }}#define-interfaces-in-the-vmm)
- [Define the component interface]({{ url }}#define-the-component-interface)
- [Instantiate the print server]({{ url }}#instantiate-the-print-server)
- [Implement the print server]({{ url }}#implement-the-print-server)
- [Implement the VMM side of the connection]({{ url }}#implement-the-vmm-side-of-the-connection)
- [Update the build system]({{ url }}#update-the-build-system)
- [Add interfaces to the Guest]({{ url }}#add-interfaces-to-the-guest)
- [Create a process]({{ url }}#create-a-process)
