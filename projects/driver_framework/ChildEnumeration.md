---
redirect_from:
  - /seL4DriverAPI/ChildEnumeration
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Child enumeration model for the seL4 Driver API:


## Constants
```c
#define SEL4DRV_DEVATTR_NAME_MAXLEN (32)
```

## Functions
```c
seL4drv_mgmt_enumerate_get_num_children():
seL4drv_mgmt_enumerate_children();
seL4drv_mgmt_enumerate_hotplug_subscribe();
uint16_t seL4drv_mgmt_query_device_match();
```

## Structures
```c
typedef struct seL4drv_child_attribute_ {
   char attr_name[SEL4DRV_DEVATTR_NAME_MAXLEN];
   uint32_t attr_value;
} seL4drv_child_attribute_t;
```

## Child IDs
 Each driver whose device is capable of enumerating child
devices must generate a unique child ID for each such child. The child
ID is not required to be globally unique, but it must be unique with
respect to all of of that child's sibling devices.

The Child-ID need not be persistently unique across executions of the
driver either. The same child device may be assigned a different
child-ID if the driver is killed and then re-initialized. The purpose of
the child-ID is to form a "relational key" (to borrow a database
software term) between the driver and the environment. The same physical
child device may be given different child-IDs by its parent even within
the same execution of that parent if, for example, that child is
unplugged from the computer, and then plugged back in as a hot-plug
event; the parent driver may assign that child device a different
child-ID when it is plugged back in.

The Environment and the host OS may choose to use some other internal
representation of such child IDs that best suits its device tree, but
this child ID shall be passed back to the driver exactly as originally
given by the driver, for any API call into the driver that requires a
child ID.

## Addressing Names
 Each driver whose device is capable of
enumerating child devices must also generate a unique addressing name
for each of the children. This name does not need to be globally unique,
but it is expected to be unique with respect to all of that child
device's siblings. This addressing name must target the device by its
**location** relative to its parent bus technology.

This persistent name must always uniquely identify the same device
microcontroller relative to its parent's bus technology. For example, if
on an ISA bus, there are 4 ATA/IDE disks, and the parent ISA bus driver
wishes to generate a persistent name for each of the disks, it should
name them by their persistent locations on the ATA wire. Perhaps they
might be "ATA0-master", "ATA0-slave", "ATA1-master" and "ATA1-slave".

NB: the intention is not to uniquely identify the attached, removable
peripheral DISK that is attached to the ATA/IDE microcontroller, but to
identify the ATA/IDE microcontroller itself, which is wired onto the
silicon. The swappable disk that happens to be attached to the
interfacing microcontroller will be persistently named by the Operating
System according to that OS's own convention. That is beyond the scope
of this specification.

In the case of a PCI device, the persistent name might be the
location-based <Bus+Device+Function> combination which would
uniquely, and persistently identify a particular PCI unit across
executions. Again, the intention is not to identify the particular
peripheral that is connected on that PCI <bus+device+function>.
The recognition of a particular PCI peripheral card such as a specific
graphics card, should be left up to the higher layer Operating System
which will name that peripheral according to its own convention.

In the case of a USB device, the persistent name might be an 8-bit
location-based hub-relative identifier for the USB port, starting from
the root hub down the tree of hubs to that USB port. The actual port's
persistent name might be a simple 8-bit integer that identifies that
port's hub, concatenated with that port's address on that hub. The
parent hub might have been named by the root hub. Once again, the
generation of a persistent name for a specific USB flash disk that
happens to be plugged into any particular USB port will be handled by
the host Operating System, and is not the focus of this naming scheme.
The addressable naming scheme is attempting to determine the
bus-relative location, and not the particular peripheral that is
attached to that location/port.

## Procedural flow
 The intention of the enumeration API is to enable
the environment to both build and maintain its "device tree", which it
uses to track the status and availability of hardware. The enumeration
API enables initial discovery of hardware devices, as well as dynamic
discovery and removal of devices from the tree as they appear and
disappear.

