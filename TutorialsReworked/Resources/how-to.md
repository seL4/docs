---
toc: true
layout: project
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2024 seL4 Project a Series of LF Projects, LLC.
---
# <em>How to:</em> A quick solutions guide
This guide provides links to tutorial solutions as quick references for seL4 calls and methods.

## The seL4 kernel

### [Capabilities](../seL4Kernel/capabilities)

 - [Calculate the size of a CSpace](../seL4Kernel/capabilities#how-big-is-your-cspace)
 - [Copy a capability between CSlots](../seL4Kernel/capabilities#copy-a-capability-between-cslots)
 - [Delete a capability](../seL4Kernel/capabilities#how-do-you-delete-capabilities)
 - [Suspend a thread](../seL4Kernel/capabilities#invoking-capabilities)

### [Untyped](../seL4Kernel/untyped)

 - [Create an untyped capability](../seL4Kernel/untyped#create-an-untyped-capability)
 - [Create a TCB object](../seL4Kernel/untyped#create-a-tcb-object)
 - [Create an endpoint object](../seL4Kernel/untyped#create-an-endpoint-object)
 - [Create a notification object](../seL4Kernel/untyped#create-a-notification-object)
 - [Delete an object](../seL4Kernel/untyped#delete-the-objects)

### [Mapping](../seL4Kernel/mapping)
- [Map a page directory](../seL4Kernel/mapping#map-a-page-directory)
- [Map a page table](../seL4Kernel/mapping#map-a-page-table)
- [Remap a page](../seL4Kernel/mapping#remap-a-page)
- [Unmap a page](../seL4Kernel/mapping#unmapping-pages)

### [Threads](../seL4Kernel/threads)
- [Configure a TCB](../seL4Kernel/threads#configure-a-tcb)
- [Change the priority of a thread](../seL4Kernel/threads#change-priority-via-sel4_tcb_setpriority)
- [Set initial register state](../seL4Kernel/threads#set-initial-register-state)
- [Start the thread](../seL4Kernel/threads#start-the-thread)
- [Set the arguments of a thread](../seL4Kernel/threads#passing-arguments)
- [Resolve a fault](../seL4Kernel/threads#resolving-a-fault)

### [IPC](../seL4Kernel/ipc)
 - [Use capability transfer to send the badged capability](
seL4Kernel/ipc#use-capability-transfer-to-send-the-badged-capability)
 - [Get a message](../seL4Kernel/ipc#get-a-message)
 - [Reply and wait](../seL4Kernel/ipc#reply-and-wait)
 - [Save a reply and store reply capabilities](../seL4Kernel/ipc#save-a-reply-and-store-reply-capabilities)

### [Notifications](../seL4Kernel/notifications)
 - [Set up shared memory](../seL4Kernel/notifications#set-up-shared-memory)
 - [Signalling](../seL4Kernel/notifications#signal-the-producers-to-go)
 - [Differentiate signals](../seL4Kernel/notifications#differentiate-signals)

### [Interrupts](../seL4Kernel/interrupts)
 - [Invoke IRQ control](../seL4Kernel/interrupts#invoke-irq-control)
 - [Set NTFN](../seL4Kernel/interrupts#set-ntfn)
 - [Acknowledge an interrupt](../seL4Kernel/interrupts#acknowledge-an-interrupt)

### [Fault handling](../seL4Kernel/faults)
 - [Set up an endpoint for thread fault IPC messages](../seL4Kernel/faults#setting-up-the-endpoint-to-be-used-for-thread-fault-ipc-messages)
 - [Receive an IPC message from the kernel](../seL4Kernel/faults#receiving-the-ipc-message-from-the-kernel)
 - [Get information about a thread fault](../seL4Kernel/faults#finding-out-information-about-the-generated-thread-fault)
 - [Handle a thread fault](../seL4Kernel/faults#handling-a-thread-fault)
 - [Resume a faulting thread](../seL4Kernel/faults#resuming-a-faulting-thread)

## [MCS Extensions](../MCS/mcs-extensions)
 - [Set up a periodic thread](../MCS/mcs-extensionsperiodic-threads)
 - [Unbind a scheduling context](../MCS/mcs-extensionsunbinding-scheduling-contexts)
 - [Experiment with sporadic tasks](../MCS/mcs-extensionssporadic-threads)
 - [Use passive servers](../MCS/mcs-extensionspassive-servers)
 - [Configure fault endpoints](../MCS/mcs-extensionsconfiguring-a-fault-endpoint-on-the-mcs-kernel)

## Dynamic libraries
 - [Initiliasation & threading](../DynamicLibraries/initialisation)
   - [Obtain BootInfo](../DynamicLibraries/initialisation#obtain-bootinfo)
   - [Initialise simple](../DynamicLibraries/initialisation#initialise-simple)
   - [Use simple to print BootInfo](../DynamicLibraries/initialisation#use-simple-to-print-bootinfo)
   - [Initialise an allocator](../DynamicLibraries/initialisation#initialise-an-allocator)
   - [Obtain a generic allocation interface (vka)](../DynamicLibraries/initialisation#obtain-a-generic-allocation-interface-vka)
   - [Find the CSpace root cap](../DynamicLibraries/initialisation#find-the-cspace-root-cap)
   - [Find the VSpace root cap](../DynamicLibraries/initialisation#find-the-vspace-root-cap)
   - [Allocate a TCB Object](../DynamicLibraries/initialisation#allocate-a-tcb-object)
   - [Configure the new TCB](../DynamicLibraries/initialisation#configure-the-new-tcb)
   - [Name the new TCB](../DynamicLibraries/initialisation#name-the-new-tcb)
   - [Set the instruction pointer](../DynamicLibraries/initialisation#set-the-instruction-pointer)
   - [Write the registers](../DynamicLibraries/initialisation#write-the-registers)
   - [Start the new thread](../DynamicLibraries/initialisation#start-the-new-thread)
 - [IPC](../DynamicLibraries/ipc)
   - [Allocate an IPC buffer](../DynamicLibraries/ipc#allocate-an-ipc-buffer)
   - [Allocate a page table](../DynamicLibraries/ipc#allocate-a-page-table)
   - [Map a page table](../DynamicLibraries/ipc#map-a-page-table)
   - [Map a page](../DynamicLibraries/ipc#map-a-page)
   - [Allocate an endpoint](../DynamicLibraries/ipc#allocate-an-endpoint)
   - [Badge an endpoint](../DynamicLibraries/ipc#badge-an-endpoint)
   - [Set a message register](../DynamicLibraries/ipc#message-registers)
   - [Send and wait for a reply](../DynamicLibraries/ipc#ipc)
   - [Receive a reply](../DynamicLibraries/ipc#receive-a-reply)
   - [Receive an IPC](../DynamicLibraries/ipc#receive-an-ipc)
   - [Validate a message](../DynamicLibraries/ipc#validate-the-message)
   - [Write the message registers](../DynamicLibraries/ipc#write-the-message-registers)
   - [Reply to a message](../DynamicLibraries/ipc#reply-to-a-message)
- [Processes & Elf loading](../DynamicLibraries/processes)
   - [Create a VSpace object](../DynamicLibraries/processes#virtual-memory-management)
   - [Configure a process](../DynamicLibraries/processes#configure-a-process)
   - [Get a cspacepath](../DynamicLibraries/processes#get-a-cspacepath)
   - [Badge a capability](../DynamicLibraries/processes#badge-a-capability)
   - [Spawn a process](../DynamicLibraries/processes#spawn-a-process)
   - [Receive a message](../DynamicLibraries/processes#receive-a-message)
   - [Send a reply](../DynamicLibraries/processes#send-a-reply)
   - [Initiate communications by using seL4_Call](../DynamicLibraries/processes#client-call)
 - [Timer](../DynamicLibraries/timer)
   - [Allocate a notification object](../DynamicLibraries/timer#allocate-a-notification-object)
   - [Initialise a timer](../DynamicLibraries/timer#initialise-the-timer)
   - [Use a timer](../DynamicLibraries/timer#use-the-timer)
   - [Handle an interrupt](../DynamicLibraries/timer#handle-the-interrupt)
   - [Destroy a timer](../DynamicLibraries/timer#destroy-the-timer)


## CAmkES
TBD

