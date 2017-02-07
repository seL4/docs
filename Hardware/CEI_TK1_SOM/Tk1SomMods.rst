= TK1-SOM Hardware Modifications =

== Adding a second UART connector ==

=== The issue: ===
 
 
The TK1-SOM has a secondary UART connection, however it's a bit of a pain to get to as a normal jumper won't fit sandwiched between the boards (below left), and you can't get to the connection from the top because of the fan & heatsink (below right).

{{jumper.jpg}} {{heatsink.jpg}}

=== What it looks like: ===

Viewed from the bottom of the CPU board, the secondary UART is the 4 unpopulated pins just under the ethernet jack pins (see below):
Research Group: Software Systems > Adding an extra UART to the TK1-SOM > connector.jpg
 
=== Right-angle connectors? ===
Initially I looked at normal right-angle 0.1" headers, but they don't fit in either direction!
 
Research Group: Software Systems > Adding an extra UART to the TK1-SOM > clearance.jpg                       Research Group: Software Systems > Adding an extra UART to the TK1-SOM > short.jpg
                
Above left: you can't connect a jack as there is no clearance to the mezzanine connector. Above right: the pins will likely short with the ethernet jack pins.
 
=== Solution: modify a dual-row header.. ===

A normal dual-row 0.1" header looks like this:

Research Group: Software Systems > Adding an extra UART to the TK1-SOM > 14203013_1125907040788653_366710481_o.jpg

But we only need it for clearance - which we can do by just taking out the bottom 2 rows of pins:

Research Group: Software Systems > Adding an extra UART to the TK1-SOM > 14203078_1125907047455319_543597542_o.jpgResearch Group: Software Systems > Adding an extra UART to the TK1-SOM > 14202988_1125907050788652_1468451190_o.jpg

(It's easiest to use pliers to push the pins out a little bit, bend them, and then pull them all the way out)

Eventually, you end up with this (Only the top row left):


Research Group: Software Systems > Adding an extra UART to the TK1-SOM > 14203586_1125907067455317_1649032044_o.jpg

Now you can solder the pins on (make sure the pins are directed toward the ethernet jack so there's enough clearance!)

Research Group: Software Systems > Adding an extra UART to the TK1-SOM > 14191325_1125907080788649_54990137_o.jpg

Make sure not to use too much heat in this step, there are a few 0201 components nearby which can easily come off just because of the nearby heat.
Also be sure to keep the iron angled away from the connectors as it is quite easy to accidentally melt them.

Once done, put the TK1-SOM back together and you have some easily accessible UART pins:

Research Group: Software Systems > Adding an extra UART to the TK1-SOM > final.jpg

The pinout & levels are described in the TK1-SOM reference guide - this connector is called J2000. (Pin 1 is the square pad)

Note the 1V8 logic levels!
