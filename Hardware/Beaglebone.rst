= seL4 and RefOS on the Beaglebone Black =
This page contains info about building seL4 on [[http://beagleboard.org/black|Beaglebone Black]].

== Building for the Beaglebone Black ==
These instructions were written by Tim Newsham.  The Beaglebone is a community-supported port.

=== Requirements ===
We suggest using the "arm-linux-gnueabi-" cross-compilers. Use  [[https://sel4.systems/Info/GettingStarted/#toolchains|the instructions on getting a toolchain]].

=== Building ===
==== seL4test ====
First clone the seL4 repository.

{{{#!highlight bash numbers=off
  mkdir sel4test
  cd sel4test
  repo init -u https://github.com/seL4/sel4test-manifest.git
}}}

Now you must build a configuration file for your BeagleBone. Finally, build with `make` with `arm-linux-gnueabi-objcopy`.

{{{#!highlight bash numbers=off
  make menuconfig
  make
  arm-linux-gnueabi-objcopy --output-target binary \
      images/sel4test-driver-image-arm-am335x sel4test.bin
}}}

In the `menuconfig` dialog, make sure that the correct BeagleBone platform is selected for your model. This will be under Kernel -> seL4 System.


==== RefOS ====
For RefOS, first clone the repository.

{{{#!highlight bash numbers=off
  mkdir refos
  cd refos
  repo init -u https://github.com/seL4/refos-manifest.git
}}}

Now you must build a configuration file for your BeagleBone. Finally, build with `make` with `arm-linux-gnueabi-objcopy`.

{{{#!highlight bash numbers=off
  make menuconfig
  make
  arm-linux-gnueabi-objcopy --output-target binary images/refos-image refos.bin
}}}
== Booting on the Beaglebone Black ==
=== Hardware Requirements ===
 * power supply
 * serial    adapter http://elinux.org/Beagleboard:BeagleBone_Black_Serial
 * SDCard for file booting or Ethernet cable for network boot

=== Interacting with U-Boot ===
Connect a serial adapter between your development box and the Beaglebone Black. Use a serial program such as `minicom` or `screen` to connect to the serial port at 115200 bps

{{{#!highlight bash numbers=off
  screen /dev/ttyUSB0 115200
}}}
Power on the device and hit enter a few times to interrupt the normal boot process and get a U-Boot prompt.

To boot from SDcard, copy the sel4test.bin binary to a FAT32   partition on an SDCard and place the card in the Beaglebone Black.   Connect the serial device, power up the Beaglebone Black, and hit   ENTER to interrupt the normal boot process. Finally, enter the   following commands at the U-Boot prompt to load and run the image:

{{{
  fatload mmc 0 ${loadaddr} sel4test.bin
  go ${loadaddr}
}}}
To boot over Ethernet, configure your DHCP server to provide a DHCP lease and to specify the sel4test.bin (or refos.bin) as the boot   file. Configure a TFTP server to serve sel4test.bin file.  Plug the   Ethernet cable and connect the serial device to the Beaglebone   black. Power the device up and hit ENTER to interrupt the normal   boot process. Then, at the U-Boot prompt enter:

{{{
   dhcp
   go ${loadaddr}
}}}
To load an alternate image from the TFTP server at 1.2.3.4, use:

{{{
   dhcp ${loadaddr} 1.2.3.4:refos.bin
   go ${loadaddr}
}}}
== Other resources ==
 * [[http://julien.gunnm.org/geek/sel4/beaglebone%20black/2016/06/15/beaglebone-black-sel4-uart1/|Supporting the UART1 interface with CAmkES]]
