---
toc: true
---

# seL4 Tutorial 2
The second tutorial is useful in that
it addresses conceptual problems for two different types of developers:

- Experienced kernel developers whose minds are pre-programmed to
      think in terms of "One address space equals one process", and
      begins to introduce the seL4 CSpace vs VSpace model.
- New kernel developers, for whom the tutorial will prompt them on
      what to read about.

Don't gloss over the globals declared before `main()` -- they're declared
for your benefit so you can grasp some of the basic data structures.
Uncomment them one by one as needed when going through the tasks.

## Learning outcomes:


- Understand the kernel's startup procedure.
- Understand that the kernel centers around certain objects and
        capabilities to those objects.
- Understand that libraries exist to automate the very
        fine-grained nature of the seL4 API, and get a rough idea of
        some of those libraries.
- Learn how the kernel hands over control to userspace.
- Get a feel for how the seL4 API enables developers to manipulate
        the objects referred to by the capabilities they encounter.
- Understand the how to spawn new threads in seL4, and the basic
        idea that a thread has a TCB, VSpace and CSpace, and that you
        must fill these out.

## Walkthrough
```
# select the config for the first tutorial
make pc99_hello-2_defconfig
```

Look for `TASK` in the `apps/hello-2` directory for each task.

### TASK 1


After bootstrap, the kernel hands over control to to an init thread.
This thread receives a structure from the kernel that describes all the
resources available on the machine. This structure is called the
BootInfo structure. It includes information on all IRQs, memory, and
IO-Ports (x86). This structure also tells the init thread where certain
important capability references are. This step is teaching you how to
obtain that structure.

`seL4_BootInfo* platsupport_get_bootinfo(void)` is a function that returns the BootInfo structure.
It also sets up the IPC buffer so that it can perform some syscalls such as `seL4_DebugNameThread` used by `name_thread`.

To build and run:
```
make simulate
```

After TASK 1 when you run the example, you should get a message similar to:
```
hello-2: <main@main.c>:132 [Cond failed: allocman == NULL]
Failed to initialize alloc manager.
Memory pool sufficiently sized?
Memory pool pointer valid?
```

until Task 4, where you set up memory management.

<https://github.com/seL4/seL4/blob/master/libsel4/include/sel4/bootinfo_types.h>
<https://github.com/seL4/seL4_libs/blob/master/libsel4platsupport/src/bootinfo.c>
### TASK 2


The "Simple" library is one of those you were introduced to in the
slides: you need to initialize it with some default state before using
it.

<https://github.com/seL4/seL4_libs/blob/master/libsel4simple-default/include/simple-default/simple-default.h>

### TASK 3


Just a simple debugging print-out function. Allows you to examine the
layout of the BootInfo.

<https://github.com/seL4/seL4_libs/blob/master/libsel4simple/include/simple/simple.h>

### TASK 4


In seL4, memory management is delegated in large part to userspace, and
each process manages its own page faults with a custom pager. Without
the use of the `allocman` library and the `VKA` library, you would have to
manually allocate a frame, then map the frame into a page-table, before
you could use new memory in your address space. In this tutorial you
don't go through that procedure, but you'll encounter it later. For now,
use the allocman and VKA allocation system. The allocman library
requires some initial memory to bootstrap its metadata. Complete this
step.

<https://github.com/seL4/seL4_libs/blob/master/libsel4allocman/include/allocman/bootstrap.h>

### TASK 5


`libsel4vka` is an seL4 type-aware object allocator that will allocate new
kernel objects for you. The term "allocate new kernel objects" in seL4
is a more detailed process of "retyping" previously un-typed memory.
seL4 considers all memory that hasn't been explicitly earmarked for a
purpose to be "untyped", and in order to repurpose any memory into a
useful object, you must give it an seL4-specific type. This is retyping,
and the VKA library simplifies this for you, among other things.

<https://github.com/seL4/seL4_libs/blob/master/libsel4allocman/include/allocman/vka.h>

### TASK 6


This is where the differences between seL4 and contemporary kernels
begin to start playing out. Every kernel-object that you "retype" will
be handed to you using a capability reference. The seL4 kernel keeps
multiple trees of these capabilities. Each separate tree of capabilities
is called a "CSpace". Each thread can have its own CSpace, or a CSpace
can be shared among multiple threads. The delineations between
"Processes" aren't well-defined, since seL4 doesn't have any real
concept of "processes". It deals with threads. Sharing and isolation is
based on CSpaces (shared vs not-shared) and VSpaces (shared vs
not-shared). The "process" idea goes as far as perhaps the fact that at
the hardware level, threads sharing the same VSpace are in a traditional
sense, siblings, but logically in seL4, there is no concept of
"Processes" really.

