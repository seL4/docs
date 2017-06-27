= CAmkES Timer Tutorial =

== Setup ==

We'll be working within `apps/hello-camkes-timer` for this tutorial.

== Summary ==

This exercise is to set up a timer driver in CAmkES and use it to delay for 2 seconds.

== Walkthrough ==

=== TASK 1 ===

Start in `hello-camkes-timer.camkes`.

Instantiate some components. You're already given one component instance - `client`.
You need to instantiate two more - a timer driver, and a component instance representing the timer hardware itself.
Look in `components/Timer/Timer.camkes` for the definitions of both of these components.

Note the lines `connection seL4RPCCall hello_timer(from client.hello, to timer.hello);` and `timer.sem_value = 0;`. They assume that the name of the timer ''driver'' will be `timer`. If you wish to call your driver something else, you'll have to change these lines.

=== TASK 2 ===

Connect timer driver to timer hardware. The timer hardware component exposes two interfaces which must be connected to the timer driver. One of these represents memory-mapped registers. The other represents an interrupt.

=== TASK 3 ===

Configure the timer hardware component instance with device-specific info. The physical address of the timer's memory-mapped registers, and its irq number must both be configured.

=== TASK 4 ===

Now open `components/Timer/src/timer.c`.

We'll start by completing the `irq_handle` function, which is called in response to each timer interrupt. Note the name of this function. It follows the naming convention `<interface>_handle`, where `<interface>` is the name of an IRQ interface connected with `seL4HardwareInterrupt`. When an interrupt is received on the interface `<interface>`, the function `<interface>_handle` will be called.

The implementation of the timer driver itself isn't directly in this file. The driver is implemented in a CAmkES-agnostic way in a library called `libplatsupport`.

This task is to call the `timer_handle_irq` function from `libplatsupport`, to inform the driver that an interrupt has occurred.

=== TASK 5 ===

Acknowledge the interrupt. CAmkES generates the seL4-specific code for ack-ing an interrupt and provides a function `<interface>_acknowldege` for IRQ interfaces (specifically those connected with `seL4HardwareInterrupt`).

=== TASK 6 ===

Now we'll complete `hello__init` - a function which is called once before the component's interfaces start running.

We need to initialise a timer driver from `libplatsupport` for this device, and store a handle to the driver in the global variable `timer_drv`.

=== TASK 7 ===

Note that this task is to understand the existing code. You won't have to modify any files.

Implement the `timer_inf` RPC interface. This interface is defined in `interfaces/timer.camkes`, and contains a single method, `sleep`, which should return after a given number of seconds. in `components/Timer/Timer.camkes`, we can see that the `timer_inf` interface exposed by the `Timer` component is called `hello`. Thus, the function we need to implement is called `hello_sleep`.

=== TASK 8 ===

Tell the timer to interrupt after the given number of seconds. The `timer_oneshot_relative` function from `libplatsupport` will help. Note that it expects its time argument to be given in nanoseconds.

Note the existing code in `hello_sleep`. It waits on a binary semaphore. `irq_handle` will be called on another thread when the timer interrupt occurs, and that function will post to the binary semaphore, unblocking us and allowing the function to return after the delay.
