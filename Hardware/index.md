# Supported Platforms

## Verification status

The seL4 proofs are only for specific platforms, as noted in the tables for x86 and ARM below, in
the *Status* column, as follows:

* Unverified: this platform is not verfied at all and is not scheduled for verification.
* Pending: this feature is currently undergoing verification.
* FC: the functional correctness proofs are complete.
* FCI: the integrity proofs are complete, in addition to functional correctness.
* Verified: all proofs for this platform are complete, including functional correctness, integrity and infoflow.

## Simulating seL4

Running seL4 in a simulator is a quick way to test it out and iteratively develop software. However,
not that the feature support is limited by the simulator.

* [Running seL4 on VMware](VMware)
* [Running seL4 on Qemu](Qemu)

## x86

We support PC99-style Intel Architecture Platforms.

| Platform              | Arch | Virtualisation | IOMMU | Status     | Contributed by | Maintained by |
| -                     |  -   | -              | -     | -          | -              | -             |
| [PC99 (32-bit)](IA32) | x86  | VT-X           | VT-D  | Unverified | Data61         | Data61        |
| [PC99 (64-bit)](IA32) | x64  | VT-X           | VT-D  | Pending    | Data61         | Data61        |

## ARM

seL4 has support for select ARMv6, ARMv7 and ARMv8 Platforms.

* [General info on ARM Platforms](GeneralARM)

| Platform                                      | System-on-chip            | Core             | Arch  | Virtualisation | IOMMU              | Status     | Contributed by | Maintained by |
| -                                             | -                         | -                | -     | -              | -                  | -          | -              | -             |
| [KZM](Kzm)                                    | i.MX31                    | ARM11            | v6    | No             | No                 | Unverified | Data61         | Data61        |
| [Arndale](arndale)                            | Exynos5                   | A15              | v7A   | ARM HYP        | No                 | Unverified | Data61         | No            |
| [BeagleBoard](BeagleBoard)                    | OMAP3                     | A8               | v7A   | No             | No                 | Unverified | Data61         | Data61        |
| [Beaglebone Black](Beaglebone)                | AM335x                    | A8               | v7A   | No             | No                 | Unverified | external       | Data61        |
| [Inforce IFC6410](IF6410)                     | Snapdragon S4 Pro APQ8064 | krait (A15-like) | v7A   | ARM HYP        | -                  | Unverified | Data61         | No            |
| [Jetson TK1 (NVIDIA)](jetsontk1)              | Tegra K1                  | A15              | v7-1A | ARM HYP        | System MMU         | Unverified | Data61         | Data61        |
| [Odroid-X](odroidx)                           | Exynos4412                | A9               | v7A   | No             | No                 | Unverified | Data61         | Data61        |
| [Odroid-XU](OdroidXU)                         | Exynos5                   | A15              | v7A   | ARM HYP        | limited System MMU | Unverified | Data61         | Data61        |
| [Sabre Lite](sabreLite)                       | i.MX6                     | A9               | v7A   | No             | No                 | Verified   | Data61         | Data61        |
| [TK1 SOM (Colorado Engineering)](CEI_TK1_SOM) | Tegra K1                  | A15              | v7-1A | ARM HYP        | System MMU         | FC (without MMU) | Data61         | Data61        |
| Zynq-7000 ZC706 Evaluation Kit                | Zynq 7000                 | A9               | v7A   | No             | No                 | Unverified | Data61         | Data61        |
| Zynq ZCU102 Evaluation Kit                    | Zynq !UltraScale+ MPSoC   | A53              | v8A           | ARM HYP        | System MMU | Unverified | [DornerWorks](http://dornerworks.com/) | Data61        |
| [Jetson TX1 (NVIDIA) ](jetsontx1)             | Tegra X1                  | Quad A57         | v8A, aarch64  | ARM HYP        | System MMU | Unverified | Data61                                 | Data61        |
| [HiKey](HiKey)                                | Kirin 620                 | A53              | v8A, aarch32 & aarch64 | ARM HYP        | -          | Unverified | Data61                                 | Data61        |
| [Raspberry Pi 3-b](Rpi3)                      | BCM2837                   | A53              | v8A aarch64   | ARM HYP        | -          | Unverified | Data61                                 | Data61        |
