= Child enumeration model for the seL4 Driver API: =

== Contents ==
<<TableOfContents()>>

== Constants ==
#define SEL4DRV_DEVATTR_NAME_MAXLEN (32)

== Functions ==
{{{
seL4drv_mgmt_enumerate_get_num_children():
seL4drv_mgmt_enumerate_children();
seL4drv_mgmt_enumerate_hotplug_subscribe();
uint16_t seL4drv_mgmt_query_device_match();
}}}

== Structures ==
typedef struct seL4drv_child_attribute_ {
   char attr_name[SEL4DRV_DEVATTR_NAME_MAXLEN];
   uint32_t attr_value;
} seL4drv_child_attribute_t;

== Child IDs ==
Each driver whose device is capable of enumerating child devices must generate a unique child ID for each such child. The child ID is not required to be globally unique, but it must be unique with respect to all of of that device's children (i.e, with respect to its siblings).

The Environment and the host OS may choose to use some other internal representation of such child IDs that best suits its device tree, but this child ID shall be passed back to the driver exactly as originally given by the driver, for any API call into the driver that requires a child ID.

== Procedural flow ==
The intention of the enumeration API is to enable the environment to both build and maintain its "device tree", which it uses to track the status and availability of hardware. The enumeration API enables initial discovery of hardware devices, as well as dynamic discovery and removal of devices from the tree as they appear and disappear.

The environment should begin an enumeration sequence by calling `seL4drv_mgmt_enumerate_get_num_children()` on the target device instance, in order to ask the driver to tell it how many child devices it '''currently''' has. The parent driver shall report '''all''' such child devices, regardless of whether or not they are powered on. All devices which are operationally viable and functional should be reported to the environment.

After that, the environment should call `seL4drv_mgmt_enumerate_children()` to actually get information on all the target device instance's children. The environment shall pass to this function a block of memory that is suitably sized to enable the driver to fill out the childrens' information. Please see the description of `seL4drv_mgmt_enumerate_get_num_children()` in its section below to understand how to determine how much memory to allocate when requesting child device information.

The driver will then fill out this information for each child device, and return the information to the environment.

== Hotplug device enumeration ==
The API supports hotplug device enumeration through the means of a "subscription" function. The driver does not initiate a notification to the environment. Rather, the environment posts an indication of interest (subscription notification), along with an asynchronous context preserving cookie. The driver shall keep this context cookie until a hotplug event occurs (whether the addition or removal of a device), and at such a time, it shall generate the asynchronous callback that completes the asynchronous roundtrip for the "subscription" invocation.

When the environment finally gets such a callback, it shall simply refresh its information about the children of the target device, by once again calling `seL4drv_mgmt_enumerate_get_num_children()`, and doing a re-run of `seL4drv_mgmt_enumerate_children()`. The environment can then compare the '''Child IDs''' of the newly returned list of devices with those that it previously had in its device tree, and perform an update of its device tree.

When the driver completes the asynchronous roundtrip, it shall return the same memory that was originally passed to it by the environment. The environment is then free to either re-subscribe to such notifications by calling `seL4drv_mgmt_enumerate_hotplug_subscribe_ind()` again, or to choose to indicate that it is no longer interested in subscribing to such notifications by not calling it again.

== API ==

=== seL4drv_mgmt_enumerate_get_num_children(): Sync ===
This function allows the environment to know how much memory it should allocate for its subsequent calls to `seL4drv_mgmt_enumerate_children()`.

There are two values returned by this function:
 1. The number of child devices that the driver instance is aware of. ''Let this value be N_children''.
 2. The number of attributes required to describe each child device. ''Let this value be N_attrs_per_child''.

The environment is expected to allocate memory equal to `N_attrs_per_child * sizeof(seL4drv_child_attribute_t)` for each child device.

If `seL4drv_mgmt_enumerate_get_num_children()` reports that there are multiple child devices, the environment is expected to allocate memory equal to `N_attrs_per_child * sizeof(seL4drv_child_attribute_t) * N_children`.

This amount of memory shall then be passed to `seL4drv_mgmt_enumerate_children()`.

=== seL4drv_mgmt_enumerate_children(): Sync ===
This function shall cause the driver to return a list of child devices and their attributes, as well as Child IDs for each of the children, according to the its discretion, deferring to the constraints outlined above.

=== seL4drv_mgmt_enumerate_hotplug_subscribe(): Async ===
This function shall transfer to the driver a block of memory which shall be kept by the driver until a hotplug event occurs. When such an event occurs, the driver shall complete the asynchronous roundtrip by calling back to the environment, returning the memory to the environment in so doing.

=== seL4drv_mgmt_identify_device(): Sync ===
This function shall take a list of attributes that describe a device, and return an unsigned integer which states whether or not the driver can handle the device that is described by those attributes.

If the driver determines that the passed attributes do not describe a device that it can manage, the driver '''shall''' return integer `0` (zero). If the driver determines that the passed attributes describe a device that it is equipped to handle, it '''shall''' return a positive integer `1`.

''It is recommended that drivers which return a value greater than `0` should return `1` for now, since in the future, significance will be ascribed to the values returned. At present, there is no significance attached to the particular value returned, but for future compatibility since values above `1` will carry significance, drivers must return `1` for now.''
