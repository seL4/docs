= Power management commands for the seL4 Driver API: =

== Contents == &lt;&lt;TableOfContents()&gt;&gt;

== Constants == {{{ /\* Driver power states supported by the API. \*
These are used by both seL4drv\_mgmt\_power() \* and
seL4drv\_mgmt\_power\_features(). \*/ \#define
SEL4DRV\_MGMT\_POWER\_BOOT (1&lt;&lt;0) \#define
SEL4DRV\_MGMT\_POWER\_WAKEUP (1&lt;&lt;1) \#define
SEL4DRV\_MGMT\_POWER\_SLEEP (1&lt;&lt;2) \#define
SEL4DRV\_MGMT\_POWER\_DEEP\_SLEEP (1&lt;&lt;3) \#define
SEL4DRV\_MGMT\_POWER\_SHUTDOWN (1&lt;&lt;4) \#define
SEL4DRV\_MGMT\_POWER\_KILL (1&lt;&lt;5) }}}

== Functions == {{{ void
seL4drv\_mgmt\_critical\_event\_subscription\_ind(); void
seL4drv\_mgmt\_power(); void seL4drv\_mgmt\_power\_features(uint32\_t
\*features\_bitmap); void seL4drv\_mgmt\_enumerate\_children(); }}}

== Power state specifications ==

:   -   SEL4DRV\_MGMT\_POWER\_BOOT: Support for this power management
        command is required of all drivers. This is actually the global
        entry point for a driver, and it will be called only once during
        a particular device instance's lifetime. After the driver
        returns from this function call, the environment will assume
        that the device has been initialized and is ready to
        accept requests.
    -   SEL4DRV\_MGMT\_POWER\_WAKEUP: Support for this power management
        command is required of all drivers which support the SLEEP or
        DEEP\_SLEEP commands. Instructs the driver to resume operation
        after a SLEEP or DEEP\_SLEEP command. The driver is expected to
        do any necessary re-initialization of the hardware to get the
        driver back into an operational state. If there were
        asynchronous requests outstanding before the device was put into
        a low-power mode, the driver should re-trigger and resume the
        normal processing of such requests.
    -   SEL4DRV\_MGMT\_POWER\_SLEEP: Indicates to the driver that the
        device is about to be placed into a light sleep state. In such a
        state, the caches of its underlying and dependent hardware are
        guaranteed not to be flushed, and there will be no need to
        reinitialize the buses after wakeup. If the device does not
        support such a light sleep mode, the device shall return an
        error code.
    -   SEL4DRV\_MGMT\_POWER\_DEEP\_SLEEP: Indicates to the driver that
        the environment would like to place the device into a sleep
        state in which there is no guarantee that hardware caches and
        buffers will be preserved. Furthermore, there is no guarantee
        that bus configuration will hold across this transition. The
        driver shall cleanly commit the effect of all current
        operations, and place any unsatisfied asynchronous requests on
        hold, before putting the device into a state that is compatible
        with this sleep state.
    -   SEL4DRV\_MGMT\_POWER\_SHUTDOWN: Support for this power
        management command is required of all drivers. Indicates that
        the device should be placed into a state in which it would be
        safe to cut off power to the device. Such a state should at
        least guarantee that all clients' data is quickly cleaned out to
        permanent storage, and that all effects requested by clients
        are committed. If it is possible to satisfy any outstanding
        asynchronous requests the driver should commit to completing
        them, but it should reject all future requests from that
        point onward.
    -   SEL4DRV\_MGMT\_POWER\_KILL: Support for this power management
        command is required of all drivers. Indicates that the
        environment wants to kill the device, NOW. Any outstanding
        asynchronous requests should be canceled and the driver should
        then place itself into a state that is compatible with the
        SEL4DRV\_MGMT\_POWER\_SHUTDOWN command.

== API ==

=== seL4drv\_mgmt\_critical\_event\_subscription\_ind(): Async === This
function enables the environment to call into the driver, and give it an
asynchronous context block which it should hold on to. If at any point
the driver encounters a situation which requires it to ask the
environment to shut it down, it can asynchronously callback into the
environment to make such a request.

The reason for this function is to enable the driver to report to the
environment when it has found itself in an invalid operational state
which it cannot recover from. This is not a necessary function to
implement, and it is likely to be a blank function for most
implementations.

=== seL4drv\_mgmt\_power(): Async === This operation is called by the
environment to place the device instance into one of the power states
outlined above. It is important to note that SEL4DRV\_MGMT\_POWER\_BOOT
is actually just a global entry point into the driver.

When it comes to placing devices into low power states, the environment
must understand that it is not the responsibility of the driver to
communicate the power management request to its children. If the
environment would like to place an entire hardware bus in a low-power
mode, then the environment must walk its own internal device tree, and
for each descendant of the target bus, it must manually ask that
descendent to enter a power state that is compatible with the power
state it wishes to place the bus into. That is, parent devices are not
responsible for recursing downward and calling their children to
instruct them to enter power states on behalf of the environment.

The same applies for waking devices up from power states. If the
environment wishes to wake a particular child device, it must manually
ensure that all of that device's parents are in a suitable power state
to enable operation.

=== seL4drv\_mgmt\_power\_features(): Sync === This function returns a
bitmap of the supported driver power states (See \[\[\#Constants\]\]).
All drivers are required to support at minimum, the following states: \*
SEL4DRV\_MGMT\_POWER\_BOOT \* SEL4DRV\_MGMT\_POWER\_SHUTDOWN \*
SEL4DRV\_MGMT\_POWER\_KILL

If any of these is not supported by the driver, the environment is free
to respond in an implementation specific manner, including refusing to
load the driver.

The driver is only required to support the SEL4DRV\_MGMT\_POWER\_WAKEUP
command if either the SEL4DRV\_MGMT\_POWER\_SLEEP or
SEL4DRV\_MGMT\_POWER\_DEEP\_SLEEP command is supported. If either the
SLEEP or DEEP\_SLEEP command is supported and there is no support for
the SEL4DRV\_MGMT\_POWER\_WAKEUP command, the environment should assume
that the SLEEP or DEEP\_SLEEP operations are not adequately supported.

== Child enumeration == See the main article:
