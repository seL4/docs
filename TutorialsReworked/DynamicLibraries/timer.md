---
toc: true
layout: project
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2024 seL4 Project a Series of LF Projects, LLC.
---
# seL4 Dynamic Libraries: Timer tutorial

This tutorial demonstrates how to set up and use a basic timer driver using the
`seL4_libs` dynamic libraries.

You'll observe that the things you've already covered in the other
tutorials are already filled out and you don't have to repeat them: in
much the same way, we won't be repeating conceptual explanations on this
page, if they were covered by a previous tutorial in the series.

Learning outcomes:
- Allocate a notification object.
- Set up a timer provided by `util_libs`.
- Use `seL4_libs` and `util_libs` functions to manipulate timer and
      handle interrupts.

## Initialising

```sh
# For instructions about obtaining the tutorial sources see https://docs.sel4.systems/Tutorials/#get-the-code
#
# Follow these instructions to initialise the tutorial
# initialising the build directory with a tutorial exercise
./init --tut dynamic-4
# building the tutorial exercise
cd dynamic-4_build
ninja
```
<details markdown='1'>
<summary style="display:list-item"><em>Hint:</em> tutorial solutions</summary>
<br>
All tutorials come with complete solutions. To get solutions run:
```
./init --solution --tut dynamic-4
```
Answers are also available in drop down menus under each section.
</details>


## Prerequisites

1. [Set up your machine](https://docs.sel4.systems/HostDependencies).
1. [dynamic-3](https://docs.sel4.systems/Tutorials/dynamic-3)

## Exercises

Once you initialise and run the tutorials, you will see the following output:

```
Booting all finished, dropped to user space
Node 0 of 1
IOPT levels:     4294967295
IPC buffer:      0x5a1000
Empty slots:     [523 --> 4096)
sharedFrames:    [0 --> 0)
userImageFrames: [16 --> 433)
userImagePaging: [12 --> 15)
untypeds:        [433 --> 523)
Initial thread domain: 0
Initial thread cnode size: 12
timer client: hey hey hey
main: hello world
main: got a message from 0x61 to sleep 2 seconds
ltimer_get_time@ltimer.h:267 get_time not implemented
timer client wakes up:
 got the current timer tick:
 0
```
### Allocate a notification object

The first task is to allocate a notification object to receive
interrupts on.
```c

    /* TASK 1: create a notification object for the timer interrupt */
    /* hint: vka_alloc_notification()
     * int vka_alloc_notification(vka_t *vka, vka_object_t *result)
     * @param vka Pointer to vka interface.
     * @param result Structure for the notification object. This gets initialised.
     * @return 0 on success
     * https://github.com/seL4/libsel4vka/blob/master/include/vka/object.h#L98
     */
    vka_object_t ntfn_object = {0};
```
<details markdown='1'>
<summary style="display:list-item"><em>Quick solution</em></summary>
```c
    error = vka_alloc_notification(&vka, &ntfn_object);
    assert(error == 0);
```
</details>

The output will not change as a result of completing this task.

### Initialise the timer

Use our library function `ltimer_default_init` to
initialise a timer driver. Assign it to the `timer` global variable.
```c

    /* TASK 2: call ltimer library to get the default timer */
    /* hint: ltimer_default_init, you can set NULL for the callback and token
     */
    ps_io_ops_t ops = {{0}};
    error = sel4platsupport_new_malloc_ops(&ops.malloc_ops);
    assert(error == 0);
    error = sel4platsupport_new_io_mapper(&vspace, &vka, &ops.io_mapper);
    assert(error == 0);
    error = sel4platsupport_new_fdt_ops(&ops.io_fdt, &simple, &ops.malloc_ops);
    assert(error == 0);
    if (ntfn_object.cptr != seL4_CapNull) {
        error = sel4platsupport_new_mini_irq_ops(&ops.irq_ops, &vka, &simple, &ops.malloc_ops,
                                                 ntfn_object.cptr, MASK(seL4_BadgeBits));
        assert(error == 0);
    }
    error = sel4platsupport_new_arch_ops(&ops, &simple, &vka);
    assert(error == 0);
```
<details markdown='1'>
<summary style="display:list-item"><em>Quick solution</em></summary>
```c
    error = ltimer_default_init(&timer, ops, NULL, NULL);
    assert(error == 0);
```
</details>

After this change, the server will output non-zero for the tick value at the end.
```
 got the current timer tick:
 1409040
```

### Use the timer

While at the end of the previous task the tutorial appears to be
working, the main thread replies immediately to the client and doesn't
wait at all.

Consequently, the final task is to interact with the timer: set a
timeout, wait for an interrupt on the created notification, and handle
it.

```c

    /*
     * TASK 3: Start and configure the timer
     * hint 1: ltimer_set_timeout
     * hint 2: set period to 1 millisecond
     */
```
<details markdown='1'>
<summary style="display:list-item"><em>Quick solution</em></summary>
```c
    error = ltimer_set_timeout(&timer, NS_IN_MS, TIMEOUT_PERIODIC);
    assert(error == 0);
```
</details>

The output will cease after the following line as a result of completing this task.
```
main: got a message from 0x61 to sleep 2 seconds
```

### Handle the interrupt

In order to receive more interrupts, you need to handle the interrupt in the driver
and acknowledge the irq.

```c

        /*
         * TASK 4: Handle the timer interrupt
         * hint 1: wait for the incoming interrupt and handle it
         * The loop runs for (1000 * msg) times, which is basically 1 second * msg.
         *
         * hint2: seL4_Wait
         * hint3: sel4platsupport_irq_handle
         * hint4: 'ntfn_id' should be MINI_IRQ_INTERFACE_NTFN_ID and handle_mask' should be the badge
         *
         */
```
<details markdown='1'>
<summary style="display:list-item"><em>Quick solution</em></summary>
```c
    seL4_Word badge;
    seL4_Wait(ntfn_object.cptr, &badge);
    sel4platsupport_irq_handle(&ops.irq_ops, MINI_IRQ_INTERFACE_NTFN_ID, badge);
    count++;
    if (count == 1000 * msg) {
        break;
    }
```
</details>

The timer interrupts are bound to the IRQ interface initialised in Task 2,
hence when we receive an interrupt, we forward it to the interface and let it notify the timer driver.

After this task is completed you should see a 2 second wait, then output from the
 client as follows:
```
timer client wakes up:
 got the current timer tick:
 2365866120
```

### Destroy the timer

```c

    /*
     * TASK 5: Stop the timer
     * hint: ltimer_destroy
     */
```
<details markdown='1'>
<summary style="display:list-item"><em>Quick solution</em></summary>
```c
    ltimer_destroy(&timer);
```
</details>

The output should not change on successful completion of completing this task.

That's it for this tutorial.

Next tutorial: <a href="../CAmkES/hello-camkes">Hello CAmkES</a>
