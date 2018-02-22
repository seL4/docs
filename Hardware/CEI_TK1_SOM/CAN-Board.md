# The CAN Daughterboard
 The CAN Daughterboard is an open-hardware
'''CAN/SPI/I2C/Serial board''' designed by the Trustworthy Systems group
at Data61/CSIRO, that can be mounted below the power supply module of
the TK1-SOM. It provides '''two CAN buses''' implemented with MCP2515
(on the TK1-SOM's SPI bus) and voltage conversion for the two serial
ports.

{{<attachment:top.jpg%7CTop> of board|width="20%"}}
{{<attachment:bottom.jpg%7CBottom> of board|width="20%"}}
{{<attachment:side.jpg%7CSide> view of mounted stack|width="20%"}}

## Mounting
 The board attaches to the bottom of a TK1-SOM via the
expansion connector. No further work should be needed to enumerate the
device given a kernel supporting GPIO chipselects.

Note the unpopulated standoff holes on the rightmost image above --- it
is possible to fit a standoff of the same type already installed in the
TK1-SOM to stabilize the 'tower' making it easier to work with.

The part numbers of the standoffs between the CAN daughterboard and TK1
is the same as is already used between the CPU & GPU board. Order codes:

  -   '''STANDOFF '''- HEX M2.5 x 16MM ALUMINUM M-F (M2111-2545-AL)
      between pcb standoff
  -   '''SCREW''' - M2.5 x 5 MM SS PAN HEAD PHILIPS (92000A103) bottom
      pcb screw

## Using Linux with this daughterboard for CAN
 ('''hello world &
testing''') See \[\[Hardware/CEI\_TK1\_SOM/L4TCan|Using CAN on L4T
through an MCP251X\]\]

## Pinout detail
 The font on the silkscreen indicating pins is
difficult to see once the tower is assembled (wasn't enough space on the
top) - See this picture (view taken from '''bottom'''):

{{<attachment:silk.png%7CSilk> Screen|width="40%"}}

### Warning - UART Level Converter:


:   -   If using the level converter on the board, and if you are
        getting '''junk from your 3V3 serial cable''', read this:
    -   Unfortunately there is an issue with these level converter
        chips, in some impedance situations the rise time is much worse
        than indicated on the datasheet. Basically, with some serial
        cables the converter will garble signals at a high baud rate
        (&gt; 57600).
    -   This can be circumvented by changing your u-boot and extlinux to
        use a slower baud rate. 9600 is very safe, anything up to about
        57600 should be fine --- start slow and work up.

If you need the faster baud rates (or don't want to change the default
settings), '''use a 1V8 USB-TTL cable''' and plug it straight into the
TK1 as usual. This will be fixed in a future revision.

## TK1 SOC Connections
 Useful for writing drivers - this is a list of
which pins on the board correspond to which SOC pins:

Note: All I2C signals operate at 3V3 on their 0.1" headers, except
I2C\_CAM which is selectable from 1V8&lt;-&gt;3V3 in software.
||||||&lt;style="text-align:center"&gt;'''I2C''' || ||'''PIN'''
||'''BALL''' ||'''PERIPHERAL ID''' || ||I2C\_CAM\_SCL ||AF8 ||I2C3\_CLK
|| ||I2C\_CAM\_SDA ||AG8 ||I2C3\_DAT || ||I2C\_TK1\_SCL ||Y2 ||I2C2\_CLK
|| ||I2C\_TK1\_SDA ||AA2 ||I2C2\_DAT || ||I2C\_LOCAL\_SCL ||P6
||I2C1\_CLK || ||I2C\_LOCAL\_SDA ||M6 ||I2C1\_DAT ||

All SPI signals out of the TK1 are at 1V8, but are translated to 3V3 by
the board (the 0.1" header operates at 3V3)
||||||&lt;style="text-align:center"&gt;'''SPI''' || ||'''PIN'''
||'''BALL''' ||'''PERIPHERAL ID''' || ||SPI\_CLK ||AG15 ||SPI1A\_SCK ||
||SPI\_MISO ||AL18 ||SPI1A\_DIN || ||SPI\_CSN ||AL16 ||SPI1A\_CS0 ||
||SPI\_MOSI ||AK17 ||SPI1A\_DOUT ||

All UART signals out of the TK1 are at 1V8, but are translated to 3V3 by
the board. Note that UART signals will only be present on the board
outputs if the uart is actually jumpered to the converter!
||||||&lt;style="text-align:center"&gt;'''UART''' || ||'''PIN'''
||'''BALL''' ||'''PERIPHERAL ID''' || ||J8\_RTSn ||V5 ||UD3\_RTS ||
||J8\_CTSn ||V9 ||UD3\_CTS || ||J8\_TXD ||V4 ||UD3\_TXD || ||J8\_RXD
||U4 ||UD3\_RXD || ||J2000\_RXD ||L0 ||UART2\_RTS\_N || ||J2000\_TXD
||M8 ||UART2\_CTS\_N || ||J2000\_CTSn ||M1 ||UART2\_TXD || ||J2000\_RTSn
||P4 ||UART2\_RXD ||

Note that TXD (1V8) is translated to TXD (3V3). NOT TXD (1V8) &lt;-&gt;
RXD (1V8). This means that the jumper from the TK1-SOM should go from
it's TX to RX on the daughterboard for a standard ftdi pinout to work.

Note that GPIOs aren't actually brought out by the board but they are
used by the CAN controller (diagram below).
||||||&lt;style="text-align:center"&gt;'''GPIOs''' || ||'''PIN'''
||'''BALL''' ||'''PERIPHERAL ID''' || ||TK1\_GPIO0 ||AF29 ||GPIO3\_PS.05
|| ||TK1\_GPIO1 ||AA26 ||GPIO3\_PT.00 || ||TK1\_GPIO2 ||AC30
||GPIO3\_PS.06 || ||TK1\_GPIO3 ||AA31 ||GPIO3\_PS.02 || ||TK1\_GPIO4
||V28 ||GPIO3\_PS.03 || ||TK1\_GPIO5 ||W31 ||GPIO3\_PR.00 ||
||TK1\_GPIO6 ||AB31 ||GPIO3\_PR.06 || ||TK1\_GPIO7 ||Y27 ||GPIO3\_PS.04
||

### CAN Controller (MCP25625) GPIO Usage:
 {{<attachment:CAN> board
pins.PNG|MCP25625 pinout|height="168",width="458"}}

## Construction Information
 ||Schematic
||\[\[<attachment:canboard_v3.pdf>\]\] || ||PCB Sources Repository
||<https://bitbucket.csiro.au/projects/OH/repos/tk1som-can-daughterboard>
|| ||Gerber Files (in repo also)
||\[\[<attachment:Tegra_CANboard_tofab_v1.zip>\]\] || ||BOM (in repo
also) ||\[\[<attachment:CanBoardBOMDraft1.xlsx>\]\] ||

## Construction notes
 Components '''R6, R14, R19, R23 should NOT be
mounted'''. R6 and R19 are pull-up resistors that were found to cause
signal integrity issues, the other 2 resistors when mounted will supply
5v to the CAN lines and are optional.
