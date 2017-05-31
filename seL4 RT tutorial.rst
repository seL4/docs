##master-page:HelpTemplate
##master-date:Unknown-Date
#format wiki
#language en

/!\ DRAFT /!\

= seL4 MCS Tutorial =

This tutorial demonstrates how to use the real-time features of the MCS kernel API, it covers enough such that if you have already done the seL4 tutorials for master and are familiar with the API, you do not need to redo the previous ones. As a result is does duplicate some of the work from the other tutorials, but not all. 

You'll observe that the things you've already covered in the other tutorials are already filled out and you don't have to repeat them: in much the same way, we won't be repeating conceptual explanations on this page, if they were covered by a previous tutorial in the series.

= Table of Contents =
<<TableOfContents()>>

== Learning outcomes: ==

* obtain scheduling control capabilities.
* create and configure scheduling contexts. 
* spawn round-robin and periodic threads.
* set up a passive server.
* set up clients to call the passive server using the immediate priority ceiling protocol.

== Tasks ==

Before you have done any tasks, when running the tutorial should produce the following before halting:

{{{
mcs main@main.c:179 [Cond failed: sched_control == seL4_CapNull]
        Failed to find sched_control.
}}}

=== TASK 1 ===

Create a scheduling context. The simplest way is to use the VKA interface.

The output should not change after finishing TASK 1.

=== TASK 2 === 

Find the scheduling control capability. There is one per node in the system. This allows you to populate scheduling contexts with parameters.

{{{
TODO output
}}}

=== TASK 3 === 

Configure the scheduling context as a round robin thread using the sched_control capability obtained in TASK 2 and the scheduling context created in TASK 1.
 
Once you have reached this point, the tutorial output should change:

{{{
Ping
Pong
Ping
Pong
Ping
Pong
}}}

== TASK 4 == 

Convert the round robin thread to passive by unbinding the scheduling context. Passive threads do not have their own time. This will stop the round robin thread from running. 

== TASK 5 == 

Reconfigure the scheduling context to be periodic. 

== TASK 6 ==

Rebind the scheduling context to the thread. Altering scheduling context state has no impact on the 
state of the TCB, so it will start where it left off. 

== TASK 7 ==

Convert the server to passive after it is initialised. The server runs the function `echo_server`, which is a really inefficient way to to build an ipc echo server, but it serves as an example in this tutorial.