So you're being made to grab a reference to your thread's CSpace's root
"CNode". A CNode is one of the many blocks of capabilities that make up
a CSpace.

<https://github.com/seL4/seL4_libs/blob/master/libsel4simple/include/simple/simple.h>

### TASK 7


Just as in the previous step, you were made to grab a reference to the
root of your thread's CSpace, now you're being made to grab a reference
to the root of your thread's VSpace.

<https://github.com/seL4/seL4_libs/blob/master/libsel4simple/include/simple/simple.h>

### TASK 8


In order to manage the threads that are created in seL4, the seL4 kernel
keeps track of TCB (Thread Control Block) objects. Each of these
represents a schedulable executable resource. Unlike other contemporary
kernels, seL4 **doesn't** allocate a stack, virtual-address space
(VSpace) and other metadata on your behalf. This step creates a TCB,
which is a very bare-bones, primitive resource, which requires you to
still manually fill it out.

<https://github.com/seL4/seL4_libs/blob/master/libsel4vka/include/vka/object.h>

### TASK 9


You must create a new VSpace for your new thread if you need it to
execute in its own isolated address space, and tell the kernel which
VSpace you plan for the new thread to execute in. This opens up the
option for threads to share VSpaces. In similar fashion, you must also
tell the kernel which CSpace your new thread will use -- whether it will
share a currently existing one, or whether you've created a new one for
it. That's what you're doing now.

In this particular example, you're allowing the new thread to share your
main thread's CSpace and VSpace.

In addition, a thread needs to have a priority set on it in order for it to run.
`seL4_TCB_SetPriority(tcb_object.cptr, seL4_CapInitThreadTCB, seL4_MaxPrio);`
will give your new thread the same priority as the current thread, allowing it
to be run the next time the seL4 scheduler is invoked.  The seL4 scheduler is invoked
everytime there is a kernel timer tick.

<https://github.com/seL4/seL4/blob/master/libsel4/include/interfaces/sel4.xml>

### TASK 10


This is a convenience function -- sets a name string for the TCB object.

### TASK 11


Pay attention to the line that precedes this particular task -- the line
that zeroes out a new "seL4_UserContext" object. As we previously
explained, seL4 requires you to fill out the Thread Control Block
manually. That includes the new thread's initial register contents. You
can set the value of the stack pointer, the instruction pointer, and if
you want to get a little creative, you can pass some initial data to
your new thread through its registers.

<https://github.com/seL4/seL4_libs/blob/master/libsel4utils/sel4_arch_include/x86_64/sel4utils/sel4_arch/util.h>

### TASK 12


This TASK is just some pointer arithmetic. The cautionary note that the
stack grows down is meant to make you think about the arithmetic.
Processor stacks push new values toward decreasing addresses, so give it
some thought.

<https://github.com/seL4/seL4_libs/blob/master/libsel4utils/sel4_arch_include/x86_64/sel4utils/sel4_arch/util.h>

### TASK 13


As explained above, we've been filling out our new thread's TCB for the
last few operations, so now we're writing the values we've chosen, to
the TCB object in the kernel.

<https://github.com/seL4/seL4/blob/master/libsel4/include/interfaces/sel4.xml>

### TASK 14


Finally, we tell the kernel that our new thread is runnable. From here,
the kernel itself will choose when to run the thread based on the
priority we gave it, and according to the kernel's configured scheduling
policy.

<https://github.com/seL4/seL4/blob/master/libsel4/include/interfaces/sel4.xml>

### TASK 15


For the sake of confirmation that our new thread was executed by the
kernel successfully, we cause it to print something to the screen.

## Globals links


- `sel4_BootInfo`:
      <https://github.com/seL4/seL4/blob/master/libsel4/include/sel4/bootinfo_types.h>
- `simple_t`:
      <https://github.com/seL4/seL4_libs/blob/master/libsel4simple/include/simple/simple.h>
- `vka_t`:
      <https://github.com/seL4/seL4_libs/blob/master//libsel4vka/include/vka/vka.h>
- `allocman_t`:
      <https://github.com/seL4/seL4_libs/blob/master/libsel4allocman/include/allocman/allocman.h>
- `name_thread()`:
      <https://github.com/SEL4PROJ/sel4-tutorials/blob/master/exercises/hello-2/src/util.c>

