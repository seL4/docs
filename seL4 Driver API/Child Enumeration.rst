= Child enumeration model for the seL4 Driver API: =

== Constants ==
{{{
seL4drv_mgmt_enumerate_get_num_children():
seL4drv_mgmt_enumerate_children();
seL4drv_mgmt_enumerate_hotplug_subscribe();
}}}

== Functions ==

== Child IDs ==
Each driver whose device is capable of enumerating child devices must generate a unique child ID for each such child. The child ID is not required to be globally unique, but it must be unique with respect to all of of that device's children (i.e, with respect to its siblings).

The Environment and the host OS may choose to use some other internal representation of such child IDs that best suits its device tree, but this child ID shall be passed back to the driver exactly as originally given by the driver, for any API call into the driver that requires a child ID.

== Procedural flow ==
The intention of the enumeration API is to enable the environment to both build and maintain its "device tree", which it uses to track the status and availability of hardware. The enumeration API enables initial discovery of hardware devices, as well as dynamic discovery and removal of devices from the tree as they appear and disappear.

The environment should begin an enumeration sequence by calling `seL4drv_mgmt_enumerate_get_num_children()` on the target device instance, in order to ask the driver to tell it how many child devices it '''currently''' has. The parent driver shall report '''all''' such child devices, regardless of whether or not they are powered on. All devices which are operationally viable and functional should be reported to the environment.

After that, the environment should call `seL4drv_mgmt_enumerate_children()` to actually get information on all the target device instance's children. The environment shall pass to this function a block of memory that is suitably sized to enable the driver to fill out the childrens' information. The driver will then fill out this information for each child device, and return the information to the environment.

== Hotplug device enumeration ==
The API supports hotplug device enumeration through the means of a "subscription" function. The driver does not initiate a notification to the environment. Rather, the environment posts an indication of interest (subscription notification), along with an asynchronous context preserving cookie. The driver shall keep this context cookie until a hotplug event occurs (whether the addition or removal of a device), and at such a time, it shall generate the asynchronous callback that completes the asynchronous roundtrip for the "subscription" invocation.

When the environment finally gets such a callback, it shall simply refresh its information about the children of the target device, by once again calling `seL4drv_mgmt_enumerate_get_num_children()`, and doing a re-run of `seL4drv_mgmt_enumerate_children()`. The environment can then compare the '''Child IDs''' of the newly returned list of devices with those that it previously had in its device tree, and perform an update of its device tree.

When the driver completes the asynchronous roundtrip, it shall return the same memory that was originally passed to it by the environment. The environment is then free to either re-subscribe to such notifications by calling `seL4drv_mgmt_enumerate_hotplug_subscribe_ind()` again, or to choose to indicate that it is no longer interested in subscribing to such notifications by not calling it again.

== API ==

=== seL4drv_mgmt_enumerate_get_num_children(): Sync ===
This function allows the environment to know how much memory it should allocate for its subsequent calls to `seL4drv_mgmt_enumerate_children()`.

=== seL4drv_mgmt_enumerate_children(): Sync ===
This function shall cause the driver to return a list of child devices and their attributes, as well as Child IDs for each of the children, according to the its discretion, deferring to the constraints outlined above.

=== seL4drv_mgmt_enumerate_hotplug_subscribe(): Async ===
This function shall transfer to the driver a block of memory which shall be kept by the driver until a hotplug event occurs. When such an event occurs, the driver shall complete the asynchronous roundtrip by calling back to the environment, returning the memory to the environment in so doing.
