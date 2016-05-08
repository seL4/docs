##master-page:HelpTemplate
##master-date:Unknown-Date
#format wiki
#language en
= Summary: =
The third tutorial is designed to teach the basics of seL4 IPC using Endpoint objects, and userspace paging management. You'll be led through the process of creating a new thread (retyping an untyped object into a TCB object), and also made to manually do your own memory management to allocate some virtual memory for use as the shared memory buffer between your two threads.

Don't gloss over the globals declared before main() -- they're declared for your benefit so you can grasp some of the basic data structures. Uncomment them one by one as needed when going through the TODOs.

You'll observe that the things you've already covered in the second tutorial are filled out and you don't have to repeat them: in much the same way, we won't be repeating conceptual explanations on this page, if they were covered by a previous tutorial in the series.

=== Learning outcomes: ===
 * Repeat the spawning of a thread. "''If it's nice, do it twice''" -- Caribbean folk-saying. Once again, the new thread will be sharing its creator's VSpace and CSpace.
 * Introduction to the idea of badges, and minting badged copies of an Endpoint capability. NB: you don't mint a new copy of the Endpoint object, but a copy of the capability that references it.
 * Basic IPC: sending and receiving: how to make two threads communicate.
 * IPC Message format, and Message Registers. seL4 binds some of the first Message Registers to hardware registers, and the rest are transferred in the IPC buffer.
 * Understand that each thread has only one IPC buffer, which is pointed to by its TCB. It's possible to make a thread wait on both an Endpoint and a Notification using "Bound Notifications".
 * Understand CSpace pointers, which are really just integers with multiple indexes concatenated into one. Understanding them well however, is important to understanding how capabilities work. Be sure you understand the diagram on the "'''CSpace example and addressing'''" slide.

==== TODO 1: ====
As we mentioned in passing before, threads in seL4 do their own memory management. You implement your own Virtual Memory Manager, essentially. To the extent that you must allocate a physical memory frame, then map it into your thread's page directory -- and even manually allocate page tables on your own, where necessary.

Here's the first step in a conventional memory manager's process of allocating memory: first allocate a physical frame. As you would expect, you cannot directly write to or read from this frame object since it is not mapped into any virtual address space as yet. Standard restrictions of a MMU-utilizing kernel apply.

https://github.com/seL4/seL4_libs/blob/3.0.x-compatible/libsel4vka/include/vka/object.h#L127

==== TODO 2: ====
Take note of the line of code that precedes this: the one where a virtual address is "chosen" for use. This is because, as we explained before, the process is responsible for its own Virtual Memory Management. As such, if it chooses, it can map any page in its VSpace to physical frame. It can technically choose to do unconventional things, like not unmap PFN #0. The control of how the address space is managed is up to the threads that have write-capabilities to that address space. There is both flexibility and responsibility implied here. Granted, seL4 itself provides strong guarantees of isolation even if a thread decides to go rogue.

Attempt to map the frame you allocated earlier, into your VSpace. A keen reader will pick up on the fact that it's unlikely that this will work, since you'd need a new page table to contain the new page-table-entry. The tutorial deliberately walks you through both the mapping of a frame into a VSpace, and the mapping of a new page-table into a VSpace.

https://github.com/seL4/seL4_libs/blob/3.0.x-compatible/libsel4vspace/arch_include/x86/vspace/arch/page.h#L23
https://github.com/seL4/seL4/blob/3.0.0/libsel4/arch_include/x86/interfaces/sel4arch.xml#L42
==== TODO 3: ====
So just as you previously had to manually retype a new frame to use for your IPC buffer, you're also going to have to manually retype a new page-table object to use as a leaf page-table in your VSpace.

https://github.com/seL4/seL4_libs/blob/3.0.x-compatible/libsel4vspace/arch_include/x86/vspace/arch/page.h#L27
http://sel4.systems/Info/Docs/seL4-manual-3.0.0.pdf

==== TODO 4: ====
If you successfully retyped a new page table from an untyped memory object, you can now map that new page table into your VSpace, and then try again to finally map the IPC-buffer's frame object into the VSpace.

