seL4 supports the the
[KZM-ARM11-01](http://www.kmckk.com/eng/kzm.html), which can
also be simulated in qemu.

# Simulation


Checkout the sel4test project using repo as per
[Getting started](https://wiki.sel4.systems/Getting%20started#Getting_the_SEL4_Test_source_code)

{{{\#!highlight bash numbers=off make
kzm_simulation_release_xml_defconfig make make simulate-kzm }}}

See the sel4test
[Makefile](https://github.com/seL4/sel4test/blob/master/Makefile#L51)
for details on the targest. = Booting =

TODO
