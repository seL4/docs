---
arm_hardware: true
defconfig: kzm_simulation_release_xml_defconfig
simulation_target: simulate-kzm
platform: KZM
arch: ARMv6A
virtualization: No
iommu: No
soc: i.MX31
cpu: ARM1136J
Status: Unverified
Contrib: Data61
Maintained: Data61
---
# KZM

seL4 supports the the
KZM-ARM11-01, which can
also be simulated in qemu.

The KZM is deprecated, ARMv11 Hardware which was used for the original seL4 verification. The latest
verification platform is the [SabreLite](/Hardware/sabreLite).

## Simulation

{% include sel4test.md %}
