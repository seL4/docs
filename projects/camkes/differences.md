---
parent: /projects/camkes/
toc: true
redirect_from:
  - /CAmkESDifferences
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# Differences between CAmkES 2 and 3


## Rich Types for Settings


Previously all attribute settings were treated as strings by templates.
Settings are now interpreted as an appropriate python type.
```c
// list
foo.bar = [0x60, 0x64];

// boolean
moo.cow = true;

// string
baz.qux = "hello";

// dict
crazy.stuff = { "key" : ["polymorphic", 42, "list",
                 {"hello":true} ] };

// appropriate numeric type 
arithmetic.expressions = 1 << (2 ** 2) == 3 ? -2 : 0x9;
```

Arbitrary ids are no longer allowed as setting values:
```c
a.b = c; // error
```

## Parametrised Buf Type


The `Buf` dataport type can now be optionally parametrised by the
size (in bytes) of the dataport. The syntax for this is `Buf(size)`.
If left unspecified, the default size is 4096 bytes.

It is an error to connect dataport interfaces of different sizes.

E.g.
```c
component Foo {
    dataport Buf(8192) dp;
}

component Bar {
    dataport Buf(8192) dp;
}

assembly {
    composition {
        component Foo foo;
        component Bar bar;
        connection seL4SharedData conn(from foo.dp, to bar.dp);
    }
}
```

## Asynch Connector Renamed


The `seL4Asynch` connector has been renamed to
`seL4Notification`.

## Non-Volatile Dataports


Previously, c symbols used to access dataports had volatile pointer
types. Users were encouraged to use volatile pointers to prevent the
compiler optimizing away, or re-ordering, accesses to shared memory.

This is no longer the case. The c symbols referring to dataports are
regular (ie. non-volatile) pointer types, and programmers are required
to explicitly "acquire" and "release" dataports to prevent harmful
re-ordering (at both compile time and runtime). The motivations for this
change are: * Treating dataports as always volatile prevents the
compiler from re-ordering any accesses to them, even in cases where it
won't affect the correctness of programs. Using non-volatile dataports
allows the compiler to make better optimizations. * Preventing compiler
reordering (ie. with volatile) is not sufficient to make shared memory
coherent in a multicore environment. Changes made to shared memory by
one core may become visible to other cores in a different order. *
Using functions from the standard library on dataports (e.g. passing a
string in a dataport to `strlen`) requires casting from a volatile
pointer to a regular pointer - an undefined operation in c.

For a dataport interface `foo`, a component has access to
`foo_acquire()` and `foo_release()` functions (they may
instead be macros). Call `foo_acquire()` between multiple reads
from a dataport, where the correct behaviour of the program depends on
the contents of the dataport possibly changing between reads. Call
`foo_release()` between multiple writes to a dataport, where the
correct behaviour of the program depends on writes preceding the
`foo_release()` in the program code being performed strictly before
the writes following it.

## Many-to-Many Connections


There is new syntax for connections with multiple from/to sides. The
following fragments are equivalent (except for connection names):
```c
connection seL4RPCCall foo(from a.x, to c.z);
connection seL4RPCCall bar(from b.y, to c.z);
```
```c
connection seL4RPCCall foobar(from a.x, from b.y, to c.z);
```

Both syntaxes are supported by CAmkES 3.

## Hardware Component Configuration Attributes


The attributes for configuring hardware components have changed. Below
is a CAmkES 2 spec, followed by the equivalent CAmkES 3 spec. These
changes are not backwards compatible.

These component definitions are the same in CAmkES 2 and 3:
```c
component Device {
  hardware;
  dataport Buf registers;
  emits Interrupt interrupt;
  provides IOPort port;
}

component Driver {
    dataport Buf registers; consumes Interrupt interrupt; uses IOPort
    port;
}
```

The composition section of the spec is the same for CAmkES 2 and 3:
```c
assembly {
  composition {
    component Device device;
    component Driver driver;

    connection seL4HardwareMMIO mmio(from driver.registers, to device.registers);
    connection seL4HardwareInterrupt interrupt(from device.interrupt, to driver.interrupt);
    connection seL4HardwareIOPort ioport(from driver.port, to device.port);
  }
  configuration {
    // see below
  }

}
```

CAmkES 2 configuration:
```c
configuration {
  device.registers_attributes = "0x12345000:0x1000"; // string in format "paddr:size"
  device.interrupt_attributes = 27;                  // irq number
  device.port_attributes = "0x40:0x40";              // string in format "start_port:end_port"
}
```

CAmkES 3 configuration:
```c
configuration {
  device.registers_paddr = 0x12345000;  // separate attribute for paddr and size
  device.registers_size = 0x1000;
  device.interrupt_irq_number = 27;     // attribute name has changed
  device.port_attributes = "0x40:0x40"; // unchanged
}
```

## Interrupt API


In CAmkES 2, interrupts were abstracted as CAmkES events, emitted from a
hardware component. For a component with an interface `foo`
connected to an interrupt, components could call `foo_wait()`,
`foo_poll()`, and `foo_reg_callback()`, as with a regular
event.

In CAmkES 3, interrupts are still abstracted as events in the ADL
(CAmkES spec). Component implementations however, use a different
interface for interacting with interrupts than with regular event
interfaces. More specifically, a component with an interface `foo`
connected with the `seL4HardwareInterrupt` connection has access to
`foo_acknowledge()` which acknowledges the associated interrupt to
the kernel. In addition, the component implementation must provide a
definition of a function `void foo_handler(void)`. The standard
event methods (`foo_wait()`, `foo_poll()`, and `foo_reg_callback()`) are not implemented for interrupts.

The user-provided function `foo_handler()` will be called by a
dedicated interrupt-handling thread (one thread per interface connected
with `seL4HardwareInterrupt`). Unlike callbacks registered with
`*_reg_callback`, interrupt handlers do not need to be explicitly
registered, and do not become unregistered after calling.

## Hierarchical Components


The syntax for defining hierarchical components has changed in CAmkES 3.
CAmkES 2 had special connectors used to export an interface of a
sub-component:
```c
component Serial {

  // interface of this component 
  provides UartIface serial;
 
  composition {
 
    // internal components
    component UartDevice uart_device;
    component UartDriver uart_driver;

    // internal connection
    connection seL4HardwareMMIO conn(from uart_device.regs, to uart_driver.regs);
  
    // export interface of driver component as interface of this component
    connection ExportRPC exp(from uart_driver.uart, to serial);
 
  }
}
```

CAmkES 3 introduces special syntax for exposing interfaces of
sub-components:
```c
component Serial {

  // interface of this component
  provides UartIface serial;
 
  composition {
 
    // internal components
    component UartDevice uart_device;
    component UartDriver uart_driver;

    // internal connection
    connection seL4HardwareMMIO conn(from uart_device.regs, to uart_driver.regs);

    // export interface of driver component as interface of this component
    export uart_driver.uart -> serial;
 
  }
}
```
