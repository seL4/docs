= The TK1-SOM Daughterboard =

The TK1-SOM Daughterboard is an open-hardware daughterboard designed by the Trustworthy Systems group at Data61/CSIRO, that can be mounted to the TK1-SOM.
It provides '''CAN buses''', '''serial''','''sensors''', '''power management''', '''PWM outputs''' and other features that allow the TK1-SOM to be used as a flight controller for a quadcopter.

{{attachment:tk1_1.jpg|Side of board|width="30%"}}{{attachment:tk1_2.jpg|Side of board|width="30%"}}{{attachment:tk1_render_3.PNG|Top of board|width="30%"}}

... More information to be added

== Technical documentation ==
 * Schematic PDF (includes changes for current boards):
 * Bill of Materials:
 * Project repository: [[https://bitbucket.csiro.au/projects/OH/repos/tk1som-quadcopter-daughterboard|Altium files]]

== Connecting the Daughterboard ==
Going from a TK1-SOM, a pixhawk/IRIS and a daughterboard to a functioning system requires:
 * [[#mount_tk1|Mounting the TK1 to the daughterboard]]
 * [[#jumper_uart|Jumpering the UART level translators]]
 * [[#jumper_reset|Jumpering the RESET button]]
 * [[#attach_pix_pwr|Attaching the pixhawk power cable]]
 * [[#attach_can|Attaching the CAN bus cable]]
 * [[#attach_telem|Attaching the telemetry cable]]
 * [[#connect_power|Connecting the power harness]]
 * [[#connect_battery_psu|Connecting the battery '''OR''' Connecting the external PSU]]

=== Mounting the TK1 to the daughterboard ===
<<Anchor(mount_tk1)>>

=== Jumpering the UART level translators ===
<<Anchor(jumper_uart)>>

=== Jumpering the RESET button ===
<<Anchor(jumper_reset)>>

=== Attaching the pixhawk power cable ===
<<Anchor(attach_pix_pwr)>>

=== Attaching the CAN bus cable ===
<<Anchor(attach_can)>>

=== Attaching the telemetry cable ===
<<Anchor(attach_telem)>>

=== Connecting the power harness ===
<<Anchor(connect_power)>>

=== Connecting the battery OR external PSU ===
<<Anchor(connect_battery_psu)>>
