# KZM

seL4 supports the the
KZM-ARM11-01, which can
also be simulated in qemu.

## Simulation


Checkout the sel4test project using repo as per
[seL4Test](/Testing)
~~~bash
make kzm_simulation_release_xml_defconfig
make
make simulate-kzm
~~~

See the sel4test
[Makefile](https://github.com/seL4/sel4test/blob/master/Makefile#L57)
for details on the targets.
