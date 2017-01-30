= The TK1-SOM Daughterboard =
The TK1-SOM Daughterboard is an open-hardware daughterboard designed by the Trustworthy Systems group at Data61/CSIRO, that can be mounted to the TK1-SOM. It provides '''CAN buses''', '''serial''','''sensors''', '''power management''', '''PWM outputs''' and other features that allow the TK1-SOM to be used as a flight controller for a quadcopter.

{{attachment:tk1_1.jpg|Side of board|width="30%"}} {{attachment:tk1_2.jpg|Side of board|width="30%"}} {{attachment:tk1_render_3.PNG|Top of board|width="30%"}}

... More information to be added

== Technical documentation ==
 * [[attachment:daughterboard_r3a_schematic.pdf|Schematic PDF]] (See '[[#errata|Technical errata for R3A]]' for changes)
 * Bill of Materials:  [[attachment:tegra_daughterboard_bom3.xls]]
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

=== Technical errata for R3A, to be fixed next revision ===
<<Anchor(errata)>>

 * U8 (LSM303D, one of the many inertial sensors) is not mounted due to a footprint error.
 * D10 & D11 CAN Reset diodes are not mounted on some boards. This has been tested OK, the diodes are just to improve CAN chip reset times - but we aren't actually using the CAN reset line.
 * R35 & R45 to supply power through the CAN ports ARE mounted. This was to make testing easier as only one cable was required to the pixhawk. The pixhawk may draw too much power in full operation for this to be enough, hence the primary pixhawk power cable which should be used.
 * The LV cutout circuitry does not seem to work reliably. Since the IRIS battery is disconnected when not in use anyway, this should not be a huge issue.
 * On schematic sheet 5, the 'Do not populate' remarks indicate the wrong designators. They should indicate R35 & R45, however these are actually mounted (see note above)
 * R40 & R49 pull-ups on the SPI CSN line are not mounted. These were found to cause signal integrity issues. Additionally, the silkscreen for R51 and R49 is swapped on the PCB.
 * R57 - R72 (Current limiting resistors for D12-D27), a value of 560 ohm was used instead of 10K ohm to increase their brightness.
