---
toc: true
---

# CAmkES Tutorial 2
This tutorial is an introduction to
CAmkES: bootstrapping a basic static CAmkES application, describing its
components, and linking them together.

## Required Reading
 While it's possible to successfully complete the
CAmkES tutorials without having read the
**[CAmkES manuals](https://github.com/seL4/camkes-tool/blob/master/docs/index.md)**, the manuals really explain everything in plain English,
and any aspiring CAmkES dev should read the
**[CAmkES manuals](https://github.com/seL4/camkes-tool/blob/master/docs/index.md)** before attempting to complete the tutorials.

## Learning outcomes


- Understand how to represent and implement events in CAmkES.
- Understand how to use Dataports.

## Walkthrough
 Bear in mind, this article will be going through the
tutorial steps in the order that the user is led through them in the
slide presentation, except where several similar tasks are coalesced to
avoid duplication. Additionally, if a tasks step covers material that
has already been touched on, it will be omitted from this article.

### TASK 1
 Here you're declaring the events that will be bounced
back and forth in this tutorial. An event is a signal is sent over a
Notification connection.

You are strongly advised to read the manual section on Events here:
<https://github.com/seL4/camkes-tool/blob/master/docs/index.md#an-example-of-events>.

  ''Ensure that when declaring the consumes and emits keywords between
  the Client.camkes and Echo.camkes files, you match them up so that
  you're not emitting on both sides of a single interface, or consuming
  on both sides of an interface.''

### TASK 10, 11, 14, 15, 22, 25
 Recall that CAmkES prefixes the name
of the interface instance to the function being called across that
interface? This is the same phenomenon, but for events; in the case of a
connection over which events are sent, there is no API, but rather
CAmkES will generate \_emit() and \_wait() functions to enable the
application to transparently interact with these events.

### TASK 18, 21, 24
 One way to handle notifications in CAmkES is to
use callbacks when they are raised. CAmkES generates functions that
handle the registration of callbacks for each notification interface
instance. These steps help you to become familiar with this approach.

------------------------------------------------------------------------

### TASK 2, 4
 Dataports are typed shared memory mappings. In your
CAmkES ADL specification, you state what C data type you'll be using to
access the data in the shared memory -- so you can specify a C struct
type, etc.

The really neat part is more that CAmkES provides access control for
accessing these shared memory mappings: if a shared mem mapping is such
that one party writes and the other reads and never writes, we can tell
CAmkES about this access constraint in ADL.

So in TASKs 2 and 4, you're first being led to create the "Dataport"
interface instances on each of the components that will be participating
in the shared mem communication. We will then link them together using a
"seL4SharedData" connector later on.

### TASK 6
 And here we are: we're about to specify connections
between the shared memory pages in each client, and tell CAmkES to link
these using shared underlying Frame objects. Fill out this step, and
proceed.

### TASK 9, 12, 13
 These steps are asking you to write some C code
to access and manipulate the data in the shared memory mapping
(Dataport) of the client. Follow through to the next step.

### TASK 19, 20, 23
 And these steps are asking you to write some C
code to access and manipulate the data in the shared memory mapping
(Dataport) of the server.

### TASK 7
 This is an introduction to CAmkES attributes: you're
being asked to set the priority of the components.

### TASK 8, 16
 This is where we specify the data access constraints
for the Dataports in a shared memory connection. We then go about
attempting to violate those constraints to see how CAmkES has truly met
our constraints when mapping those Dataports.

## Done!
 Congratulations: be sure to read up on the keywords and
structure of ADL: it's key to understanding CAmkES. And well done on
writing your first CAmkES application.
