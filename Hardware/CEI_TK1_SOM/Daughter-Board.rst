= The TK1-SOM Daughterboard =
The TK1-SOM Daughterboard is an open-hardware daughterboard designed by the Trustworthy Systems group at Data61/CSIRO, that can be mounted to the TK1-SOM. It provides '''CAN buses''', '''serial''','''sensors''', '''power management''', '''PWM outputs''' and other features that allow the TK1-SOM to be used as a flight controller for a quadcopter.

'''Note: this wiki page is a work-in-progress'''

=== Rough overview (top) ===
{{attachment:daughterboard_top.jpg|Top of board|width="100%"}}

=== Rough overview (bottom) ===
{{attachment:daughterboard_bottom.jpg|Bottom of board|width="100%"}}

<<Anchor(with_tk1)>>

=== With TK1 ===
{{attachment:assembly_cropped.jpg|Daughterboard with TK1|width="100%"}}

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

<<Anchor(mount_tk1)>>

=== Mounting the TK1 to the daughterboard ===
Before mounting the TK1-SOM to the daughterboard, you will have to disassemble the TK1-SOM. This will involve:

 * Removing the fan screw
 * Unscrewing the standoffs
 * Separating the 2 module 'halves'
 * Removing the fan connector

This must be done with care as it is easy to damage the TK1. Your goal is this:

{{attachment:tk1_disassemble.jpg|TK1 disassembled|width="50%"}}

Now you can start attaching the TK1 to the daughterboard. It's easy to identify which half goes where by looking at the connectors on the bottom, or the overview at the top of this page.

Firmly press both of the TK1 halves into their sockets. Try to use unpopulated parts of the PCB as 'finger positions' to avoid damaging components or connectors.

Note: Standoffs can optionally be added in this step for extra support (the friction fit supplied by the TK1 connectors should be more than sufficient in most cases). Each module has a single standoff point for an M2.5 screw, bolt, and standoff:

{{attachment:standoff.jpg|Bottom of board|width="50%"}}

