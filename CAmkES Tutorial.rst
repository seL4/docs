##master-page:HelpTemplate
##master-date:Unknown-Date
#format wiki
#language en

= CAmkES Tutorial =
This tutorial will help you walk-through building application with procedure, event and dataport connectors.

== RPC Application ==
Let's create some simple hello world applications using the different interface types available in CAmkES. Create a new application directory with two component types:
=== Setup Directory ===
{{{
mkdir -p apps/helloworld/components/Hello
mkdir -p apps/helloworld/components/Client
}}}
=== Setup Interface ===
Functional interfaces, referred to as procedures, are made up of a set of methods. Define an interface that the components will communicate over and save this under apps/helloworld/interfaces/MyInterface.idl4:
{{{
/* apps/helloworld/interfaces/MyInterface.idl4 */

procedure MyInterface {
  void print(in string message);
};
}}}
=== Setup Component Files ===
