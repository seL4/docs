== seL4SharedDataWithCaps ==

`seL4SharedDataWithCaps` is a CAmkES connector for connecting dataport interfaces, where one side of the interface has caps to the frames backing the dataport. This is different from the common dataport connector `seL4SharedData`, in which neither side has caps to the frames. `seL4SharedData` is used in the CAmkES VM to implement Cross VM Dataports, which require the VMM to map memory backing a dataport into the VM's address space - an operation which requires caps to the frames.

The templates and connector definition for `seL4SharedDataWithCaps` is in [[https://github.com/SEL4PROJ/global-components|global-components]].

For an example of this connector in action, see the [[https://github.com/seL4/camkes-vm/blob/master/apps/vm/optiplex9020.camkes#L46|CAmkES VM]].

=== Usage ===

Connect a pair of dataport interfaces, as with `seL4SharedData`. The `to` component instance on the side of the connection will have caps to the dataport frames in its cspace. The connector implements the following interface, which provides access to the caps mapping the dataport: [[https://github.com/seL4/camkes-vm/blob/3883770209ba2bfb4f85ed2b7d387731e2601b7d/common/include/dataport_caps.h|dataport_caps.h]].

The interface on the "to" side of each `seL4SharedDataWithCaps` connection must be configured with a unique id and size:
{{{
<instance>.<interface>_id = <unique integer >= 1>;
<instance>.<interface>_size = <integer size>;
}}}

Specifying a non-unique or non-positive id is an error. Specifying a size other than the size of the type of the dataport is an error.
