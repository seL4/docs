= Introducing seL4 2.0.0 =

Version 2.0.0 introduces more consistent terminology to manual and code,
as well as API and performance improvements, including to seL4's
formally verified ARMv6 version.

We clarified the notion of signals and notifications vs IPC, and added a
new feature to the seL4 API that allows user programs to receive
notifications while waiting for IPC messages. You can now also poll
notification objects. Both of these changes are aimed at simplifying
user-level interaction with interrupts.

In addition to the new features, seL4 has become even faster than it was
before, esp. in scheduling threads.

The new features and performance improvements are available on all
supported platforms, and are formally verified to full sel4 standards.
We have also switched our release process to semantic versioning, so
it's easy to tell which seL4 releases are binary-compatible,
source-compatible, or will require updates to user-level code.

= Terminology Changes =

== IPC vs Notifications ==

The old terminology of "synchronous IPC" vs "asynchronous IPC" was
confusing and misleading. We changed this to reflect the fact that IPC
in seL4 is always synchronous and is simply referred to as "IPC", which
is enabled by "endpoint" objects. The receive operation is now more
appropriately called "receive".

What used to be called incorrectly "asynchronous IPC" is now called
Notifications, enabled by "notification" objects. Notifications are not
a form of message passing, but arrays of binary semaphores, and the new
terminology describes this better. The operations on them are
consequently called "signal" and "wait"

= New Features =

== Notification binding ==

A notification can be bound to a thread and is referred to as the
thread's bound notification object. This is a 1:1 relationship. Whenever
a thread waits for an IPC on an endpoint, it will receive any signals
sent to its bound notification object, with the signal flags converted
into a single-word message.

Threads can also explicitly wait for signals by waiting on the
notification object itself.

For more details, see the 2.0.0 manual

= Implementation improvements =

> -   introduces the bitfield scheduler: faster scheduler (Was linear in
>     the

number of runnable threads, now log n)

:   -   improved benchmarking macros: can now specify multiple
        benchmarking

tracepoints at once added {{{CONFIG\_RELEASE\_PRINTF}} in addition to
{{{CONFIG\_DEBUG}}} and {{{CONFIG\_RELEASE}}}, which enables printf in a
release build

= API Changes =

> -   {{{seL4\_Recv}}} replaces {{{seL4\_Wait}}} on endpoints
> -   {{{seL4\_Wait}}} is now only used on notification objects
> -   Async endpoint -&gt; notification object
> -   sync endpoint -&gt; endpoint
> -   {{{seL4\_Recv}}} on an endpoint may now return signals sent to a
>     thread's

bound notification object.

== API Additions ==

> -   {{{seL4\_NotificationObject}}} replaces deprecated
>     {{{seL4\_AsyncEndpointObject}}}
> -   {{{seL4\_NotificationBits}}} size in bits of a notification object
> -   {{{seL4\_IRQHandler\_SetNotification}}} replaces deprecated
>     {{{seL4\_IRQHandler\_SetEndpoint}}}
> -   {{{seL4\_Recv}}} replaces {{{seL4\_Wait}}} for endpoints
> -   {{{seL4\_Wait}}} used on notifications
> -   {{{seL4\_NBRecv}}} non-blocking (polling) receive on an endpoint,
>     which fails

if there is no message waiting. Opposite of {{{NBSend}}} (which silently
fails if there is no receiver waiting) \* {{{seL4\_Poll}}} collects any
signals from a notification objects, returns zero if there are none \*
{{{seL4\_Signal}}} replaces deprecated seL4\_Notify \*
{{{seL4\_TCB\_BindNotification}}} bind a notification to a tcb \*
{{{seL4\_TCB\_UnbindNotification}}} unbind a notification from a tcb

== Deprecations ==

> -   {{{seL4\_AsyncEndpointObject}}}
> -   {{{seL4\_Notify}}}
> -   {{{seL4\_IRQHandler\_SetEndpoint}}}

= Note on Syscall names =

Logically there are only two operations on capabilities, send and
receive, which can take opcodes specifying sup-operations. For example,
the Notification operations Signal and Wait are mapped to Send and
Receive, respectively. For efficiency reasons, many kernel objects use
separate kernel entry points for their operations. You must not rely on
either, as this can change at any time. Instead, always use the
object-specific wrapper functions.

= User-level repositories =

To simply repository management we have merged many of our user level
library repositories. To see the changes please compare 1.0.4.xml and
2.0.x.xml in <https://github.com/seL4/seL4test-manifest>

= Upgrade notes =

Calls to {{{seL4\_Wait}}} no longer return a {{{seL4\_MessageInfo\_t}}}
as {{{seL4\_Wait}}} is intended to be used on notification objects.
Calls to the prior version of {{{seL4\_Wait}}} need to be replaced with
{{{seL4\_Recv}}}.

If you don't want to upgrade yet - don't worry. Both the
sel4test-manifest and verification manifest repositories have manifests
titled 1.0.4.xml which point to the tips of the previously released
repositories before today. All library repositories have a branch called
'1.0.x-compatible' which are compatible with the 1.0.4 kernel.

Note that to use the new merged repositories, you must upgrade to 2.0.0.

= Full changelog =

Use git log 1.0.4..2.0.0 in <https://github.com/seL4/seL4>

= More details =

See the \[\[2.0.0
manual|<http://sel4.systems/Info/Docs/seL4-manual-2.0.0.pdf>\]\]
included in the release for detailed descriptions of the new features.
Or ask on this mailing list!