The end result should look like the image under [[#with_tk1|'With TK1']] near the top of this page

<<Anchor(jumper_uart)>>

=== Jumpering the UART level translators ===
For the daughterboard to do any level translation, it needs to be connected to the TK1's UARTs. We achieve this by jumpering the TK1's UARTs to the 'UART TK1' connector on the daughterboard. (See 'rough overview', top view)

The pinout of the TK1's UARTS is the same as the pinout of the daughterboard's UART inputs. Observe:

{{attachment:UART1.jpg|UART 1 on TK1|width="40%"}} {{attachment:uart2.jpg|UART 2 on TK1|width="40%"}} {{attachment:UARTS_board.jpg|UARTs on daughterboard|width="40%"}}

The pinout of the TK1 UARTS is:

||<tablewidth="200px">PIN 1||RX||
||PIN 2||TX||
||PIN 3||CTS-L||
||PIN 4||RTS-L||


Since we aren't using flow control, you only need to connect pin 1 (TK1) to pin 1 (daughterboard), and pin 2 - pin 2 for both UARTS. You should end up with:

{{attachment:jumpered.jpg|UARTs jumpered|width="50%"}}

'''Note''': On this board, UART1 is connected to the RADIO output, the FTDI port, and the activity LEDs. UART2 is connected to the GPS output. It is possible to swap these at the TK1 input side without consequence. Additionally, one can disconnect these jumpers and use an 'ordinary' 1V8 converter for debugging.

<<Anchor(jumper_reset)>>
=== Jumpering the RESET button ===

<<Anchor(attach_pix_pwr)>>
=== Attaching the pixhawk power cable ===

The pixhawk power cable is how the daughterboard delivers power to the pixhawk. Note that this is very different to the previous daughterboards - we do not use the IRIS' power output (that would normally go into the pixhawk) for anything.

Basically, connect this:

{{attachment:pix_power.jpg|Pixhawk power input|width="30%"}}

To this:

{{attachment:pix_power_in.jpg|Pixhawk power daughterboard output|width="60%"}}

Noting again that you will have a single connector of that same type left from the IRIS power supply - this should NOT be connected to anything.

<<Anchor(attach_can)>>
=== Attaching the CAN bus cable ===

The CAN1 connector we are using (labelled 'PRIMARY CAN CONNECTOR' on 'Rough overview - Top' at the top of this page) is directly connected to the CAN port on the pixhawk. Connect one end of the 4-pin DF13 connector to the pixhawk, and the other to the daughterboard:

{{attachment:can2.jpg|CAN connector on daughterboard|width="60%"}}

The left arrow points to the connector. The right arrow points to the endpoint selection jumper. If the endpoint selection jumper is closed, CAN1 will be terminated as an endpoint. In our situation, the pixhawk and the daughterboard are endpoints, so the jumper should be closed for CAN1.

Note that the connectors on the bottom and the top of the board are connected in parallel so that the board can be used in more complex network topologies, i.e the 2 left connectors are CAN1, and the 2 right connectors are CAN2.

<<Anchor(attach_telem)>>
=== Attaching the telemetry cable ===

The telemetry connector to be connected to the 3DR RADIO has a 'RADIO' label, and it is next to the GPS connector - see 'Rough Overview - Bottom', above.

To connect it, find the 3DR RADIO cable inside the IRIS and just plug it in:

{{attachment:radio.jpg|3DR Radio connected to daughterboard|width="60%"}}

<<Anchor(connect_power)>>
=== Connecting the power harness ===

The power harness is how the daughterboard supplies power to the TK1-SOM, and also how it intercepts power from the IRIS' batteries (if it is running on batteries). This is the power harness:

{{attachment:harness1.jpg|The power harness|width="60%"}}

To connect it, plug in the molex connector under the daughterboard, and then plug into the TK1-SOM's barrel jack. Do NOT plug this into the '+12V IN' barrel jack on the side of the daughterboard. This is what you want:

{{attachment:harness2.jpg|The power harness plugged in|width="60%"}}

<<Anchor(connect_battery_psu)>>
=== Connecting the battery OR external PSU ===

There are 2 ways of powering up the daughterboard and pixhawk:
 * 1: Using the TK1-SOM's ordinary power supply (for testing)
 * 2: Using the LIPO battery on the quadcopter (for demoing)

The only difference from a functional point of view is that option 1 will only power the pixhawk, daughterboard, and TK1-SOM; not the rest of the quadcopter. The LIPO will do the same, but also provide power for the rotors etc.

In any case, for option 1: simply plug in the TK1 power supply to the '+12V IN' jack (See 'Rough overview' - Top):

{{attachment:external_power.jpg|Powered with ordinary TK1 PSU|width="60%"}}

The pixhawk, TK1 and daughterboard will all turn on. (If they are actually connected unlike the above picture!)

For option 2: Connect one end of the power harness to the main IRIS power input:

{{attachment:battery_power.jpg|Connecting to IRIS internal main power connector|width="30%"}}

and the other end to the battery. Similarly, everything should turn on.



<<Anchor(errata)>>
=== Technical errata for R3A, to be fixed next revision ===
 * U8 (LSM303D, one of the many inertial sensors) is not mounted due to a footprint error.
 * D10 & D11 CAN Reset diodes are not mounted on some boards. This has been tested OK, the diodes are just to improve CAN chip reset times - but we aren't actually using the CAN reset line.
 * R35 & R45 to supply power through the CAN ports ARE mounted. This was to make testing easier as only one cable was required to the pixhawk. The pixhawk may draw too much power in full operation for this to be enough, hence the primary pixhawk power cable which should be used.
 * The LV cutout circuitry does not seem to work reliably. Since the IRIS battery is disconnected when not in use anyway, this should not be a huge issue.
 * On schematic sheet 5, the 'Do not populate' remarks indicate the wrong designators. They should indicate R35 & R45, however these are actually mounted (see note above)
 * R40 & R49 pull-ups on the SPI CSN line are not mounted. These were found to cause signal integrity issues. Additionally, the silkscreen for R51 and R49 is swapped on the PCB.
 * R57 - R72 (Current limiting resistors for D12-D27), a value of 560 ohm was used instead of 10K ohm to increase their brightness.