https://github.com/seL4/seL4_libs/blob/3.0.x-compatible/libsel4vspace/arch_include/x86/vspace/arch/page.h#L27
https://github.com/seL4/seL4/blob/3.0.0/libsel4/arch_include/x86/interfaces/sel4arch.xml#L33

==== TODO 5: ====
If everything was done correctly, there is no reason why this step should fail. Complete it and proceed.

==== TODO 6: ====
Now we have a (fully mapped) IPC buffer -- but no Endpoint object to send our IPC data across. We must retype an untyped object into a kernel Endpoint object, and then proceed. This could be done via a more low-levelled approach using seL4_Untyped_Retype(), but instead, the tutorial makes use of the VKA allocator. Remember that the VKA allocator is an seL4 type-aware object allocator? So we can simply ask it for a new object of a particular type, and it will do the low-level retyping for us, and return a capability to a new object as requested.

In this case, we want a new Endpoint so we can do IPC. Complete the step and proceed.
https://github.com/seL4/seL4_libs/blob/3.0.x-compatible/libsel4vka/include/vka/object.h#L105
 
==== TODO 7: ====
Badges are used to uniquely identify a message queued on an endpoint as having come from a particular sender. Recall that in seL4, each thread has only one IPC buffer. If multiple other threads are sending data to a listening thread, how can that listening thread distinguish between the data sent by each of its IPC partners? Each sender must "badge" its capability to its target's endpoint.

