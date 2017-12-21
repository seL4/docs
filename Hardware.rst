= Supported hardware platforms  =
[[Hardware/General-ARM|General info on ARM platforms]]

[[Hardware/VMware|Running seL4 on VMware]]

[[Hardware/Qemu|Running seL4 on Qemu]]

== x86 ==
||'''platform''' ||'''core''' ||'''arch''' ||'''virtualisation''' ||'''IOMMU''' ||'''status''' ||'''contributed by''' ||'''maintained by''' ||'''description''' ||
||[[Hardware/IA32|PC99]] ||various ||x86 ||VT-X ||VT-D ||unverified ||Data61 ||Data61 ||PC99-style Intel Architecture 32-bit ||
||[[Hardware/IA32|PC99]] ||various ||x64 ||VT-X ||VT-D ||unverified ||Data61 ||Data61 ||PC99-style Intel Architecture 64-bit ||


== ARM ==

=== ARMv6 ===

||'''platform (board)''' ||'''chip''' ||'''core''' ||'''arch''' ||'''virtualisation''' ||'''IOMMU''' ||'''status''' ||'''contributed''' ||'''maintained''' ||'''description''' ||
||[[Hardware/Kzm|KZM]] ||i.MX31 ||ARM11 ||v6 ||No ||No ||unverified ||Data61 ||Data61 ||original verified version - proof no longer maintained ||


=== ARMv7A ===

||'''platform (board)'''||'''chip'''||'''core'''||'''arch''' ||'''virtualisation''' ||'''IOMMU''' ||'''status''' ||'''contributed''' ||'''maintained''' ||'''description''' ||
||[[Hardware/arndale|Arndale]] ||Exynos5 ||A15 ||v7A ||- ||- ||unverified ||Data61 ||not regression tested but same SoC as Odroid-XU || ||
||[[Hardware/BeagleBoard|BeagleBoard]] ||OMAP3 ||A8 ||v7A ||No ||No ||unverified ||Data61 ||Data61 || ||
||[[Hardware/Beaglebone|Beaglebone Black]] ||AM335x ||A8 ||v7A ||No ||No ||unverified ||external ||Data61 regression tested || ||
||[[Hardware/IF6410|Inforce IFC6410]] ||Snapdragon S4 Pro APQ8064 || krait (A15-like) ||v7A ||- ||- ||unverified ||Data61 ||Data61 ||Qualcomm reimplementation of Armv7A ||
||[[Hardware/jetsontk1|Jetson TK1 (NVIDIA)]] ||Tegra K1 ||A15 ||v7-1A ||ARM HYP ||System MMU ||unverified ||Data61 ||Data61 || ||
||[[Hardware/odroidx|Odroid-X]] ||Exynos4412 ||A15 ||v7A ||No ||No ||unverified ||Data61 ||Data61 || ||
||[[Hardware/odriod-XU|Odroid-XU]] ||Exynos5 ||A15 ||v7A ||ARM HYP ||limited System MMU ||unverified ||Data61 ||Data61 || ||
||[[Hardware/sabreLite|Sabre Lite]] ||i.MX6 ||A9 ||v7A ||No ||No ||verified ||Data61 ||Data61 ||current verified version ||
||[[Hardware/CEI_TK1_SOM|TK1 SOM (Colorado Engineering)]] ||Tegra K1 ||A15 ||v7-1A ||ARM HYP ||System MMU ||unverified ||Data61 ||Data61 ||Small form-factor Tegra K1 ||
||[[Hardware/zynq7000|Zynq-7000 ZC706 Evaluation Kit]] ||Zynq 7000 ||A9 ||v7A ||- ||- ||unverified ||Data61 ||Data61 || ||


=== ARMv8A ===

||'''platform (board)''' ||'''chip''' ||'''core''' ||'''arch''' ||'''virtualisation''' ||'''IOMMU''' ||'''status''' ||'''contributed''' ||'''maintained''' ||'''description''' ||
||[[Hardware/zynqmp|??]] ||Zynq UltraScale+ MPSoC ||A53 ||v8A ||- ||- ||unverified ||[[http://dornerworks.com/|DornerWorks]] ||Data61 || ||
||[[Hardware/jetsontx1|Jetson TX1 (NVIDIA) ]] || Tegra X1 ||Quad A57 ||v8A  || || ||unverified ||Data61 ||Data61 || A57 has hardware support for AArch32 and AArch64. The 64-bit seL4 kernel has been ported to this board, but ''not the 32-bit kernel''. ||
||[[Hardware/HiKey|HiKey]] ||Kirin 620 ||A53 ||v8A ||- ||- ||unverified ||Data61 ||Data61 || A53 has hardware support for AArch32 and AArch64. The 64-bit seL4 kernel has been ported to this board, but ''not the 32-bit kernel''. ||
||[[Hardware/Rpi3|Raspberry Pi 3-b]] || ||A53 ||v8A ||- ||- ||unverified ||Data61 ||Data61 || A53 has hardware support for AArch32 and AArch64. The 64-bit seL4 kernel has been ported to this board, but ''not the 32-bit kernel''.||