The environment should begin an enumeration sequence by calling
`seL4drv_mgmt_enumerate_get_num_children()` on the target device
instance, in order to ask the driver to tell it how many child devices
it **currently** has. The parent driver shall report **all** such
child devices, regardless of whether or not they are powered on. All
devices which are operationally viable and functional should be reported
to the environment. By implication, faulty or malfunctioning devices, if
they can be recognized as such (e.g., if the firmware informs the driver
that a device is faulty) should be omitted.

After that, the environment should call
`seL4drv_mgmt_enumerate_children()` to actually get information on all
the target device instance's children. The environment shall pass to
this function a block of memory that is suitably sized to enable the
driver to fill out the childrens' information. Please see the
description of `seL4drv_mgmt_enumerate_get_num_children()` in its
section below to understand how to determine how much memory to allocate
when requesting child device information.

The driver will then fill out this information for each child device,
and return the information to the environment.

## Hotplug device enumeration
 The API supports hotplug device
enumeration through the means of a "subscription" function. The driver
does not initiate a notification to the environment. Rather, the
environment posts an indication of interest (subscription notification),
along with an asynchronous context preserving cookie. The driver shall
keep this context cookie until a hotplug event occurs (whether the
addition or removal of a device), and at such a time, it shall generate
the asynchronous callback that completes the asynchronous roundtrip for
the "subscription" invocation.

When the environment finally gets such a callback, it shall simply
refresh its information about the children of the target device, by once
again calling `seL4drv_mgmt_enumerate_get_num_children()`, and doing
a re-run of `seL4drv_mgmt_enumerate_children()`. The environment can
then compare the **Child IDs** of the newly returned list of devices
with those that it previously had in its device tree, and perform an
update of its device tree.

When the driver completes the asynchronous roundtrip, it shall return
the same memory that was originally passed to it by the environment. The
environment is then free to either re-subscribe to such notifications by
calling `seL4drv_mgmt_enumerate_hotplug_subscribe_ind()` again, or to
choose to indicate that it is no longer interested in subscribing to
such notifications by not calling it again.

## API


### seL4drv_mgmt_enumerate_get_num_children(): Sync
 This
function allows the environment to know how much memory it should
allocate for its subsequent calls to
`seL4drv_mgmt_enumerate_children()`.

There are two values returned by this function:

1.  The number of child devices that the driver instance is
    aware of. *Let this value be N_children*.
2.  The number of attributes required to describe each child device.
    *Let this value be N_attrs_per_child*.

The environment is expected to allocate memory equal to
`N_attrs_per_child * sizeof(seL4drv_child_attribute_t)` for each
child device.

If `seL4drv_mgmt_enumerate_get_num_children()` reports that there are
multiple child devices, the environment is expected to allocate memory
equal to
`N_attrs_per_child * sizeof(seL4drv_child_attribute_t) * N_children`.

This amount of memory shall then be passed to
`seL4drv_mgmt_enumerate_children()`.

### seL4drv_mgmt_enumerate_children(): Sync
 This function shall
cause the driver to return a list of child devices and their attributes,
as well as Child IDs for each of the children, according to the its
discretion, deferring to the constraints outlined above.

### seL4drv_mgmt_enumerate_hotplug_subscribe(): Async
 This
function shall transfer to the driver a block of memory which shall be
kept by the driver until a hotplug event occurs. When such an event
occurs, the driver shall complete the asynchronous roundtrip by calling
back to the environment, returning the memory to the environment in so
doing.

### seL4drv_mgmt_identify_device(): Sync
 This function shall take
a list of attributes that describe a device, and return an unsigned
integer which states whether or not the driver can handle the device
that is described by those attributes.

If the driver determines that the passed attributes do not describe a
device that it can manage, the driver **shall** return integer `0`
(zero). If the driver determines that the passed attributes describe a
device that it is equipped to handle, it **shall** return a positive
integer `1`.

*It is recommended that drivers which return a value greater than `0`
should return `1` for now, since in the future, significance will be
ascribed to the values returned. At present, there is no significance
attached to the particular value returned, but for future compatibility
since values above `1` will carry significance, drivers must return `1` for
now.*