Note the distinction: the badge is not applied to the target endpoint, but to the sender's '''capability''' to the target endpoint. This enables the listening thread to mint off copies of a capability to an Endpoint to multiple senders. Each sender is responsible for applying a unique badge value to the capability that the listener gave it so that the listener can identify it.

In this step, you are badging the endpoint that you will use when sending data to the thread you will be creating later on. The vka_mint_object() call will return a new, badged copy of the capability to the endpoint that your new thread will listen on. When you send data to your new thread, it will receive the badge value with the data, and know which sender you are. Complete the step and proceed.

https://github.com/seL4/seL4_libs/blob/3.0.x-compatible/libsel4vka/include/vka/object_capops.h#L41
https://github.com/seL4/seL4/blob/3.0.0/libsel4/include/sel4/types_32.bf#L30

==== TODO 8: ====
Here we get a formal introduction to message registers. At first glance, you might wonder why the "sel4_SetMR()" calls don't specify a message buffer, and seem to know which buffer to fill out -- and that would be correct, because they do. They are operating directly on the sending thread's IPC buffer. Recall that each thread has only one IPC buffer. Go back and look at your call to seL4_TCB_Configure() in step 7 again: you set the IPC buffer for the new thread in the last 2 arguments to this function. Likewise, the thread that created '''your''' main thread also set an IPC buffer up for you.

So seL4_SetMR() and seL4_GetMR() simply write to and read from the IPC buffer you designated for your thread. MSG_DATA is uninteresting -- can be any value. You'll find the seL4_MessageInfo_t type explained in the manuals. In short, it's a header that is embedded in each message that specifies, among other things, the number of Message Registers that hold meaningful data, and the number of capabilities that are going to be transmitted in the message.

https://github.com/seL4/seL4/blob/3.0.0/libsel4/include/sel4/shared_types_32.bf
https://github.com/seL4/seL4/blob/3.0.0/libsel4/arch_include/x86/sel4/arch/functions.h#L40

==== TODO 9: ====
Now that you've constructed your message and badged the endpoint that you'll use to send it, it's time to send it. The "seL4_Call()" syscall will send a message across an endpoint synchronously. If there is no thread waiting at the other end of the target endpoint, the sender will block until there is a waiter. The reason for this is because the seL4 kernel would prefer not to buffer IPC data in the kernel address space, so it just sleeps the sender until a receiver is ready, and then directly copies the data. It simplifies the IPC logic. There are also polling send operations, as well as polling receive operations in case you don't want to be forced to block if there is no receiver on the other end of an IPC Endpoint.

When you send your badged data using seL4_Call(), our receiving thread (which we created earlier) will pick up the data, see the badge, and know that it was us who sent the data. Notice how the sending thread uses the '''badged''' capability to the endpoint object, and the receiving thread uses the unmodified original capability to the same endpoint? The sender must identify itself.

Notice also that the fact that both the sender and the receiver share the same root CSpace, enables the receiving thread to just casually use the original, unbadged capability without any extra work needed to make it accessible.

Notice however also, that while the sending thread has a capability that grants it full rights to send data across the endpoint since it was the one that created that capability, the receiver's capability may not necessarily grant it sending powers (write capability) to the endpoint. It's entirely possible that the receiver may not be able to send a response message, if the sender doesn't want it to.

https://github.com/seL4/seL4/blob/3.0.0/libsel4/sel4_arch_include/ia32/sel4/sel4_arch/syscalls.h#L237
build/x86/pc99/libsel4/include/sel4/types_gen.h
https://github.com/seL4/seL4/blob/3.0.0/libsel4/include/sel4/shared_types_32.bf#L15

==== TODO 10: ====
While this TODO is out of order, since we haven't yet examined the receive-side of the operation here, it's fairly simple anyway: this TODO occurs after the receiver has sent a reply, and it shows the sender now reading the reply from the receiver. As mentioned before, the seL4_GetMR() calls are simply reading from the calling thread's designated, single IPC buffer.

https://github.com/seL4/seL4/blob/3.0.0/libsel4/sel4_arch_include/ia32/sel4/sel4_arch/syscalls.h#L237

==== TODO 11: ====
We're now in the receiving thread. The seL4_Recv() syscall performs a blocking listen on an Endpoint or Notification capability. When new data is queued (or when the Notification is signalled), the seL4_Recv operation will unqueue the data and resume execution.

Notice how the seL4_Recv() operation explicitly makes allowance for reading the badge value on the incoming message? The receiver is explicitly interested in distinguishing the sender.

https://github.com/seL4/seL4/blob/3.0.0/libsel4/sel4_arch_include/aarch32/sel4/sel4_arch/syscalls.h#L207 
build/x86/pc99/libsel4/include/sel4/types_gen.h
https://github.com/seL4/seL4/blob/3.0.0/libsel4/include/sel4/shared_types_32.bf#L15

==== TODO 12: ====
These two calls here are just verification of the fidelity of the transmitted message. It's very unlikely you'll encounter an error here. Complete them and proceed to the next step.

https://github.com/seL4/seL4/blob/3.0.0/libsel4/include/sel4/shared_types_32.bf#L15 

==== TODO 13: ====
Again, just reading the data from the Message Registers.

https://github.com/seL4/seL4/blob/3.0.0/libsel4/arch_include/x86/sel4/arch/functions.h#L32

==== TODO 14: ====
And writing Message Registers again.

https://github.com/seL4/seL4/blob/3.0.0/libsel4/arch_include/x86/sel4/arch/functions.h#L40

==== TODO 15: ====
This is a formal introduction to the "Reply" capability which is automatically generated by the seL4 kernel, whenever an IPC message is sent using the seL4_Call() syscall. This is unique to the seL4_Call() syscall, and if you send data instead with the seL4_Send() syscall, the seL4 kernel will not generate a Reply capability.

The Reply capability solves the issue of a receiver getting a message from a sender, but not having a sufficiently permissive capability to respond to that sender. The "Reply" capability is a one-time capability to respond to a particular sender. If a sender doesn't want to grant the target the ability to send to it repeatedly, but would like to allow the receiver to respond to a specific message once, it can use seL4_Call(), and the seL4 kernel will facilitate this one-time permissive response. Complete the step and pat yourself on the back.

https://github.com/seL4/seL4/blob/3.0.0/libsel4/sel4_arch_include/ia32/sel4/sel4_arch/syscalls.h#L312 
https://github.com/seL4/seL4/blob/3.0.0/libsel4/include/sel4/shared_types_32.bf#L15
