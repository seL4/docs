---
defconfig: kzm_simulation_release_xml_defconfig
simulation_target: simulate-kzm
---
# KZM

seL4 supports the the
KZM-ARM11-01, which can
also be simulated in qemu.

The KZM is deprecated, ARMv11 Hardware which was used for the original seL4 verification. The latest
verification platform is the [SabreLite](../sabreLight).

## Simulation

{% include sel4test.md %}
