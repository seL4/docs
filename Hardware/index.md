# Supported hardware platforms
 [[Hardware/General-ARM|General info
on ARM platforms]]

[Running seL4 on VMware](Hardware/VMware)

[Running seL4 on Qemu](Hardware/Qemu)

## x86
 ||'''platform''' ||'''core''' ||'''arch'''
||'''virtualisation''' ||'''IOMMU''' ||'''status''' ||'''contributed
by''' ||'''maintained by''' ||'''description''' ||
||[PC99](Hardware/IA32) ||various ||x86 ||VT-X ||VT-D ||unverified
||Data61 ||Data61 ||PC99-style Intel Architecture 32-bit ||
||[PC99](Hardware/IA32) ||various ||x64 ||VT-X ||VT-D ||unverified
||Data61 ||Data61 ||PC99-style Intel Architecture 64-bit ||

## ARM


### ARMv6


||'''platform (board)''' ||'''chip (SoC)''' ||'''core''' ||'''arch'''
||'''virtualisation''' ||'''IOMMU''' ||'''status''' ||'''contributed
by''' ||'''maintained by''' ||'''description''' ||
||[KZM](Hardware/Kzm) ||i.MX31 ||ARM11 ||v6 ||No ||No ||unverified
||Data61 ||Data61 ||original verified version - proof no longer
maintained ||

### ARMv7A


||'''platform (board)'''||'''chip (SoC)'''||'''core'''||'''arch'''
||'''virtualisation''' ||'''IOMMU''' ||'''status''' ||'''contributed
by''' ||'''maintained by''' ||'''description''' ||
||[Arndale](Hardware/arndale) ||Exynos5 ||A15 ||v7A ||ARM HYP ||No
||unverified ||Data61 ||not regression tested but same SoC as Odroid-XU
|| || ||[BeagleBoard](Hardware/BeagleBoard) ||OMAP3 ||A8 ||v7A ||No
||No ||unverified ||Data61 ||Data61 || ||
||[Beaglebone Black](Hardware/Beaglebone) ||AM335x ||A8 ||v7A ||No
||No ||unverified ||external ||Data61 regression tested || ||
||[Inforce IFC6410](Hardware/IF6410) ||Snapdragon S4 Pro APQ8064 ||
krait (A15-like) ||v7A ||ARM HYP ||- ||unverified ||Data61 ||Data61
||Krait is a Qualcomm reimplementation of Armv7A ||
||[Jetson TK1 (NVIDIA)](Hardware/jetsontk1) ||Tegra K1 ||A15
||v7-1A ||ARM HYP ||System MMU ||unverified ||Data61 ||Data61 || ||
||[Odroid-X](Hardware/odroidx) ||Exynos4412 ||A9 ||v7A ||No ||No
||unverified ||Data61 ||Data61 || ||
||[Odroid-XU](Hardware/odriod-XU) ||Exynos5 ||A15 ||v7A ||ARM HYP
||limited System MMU ||unverified ||Data61 ||Data61 || ||
||[Sabre Lite](Hardware/sabreLite) ||i.MX6 ||A9 ||v7A ||No ||No
||verified ||Data61 ||Data61 ||current verified version ||
||[TK1 SOM (Colorado Engineering)](CEI_TK1_SOM.md) ||Tegra
K1 ||A15 ||v7-1A ||ARM HYP ||System MMU ||unverified ||Data61 ||Data61
||Small form-factor Tegra K1 || ||[[Hardware/zynq7000|Zynq-7000 ZC706
Evaluation Kit]] ||Zynq 7000 ||A9 ||v7A ||No ||No ||unverified
||Data61 ||Data61 || ||

### ARMv8A


||'''platform (board)''' ||'''chip (SoC)''' ||'''core''' ||'''arch'''
||'''virtualisation''' ||'''IOMMU''' ||'''status''' ||'''contributed
by''' ||'''maintained by''' ||'''description''' ||
||[[Hardware/zynqmp|??Zynq UltraScale+ MPSoC ZCU102 Evaluation
Kit??]] ||Zynq !UltraScale+ MPSoC ||A53 ||v8A ||ARM HYP ||System MMU
||unverified ||[DornerWorks](http://dornerworks.com/) ||Data61
|| || ||[Jetson TX1 (NVIDIA) ](Hardware/jetsontx1) || Tegra X1
||Quad A57 ||v8A ||ARM HYP ||System MMU ||unverified ||Data61 ||Data61
|| A57 has hardware support for AArch32 and AArch64. The 64-bit seL4
kernel has been ported to this board, but ''not the 32-bit kernel''. ||
||[HiKey](Hardware/HiKey) ||Kirin 620 ||A53 ||v8A ||ARM HYP ||-
||unverified ||Data61 ||Data61 || A53 has hardware support for AArch32
and AArch64. The 64-bit seL4 kernel has been ported to this board, but
''not the 32-bit kernel''. || ||[Raspberry Pi 3-b](Hardware/Rpi3)
||BCM2837 ||A53 ||v8A ||ARM HYP ||- ||unverified ||Data61 ||Data61 ||
A53 has hardware support for AArch32 and AArch64. The 64-bit seL4 kernel
has been ported to this board, but ''not the 32-bit kernel''.||
