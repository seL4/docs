= CAmkES Timer Tutorial =

== Summary ==

This exercise is to set up a timer driver in CAmkES and use it to delay
for 2 seconds.

== Setup ==

We'll be working within apps/hello-camkes-timer for this tutorial.

{{{ make arm\_hello-camkes-timer\_defconfig }}}

== Walkthrough ==

=== TASK 1 ===

Start in hello-camkes-timer.camkes.

Instantiate some components. You're already given one component instance
- client. You need to instantiate two more - a timer driver, and a
component instance representing the timer hardware itself. Look in
components/Timer/Timer.camkes for the definitions of both of these
components.

Note the lines
connection seL4RPCCall hello\_timer(from client.hello, to timer.hello);
and timer.sem\_value = 0;. They assume that the name of the timer
''driver'' will be timer. If you wish to call your driver something
else, you'll have to change these lines.

=== TASK 2 ===

Connect timer driver to timer hardware. The timer hardware component
exposes two interfaces which must be connected to the timer driver. One
of these represents memory-mapped registers. The other represents an
interrupt.

=== TASK 3 ===

Configure the timer hardware component instance with device-specific
info. The physical address of the timer's memory-mapped registers, and
its irq number must both be configured.

=== TASK 4 ===

Now open components/Timer/src/timer.c.

We'll start by completing the irq\_handle function, which is called in
response to each timer interrupt. Note the name of this function. It
follows the naming convention &lt;interface&gt;\_handle, where
&lt;interface&gt; is the name of an IRQ interface connected with
seL4HardwareInterrupt. When an interrupt is received on the interface
&lt;interface&gt;, the function &lt;interface&gt;\_handle will be
called.

The implementation of the timer driver itself isn't directly in this
file. The driver is implemented in a CAmkES-agnostic way in a library
called libplatsupport.

This task is to call the timer\_handle\_irq function from
libplatsupport, to inform the driver that an interrupt has occurred.

=== TASK 5 ===

Acknowledge the interrupt. CAmkES generates the seL4-specific code for
ack-ing an interrupt and provides a function
&lt;interface&gt;\_acknowldege for IRQ interfaces (specifically those
connected with seL4HardwareInterrupt).

=== TASK 6 ===

Now we'll complete hello\_\_init - a function which is called once
before the component's interfaces start running.

We need to initialise a timer driver from libplatsupport for this
device, and store a handle to the driver in the global variable
timer\_drv.

=== TASK 7 ===

Note that this task is to understand the existing code. You won't have
to modify any files.

Implement the timer\_inf RPC interface. This interface is defined in
interfaces/timer.camkes, and contains a single method, sleep, which
should return after a given number of seconds. in
components/Timer/Timer.camkes, we can see that the timer\_inf interface
exposed by the Timer component is called hello. Thus, the function we
need to implement is called hello\_sleep.

=== TASK 8 ===

Tell the timer to interrupt after the given number of seconds. The
timer\_oneshot\_relative function from libplatsupport will help. Note
that it expects its time argument to be given in nanoseconds.

Note the existing code in hello\_sleep. It waits on a binary semaphore.
irq\_handle will be called on another thread when the timer interrupt
occurs, and that function will post to the binary semaphore, unblocking
us and allowing the function to return after the delay.

== Output ==

Build and run with: {{{ make simulate }}}

Expect the following output with a 2 second delay between the last 2
lines: {{{ Starting the client ------Sleep for 2 seconds------After the
client: wakeup

}}}
