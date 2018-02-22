# CAmkES Tutorial 1
This tutorial is an introduction to
CAmkES: bootstrapping a basic static CAmkES application, describing its
components, and linking them together.

&lt;&lt;TableOfContents()&gt;&gt;

## Required Reading
 While it's possible to successfully complete the
CAmkES tutorials without having read the
'''[CAmkES manuals](https://github.com/seL4/camkes-tool/blob/master/docs/index.md)''', the manuals really explain everything in plain English,
and any aspiring CAmkES dev should read the
'''[CAmkES manuals](https://github.com/seL4/camkes-tool/blob/master/docs/index.md)''' before attempting to complete the tutorials.

## Learning outcomes


:   -   Understand the structure of a CAmkES application, as a
        described, well-defined, static system.
    -   Understand the file-layout of a CAmkES ADL project.
    -   Become acquainted with the basics of creating a practical
        CAmkES application.

## Walkthrough
 === TASK 1 === The fundamentals of CAmkES are the
component, the interface and the connection. Components are logical
groupings of code and resources. They communicate with other component
instances via well-defined interfaces which must be statically defined,
over communication channels. This tutorial will lead you through the
construction of a CAmkES application with two components: an Echo
server, and its Client that makes calls to it. These components are
defined here:

  -   <https://github.com/SEL4PROJ/sel4-tutorials/blob/master/apps/hello-camkes-1/components/Client/Client.camkes>
  -   <https://github.com/SEL4PROJ/sel4-tutorials/blob/master/apps/hello-camkes-1/components/Echo/Echo.camkes>

Find the Component manual section here:
<https://github.com/seL4/camkes-tool/blob/master/docs/index.md#component>

### TASK 2
 The second fundamental component of CAmkES applications
is the Connection: a connection is the representation of a method of
communication between two software components in CAmkES. The underlying
implementation may be shared memory, synchronous IPC, notifications or
some other implementation-provided means. In this particular tutorial,
we are using synchronous IPC. In implementation terms, this boils down
to the seL4_Call() syscall on seL4.

Find the "Connection" keyword manual section here:
<https://github.com/seL4/camkes-tool/blob/master/docs/index.md#connection>

### TASK 3
 All communications over a CAmkES connection must be well
defined: static systems' communications should be able to be reasoned
about at build time. All the function calls which will be delivered over
a communication channel then, also are well defined, and logically
grouped so as to provide clear directional understanding of all
transmissions over a connection. Components are connected together in
CAmkES, yes -- but the interfaces that are exposed over each connection
for calling by other components, are also described. There are different
kinds of interfaces: Dataports, Procedural interfaces and Notifications.

This tutorial will lead you through the construction of a Procedural
interface, which is an interface over which function calls are made
according to a well-defined pre-determined API. The keyword for this
kind of interface in CAmkES is "procedure". The definition of this
Procedure interface may be found here:
<https://github.com/SEL4PROJ/sel4-tutorials/blob/master/apps/hello-camkes-1/interfaces/HelloSimple.idl4>

Find the "Procedure" keyword definition here:
<https://github.com/seL4/camkes-tool/blob/master/docs/index.md#procedure>

### TASK 4
 Based on the ADL, CAmkES generates boilerplate which
conforms to your system's architecture, and enables you to fill in the
spaces with your program's logic. The two generated files in this
tutorial application are, in accordance with the Components we have
defined:

  -   <https://github.com/SEL4PROJ/sel4-tutorials/blob/master/apps/hello-camkes-1/components/Echo/src/echo.c>
  -   <https://github.com/SEL4PROJ/sel4-tutorials/blob/master/apps/hello-camkes-1/components/Client/src/client.c>

Now when it comes to invoking the functions that were defined in the
Interface specification
(<https://github.com/SEL4PROJ/sel4-tutorials/blob/master/apps/hello-camkes-1/interfaces/HelloSimple.idl4>),
you must prefix the API function name with the name of the Interface
instance that you are exposing over the particular connection.

The reason for this is because it is possible for one component to
expose an interface multiple times, with each instance of that interface
referring to a different function altogether. For example, if a
composite device, such as a network card with with a serial interface
integrated into it, exposes two instances of a procedural interface that
has a particular procedure named "send()" -- how will the caller of
"send()" know whether his "send()" is the one that is exposed over the
NIC connection, or the serial connection?

The same component provides both. Therefore, CAmkES prefixes the
instances of functions in an Interface with the Interface-instance's
name. In the dual-function NIC device's case, it might have a "provides
&lt;INTERFACE_NAME&gt; serial" and a "provides &lt;INTERFACE_NAME&gt;
nic". When a caller wants to call for the NIC-send, it would call,
nic_send(), and when a caller wants to invoke the Serial-send, it would
call, "serial_send()".

So if the "Hello" interface is provided once by "Echo" as "a", you would
call for the "a" instance of Echo's "Hello" by calling for "a_hello()".
But what if Echo had provided 2 instances of the "Hello" interface, and
the second one was named "a2"? Then in order to call on that second
"Hello" interface instance on Echo, you would call "a2_hello()".

Fill in the function calls in the generated C files!

### TASK 5
 Here you define the callee-side invocation functions for
the Hello interface exposed by Echo.

## Done
 Congratulations: be sure to read up on the keywords and
structure of ADL: it's key to understanding CAmkES. And well done on
writing your first CAmkES application.
