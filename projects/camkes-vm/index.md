---
toc: true
redirect_from:
  - /VM/CAmkESX86VM
project: camkes-vm
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---
# CAmkES VMM

{% include include_github_repo_markdown.md repo='sel4/camkes-vm-examples' file='README.md' %}

## CAmkES x86 VM

### Prerequisites

* Get the dependencies for building CAmkES by following
the instructions [here](HostDependencies#camkes-build-dependencies)
* Your host machine has to have a CPU that supports Vt-x virtualization
 (for Intel CPUs), or AMD-V (for AMD CPUs, but that wasn't tested). Any
  newer i7 core should have Vt-x. Note that you might have to enable it
  first from BIOS. You can always check by `lscpu` and look for **vmx** flag.

### Tutorials

Use the following tutorials to learn about the VM:

{% assign tutorials = site.pages | where_exp: 'page', 'page.tutorial' | sort: 'tutorial-order' %}
{%- for t in tutorials %}
{%- if t.tutorial-order contains 'vm' %}
1. [{{t.title}}]({{t.url}}) {{t.description}}
{%- endif %}
{%- endfor %}


### Examples

- [Centos](centos)
- [zmq_samples](zmq-samples)


### Booting from hard drive


These instructions are for ubuntu. For CentOS instructions, see
[CAmkESVMCentOS](CAmkESVMCentOS).

So far we've only run a tiny linux on a ram disk. What if we want to run
Ubuntu booting off a hard drive? This section will explain the changes
we need to make to our VM app to allow it to boot into a Ubuntu
environment installed on the hard drive. Thus far these examples should
have been compatible with most modern x86 machines. The rest of this
tutorial will focus on a particular machine:
[the cma34cr
single board computer](https://www.rtd.com/PC104/CM/CMA34CR/CMA34CR.htm)

The first step is to install ubuntu natively on the cma34cr. It's
currently required that guests of the camkes vm run in 32-bit mode, so
install 32-bit ubuntu. These examples will use ubuntu-16.04.

The plan will be to give the guest passthrough access to the hard drive,
and use a ubuntu initrd as our initial root filesystem, replacing the
buildroot one used thus far. We'll use the same kernel image as before,
as our vm requires that PAE be turned off, and it's on by default in the
ubuntu kernel.

#### Getting the initrd image


We need to generate a root filesystem image suitable for ubuntu. Ubuntu
ships with a tool called mkinitramfs which generates root filesystem
images. Let's use it to generate a root filesystem image compatible with
the linux kernel we'll be using. Boot ubuntu natively on the cma34cr and
run the following command:
```
$ mkinitramfs -o rootfs.cpio 4.8.16
WARNING: missing /lib/modules/4.8.16
Ensure all necessary drivers are built into the linux image!
depmod: ERROR: could not open directory /lib/modules/4.8.16: No such file or directory
depmod: FATAL: could not search modules: No such file or directory
depmod: WARNING: could not open /var/tmp/mkinitramfs_H9SRHb/lib/modules/4.8.16/modules.order: No such file or directory
depmod: WARNING: could not open /var/tmp/mkinitramfs_H9SRHb/lib/modules/4.8.16/modules.builtin: No such file or directory
```

The kernel we'll be using has all the necessary drivers built in, so
feel free to ignore those warnings and errors. You should now have a
file called rootfs.cpio on the cma34cr. Transfer that file to your dev
machine, and put it in `projects/vm/minimal`. Now we need to tell the
build system to take that rootfs image rather than the default buildroot
one. Edit `projects/vm-examples/minimal/CMakeLists.txt`. Change this line:

```cmake
AddToFileServer("rootfs.cpio" ${rootfs_file})
```
to
```cmake
AddToFileServer("rootfs.cpio" <ROOTFS_FILENAME>)
```
where `<ROOTFS_FILENAME>` is replaced with the filename of the rootfs file you
added in `projects/vm/minimal`.

Since we'll be using a real hard drive, we need to change the boot
command line we give to the guest linux. Open
`projects/vm-examples/minimal/minimal.camkes`, and change the
definition of `VM_GUEST_CMDLINE` to:
```
#define VM_GUEST_CMDLINE "earlyprintk=ttyS0,115200 console=ttyS0,115200 i8042.nokbd=y i8042.nomux=y i8042.noaux=y io_delay=udelay noisapnp pci=nomsi debug root=/dev/sda1 rdinit=/init 2"
```

Try building and running after this change:
```
BusyBox v1.22.1 (Ubuntu 1:1.22.0-15ubuntu1) built-in shell (ash)
Enter 'help' for a list of built-in commands.

(initramfs)
```

You should get dropped into a shell inside the root filesystem. You can
run commands from here:
```
(initramfs) pwd
/
(initramfs) ls
dev      run      init     scripts  var      usr      sys      tmp
root     sbin     etc      bin      lib      conf     proc
```

If you look inside `/dev`, you'll notice the lack of sda device. Linux
can't find the hard drive because we haven't passed it through yet.
Let's do that now!

We're going to give the guest passthrough access to the sata controller.
The sata controller will be in one of two modes: AHCI or IDE. The mode
can be set when configuring BIOS. By default it should be AHCI. The next
part has some minor differences depending on the mode. I'll show both.
Open `projects/vm-examples/minimal/minimal.camkes` and add the following to the
configuration section:

For AHCI:
```c
configuration {
    ...

    vm0_config.pci_devices_iospace = 1;


    vm0_config.ioports = [
        {"start":0x4088, "end":0x4090, "pci_device":0x1f, "name":"SATA"},
        {"start":0x4094, "end":0x4098, "pci_device":0x1f, "name":"SATA"},
        {"start":0x4080, "end":0x4088, "pci_device":0x1f, "name":"SATA"},
        {"start":0x4060, "end":0x4080, "pci_device":0x1f, "name":"SATA"},
    ];

    vm0_config.pci_devices = [
        {
            "name":"SATA",
            "bus":0,
            "dev":0x1f,
            "fun":2,
            "irq":"SATA",
            "memory":[
                {"paddr":0xc0713000, "size":0x800, "page_bits":12},
            ],
        },
    ];

    vm0_config.irqs = [
        {"name":"SATA", "source":19, "level_trig":1, "active_low":1, "dest":11},
    ];
}
```

For IDE:
```c
configuration {
    ...

    vm0_config.pci_devices_iospace = 1

    vm0_config.ioports = [
        {"start":0x4080, "end":0x4090, "pci_device":0x1f, "name":"SATA"},
        {"start":0x4090, "end":0x40a0, "pci_device":0x1f, "name":"SATA"},
        {"start":0x40b0, "end":0x40b8, "pci_device":0x1f, "name":"SATA"},
        {"start":0x40b8, "end":0x40c0, "pci_device":0x1f, "name":"SATA"},
        {"start":0x40c8, "end":0x40cc, "pci_device":0x1f, "name":"SATA"},
        {"start":0x40cc, "end":0x40d0, "pci_device":0x1f, "name":"SATA"},
    ];

    vm0_config.pci_devices = [
        {
            "name":"SATA",
            "bus":0,
            "dev":0x1f,
            "fun":2,
            "irq":"SATA",
            "memory":[],
        },
    ];

    vm0_config.irqs = [
        {"name":"SATA", "source":19, "level_trig":1, "active_low":1, "dest":11},
    ];
}
```

Now rebuild and run:
```
Ubuntu 16.04.1 LTS ertos-CMA34CR ttyS0

ertos-CMA34CR login:
```

You should be able to log in and use the system largely as normal.

### Passthrough Ethernet


The ethernet device is not accessible to the guest:
```
$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1
    link/sit 0.0.0.0 brd 0.0.0.0
```

An easy way to give the guest network access is to give it passthrough
access to the ethernet controller. This is done much in the same way as
enabling passthrough access to the sata controller. In the configuration
section in `projects/vm-examples/minimal/minimal.camkes`, add to the list of io
ports, pci devices and irqs to pass through:
```c
vm0_config.ioports = [
    {"start":0x4080, "end":0x4090, "pci_device":0x1f, "name":"SATA"},
    {"start":0x4090, "end":0x40a0, "pci_device":0x1f, "name":"SATA"},
    {"start":0x40b0, "end":0x40b8, "pci_device":0x1f, "name":"SATA"},
    {"start":0x40b8, "end":0x40c0, "pci_device":0x1f, "name":"SATA"},
    {"start":0x40c8, "end":0x40cc, "pci_device":0x1f, "name":"SATA"},
    {"start":0x40cc, "end":0x40d0, "pci_device":0x1f, "name":"SATA"},
    {"start":0x3000, "end":0x3020, "pci_device":0, "name":"Ethernet5"}, // <--- Add this entry
];

vm0_config.pci_devices = [
    {
        "name":"SATA",
        "bus":0,
        "dev":0x1f,
        "fun":2,
        "irq":"SATA",
        "memory":[],
    },

    // Add this entry:
    {
        "name":"Ethernet5",
        "bus":5,
        "dev":0,
        "fun":0,
        "irq":"Ethernet5",
        "memory":[
            {"paddr":0xc0500000, "size":0x20000, "page_bits":12},
            {"paddr":0xc0520000, "size":0x4000, "page_bits":12},
        ],
    },
];

vm0_config.irqs = [
    {"name":"SATA", "source":19, "level_trig":1, "active_low":1, "dest":11},
    {"name":"Ethernet5", "source":0x11, "level_trig":1, "active_low":1, "dest":10}, // <--- Add this entry
];
```

You should have added a new entry to each of the three lists that
describe passthrough devices. Building and running:
```
$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:d0:81:09:0c:7d brd ff:ff:ff:ff:ff:ff
    inet 10.13.1.87/23 brd 10.13.1.255 scope global dynamic enp0s2
       valid_lft 14378sec preferred_lft 14378sec
    inet6 2402:1800:4000:1:90b3:f9d:ae22:33b7/64 scope global temporary dynamic
       valid_lft 86390sec preferred_lft 14390sec
    inet6 2402:1800:4000:1:aa67:5925:2cbc:928f/64 scope global mngtmpaddr noprefixroute dynamic
       valid_lft 86390sec preferred_lft 14390sec
    inet6 fe80::cc47:129d:bdff:a2da/64 scope link
       valid_lft forever preferred_lft forever
3: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1
    link/sit 0.0.0.0 brd 0.0.0.0
$ ping google.com
PING google.com (172.217.25.142) 56(84) bytes of data.
64 bytes from syd15s03-in-f14.1e100.net (172.217.25.142): icmp_seq=1 ttl=51 time=2.17 ms
64 bytes from syd15s03-in-f14.1e100.net (172.217.25.142): icmp_seq=2 ttl=51 time=1.95 ms
64 bytes from syd15s03-in-f14.1e100.net (172.217.25.142): icmp_seq=3 ttl=51 time=1.99 ms
64 bytes from syd15s03-in-f14.1e100.net (172.217.25.142): icmp_seq=4 ttl=51 time=2.20 ms
```

### Figuring out information about PCI devices


To add a new passthrough device, or access a pci device in general, we
need to know which io ports it uses, which interrupts it's associated
with, and the physical addresses of any memory-mapped io regions it
uses. The easiest way to find this information is to boot linux
natively, and run the command `lspci -vv`.

### Configuring a Linux kernel build

We provide a custom kernel image with our CAmkES VM project, found [here](https://github.com/seL4/camkes-vm-linux/tree/master/images/kernel).
This kernel image is produced from building Linux 4.8.16, specifically configured with the following [.config file](https://github.com/seL4/camkes-vm-linux/tree/master/linux_configs/4.8.16).

However you may decide to build your own Linux kernel image (which may be a different version). When doing so, it is important to ensure the build is configured with the following Kbuild settings:

```
# General kernel settings
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_X86_32_SMP=n
CONFIG_SMP=n
CONFIG_NOHIGHMEM=y
CONFIG_PCI_MSI=n
CONFIG_X86_UP_APIC=n
# Power management and ACPI settings
CONFIG_SUSPEND=n
CONFIG_HIBERNATION=n
CONFIG_PM=n
CONFIG_ACPI=n
# Virtio Settings
CONFIG_VIRTIO=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_NET=y
```

You can configure these settings by either manually editing your kernel `.config` file in the root project directory or by interactively running `make menuconfig`.
