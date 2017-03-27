= Hardware seL4 runs on =
[[Hardware/General-ARM|General info on ARM platforms]]

[[Hardware/VMware|Running seL4 on VMware]]

== x86 ==

||'''platform'''||'''core'''||'''arch'''||'''virtualisation'''||'''IOMMU'''||'''status'''||'''contributed by'''||'''maintained by'''||'''description'''||
||[[Hardware/IA32|PC99]]|| various || x86||VT-X||VT-D|| unverified || Data61 || Data61 || PC99-style Intel Architecture 32-bit ||
||[[Hardware/IA32|PC99]]|| various || x64||VT-X||VT-D|| unverified || Data61 || Data61 || PC99-style Intel Architecture 64-bit ||

== ARM ==

||'''platform'''||'''core'''||'''arch'''||'''virtualisation'''||'''IOMMU'''||'''status'''||'''contributed'''||'''maintained'''||'''description'''||
||[[Hardware/Kzm|KZM (i.MX31)]] || ARM11 ||v6||No||No||unverified||Data61||Data61|| original verified version - proof no longer maintained ||
||[[Hardware/sabreLite|Sabre Lite (i.MX6)]] ||A9||v7A||No||No||verified||Data61||Data61|| current verified version ||
||[[Hardware/zynq7000|Zynq 7000]] ||A9||v7A||-||-||unverified||Data61||Data61||  ||
||[[Hardware/BeagleBoard|BeagleBoard (OMAP3)]] ||A8||v7||-||-||unverified||Data61||Data61|| ||
||[[Hardware/Beaglebone|Beaglebone Black (AM335x)]] ||A8||v7||-||-||unverified||external||Data61 regression tested|| ||
||[[Hardware/odriod-XU|Odroid-XU (Exynos5)]] ||A15||v7A||ARM HYP||limited System MMU||unverified||Data61||Data61||  ||
||[[Hardware/arndale|Arndale (Exynos5)]] ||A15||v7A||-||-||unverified||Data61||not regression tested but same SoC as Odroid-XU|| ||
||[[Hardware/jetsontk1|NVIDIA Tegra K1]] ||A15||v7-1||ARM HYP||System MMU||unverified||Data61||Data61|| ||
||[[Hardware/CEI_TK1_SOM|Colorado Engineering TK1 SOM]] ||A15||v7-1||ARM HYP||System MMU||unverified||Data61||Data61||Small form-factor, similar to the Tegra K1||
||[[Hardware/odroidx|Odroid-X]] ||A15||v7A||-||-||unverified||Data61||Data61||  ||
||[[Hardware/IF6410|Inforce IFC6410]] || krait (A15-like) ||v7||-||-||unverified||Data61||Data61|| Qualcomm reimplementation of Armv7||
||[[Hardware/HiKey|HiKey]] ||A53||v8A||-||-||unverified||Data61||Data61||  ||
||[[Hardware/Rpi3|Raspberry Pi 3-b]] ||A53||v8A||-||-||unverified||Data61||Data61||  ||
