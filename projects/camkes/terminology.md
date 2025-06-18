---
parent: /projects/camkes/
redirect_from:
  - /CAmkES/Terminology
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Terminology
 Throughout this document some domain specific
terminology is used that may have connotations outside CAmkES/component
systems. To avoid confusion the meanings of these terms are made
explicit below.

### Abstract Syntax Tree (AST)


An internal representation of the results of parsing a
generalised grammar. More thorough definitions of ASTs are provided
[elsewhere](https://en.wikipedia.org/wiki/Abstract_syntax_tree),
but this is noted here because the abbreviation 'AST' is used
heavily in this documentation.

### Architecture Description Language (ADL)


The CAmkES syntax for describing a component system. Most
component platforms have their own architecture description language
for describing a set of components and how they are wired together,
but the term 'ADL' will be used in this documentation to exclusively
refer to the CAmkES input specification language.

### Assembly


A top-level element that encapsulates a component
system description. An assembly can be thought of as a complete
description of a full system. A system must contain at least
one assembly. A system with more than one assembly is equivalent to
a system with one assembly whose composition and configuration
sections are the concatenation of the composition and configuration
sections of each assembly.

### Attribute


Components and connectors can have extra data of an arbitrary type
associated with them. These are referred to as attributes. The
description of a component/connector must describe the name of the
attribute and its type. The value of the attribute itself
is unspecified. It is assigned when the entity is instantiated, and
this assignment is referred to as a *setting*. Attributes are
generally used to specialise or differentiate a component
at runtime.

### Component


A *type* of functional entity. It is important to stress
this distinction. 'Component' is used colloquially to refer to both
types and instances, but in a formal sense 'component' refers only
to the type. To make this more concrete, the statement component foo
f describes a component *instance* f, whose *type* is foo.

### Composition


A container for the component and connector instantiations that
form a system. This is essentially a syntactic element for
delimiting sections in a specification. It is contained by an
assembly block, along with an optional configuration.

### Compound Component


A component with a composition section, and optionally a
configuration section.

### Configuration


A container for describing settings. This is a syntactic element
to hold the assignment of attributes for a given system. It is
expressed inside an assembly block.

### Connection


An instantiation of a connector. Connections connect
two *instances*. Because the instantiation of a connector does not
really specialise the connector in any particular way, it is easy to
conflate the two. However, the sources make important distinctions
between connectors and connections.

### Connector


A *type* of link between instances. The distinction between
'connector' and 'connection' is the same as that between 'component'
and 'instance,' i.e. a connection is an instantiation of a
particular connector.

### Consumes


Event interfaces that are accepted by a component. If a component
consumes a particular event it means that it is expecting to receive
and handle that event.

### Dataport


Port interfaces that are used by a component. A component's
dataports are expected to be available to it at runtime as shared
memory regions.

### Direction


The flow of a parameter of a procedure method. The only possible
directions are 'in' (caller to callee), 'out' (callee to caller),
'inout' (bidirectional) and 'refin' (identical to 'in' except for
the C backend where this is optimised to pass-by-reference).

### Emits


Event interfaces that are expressed by a component. If a component
emits a given event it means that it produces events of this type.

### Event


An asynchronous signal interface of a component. Events are
defined completely by their identifier, a numerical value. It may be
helpful to think of this value as mapping to something like an
interrupt number or a signal type, although they do not necessarily
represent hardware messages.

### Export Connector


A special type of connector which can only appear inside a
compound component's composition section. It can be used to connect
one of the compound component's interfaces to an interface of an
internal instance declared in the compound component's
composition section. Interfaces of compound components connected
with an export connector are considered "Virtual Interfaces".
Interfaces of internal instances connected to virtual interfaces are
known as "Exported Interfaces".

### Exported Interface


An interface of an internal instance connected to a virtual
interface with an export connector.

### Instance


An instantiation of a component type. Of course 'instance' can be
used to refer to an instantiation of any type, but when you see the
term 'instance' in the sources it is generally referring to the
instantiation of a component. To give a concrete example, in the
statementcomponent foo f f is an instance.

### Interface


An abstract exposed interaction point of a component. There could
be a distinction made here between type and instance of one of these
interaction points, but in practice this is not necessary and
ambiguity rarely arises. The subcategories of interface are
*procedure*, *event*and *port*.

### Interface Definition Language (IDL)


A subset of CAmkES ADL for describing interfaces of components.
Previously this was considered distinct from ADL, but now the term
'ADL' is intended to encompass both syntaxes. The CAmkES IDL subset
is heavily inspired by
[OMG IDL](http://www.omg.org/gettingstarted/omg_idl.htm).

### Internal Instance


A component instance declared inside a compound component's
composition section.

### Internal Connection


A connection declared inside a compound component which connects
two internal instance interfaces. That is, any connection declared
inside a compound component which does not use an export connector.

### Method


An item of a procedure. When targeting a conventional programming
language, methods usually map directly to generated functions.

### Parameter


A piece of data referenced by a procedure method. This can be
thought of as an argument to a function.

### Port


The interface type that represents shared memory semantics.

### Procedure


An interface with function call semantics. Procedures consist of a
series of methods that can be invoked independently.

### Provides


Procedure interfaces implemented by a component. When targeting a
conventional programming language this typically means that the
component contains functions that are implementations of each method
in the procedures provided.

### Setting


An assignment of an attribute to a specific value. A setting does
not specify the type of the attribute, because this has already been
described by the attribute as specified in the
component/connector description.

### Type


A procedure method's return type or parameter type. This
information does not include the direction of a parameter. An
example type is something like 'string.'

### Uses


Procedure interfaces that are invoked by a component. When
targeting a conventional programming language this typically means
that the component contains calls to functions that are expected to
implement each method in the procedures used.

### Virtual Interface


An interface of a compound component connected to an internal
instance's interface using an export connector.

## A concrete example:
```c
procedure thing {
  int func(in int x);
}

event sig = 42;

dataport Buf buffer;

component foo {
  control;
  uses thing t1;
  emits sig s1;
  dataport buffer b1;
}

component bar {
  provides thing t2;
  consumes sig s2;
  dataport buffer b2;
}

assembly {
  composition {
    component foo f;
    component bar b;

    connection RPC c1(from f.t1, to b.t2);
    connection Notification c2(from f.s1, to b.s2);
    connection SharedData c3(from f.b1, to b.b2);
  }
}
```

- thing is a **procedure**
- int is a **type**
- func is a **method**
- in is a **direction**
- x is a **parameter**
- sig is an **event**
- buffer is a **port**
- foo and bar are **component**s
- t1 is a **uses**
- s1 is a **emits**
- b1 and b2 are **dataport**s
- t2 is a **provides**
- s2 is a **consumes**
- assembly { ... } is an **assembly**
- composition { ... } is a **composition**
- f and b are **instance**s
- RPC, Notification and SharedData are **connector**s
- c1, c2 and c3 are **connection**s

