seL4 supports the the [[http://www.kmckk.com/eng/kzm.html|KZM-ARM11-01]], which can also be simulated in qemu.

= Simulation =

Checkout the sel4test project using repo as per [[https://wiki.sel4.systems/Getting%20started#Getting_the_SEL4_Test_source_code|Getting started]]

{{{
make kzm_simulation_release_xml_defconfig
make
make simulate-kzm
}}}

See the sel4test [[https://github.com/seL4/sel4test/blob/master/Makefile#L51|Makefile]] for details on the targest. 
= Booting =

TODO
