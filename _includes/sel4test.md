{% comment %}
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
{% endcomment %}

{% comment %}
This include generates commands for checking out and building sel4test for a particular platorm.
The platform defines what config it uses, and if it specifies a simulation target, then a simulation command will be added.
{% endcomment %}

Checkout the sel4test project using repo as per [seL4Test](/seL4Test)
```bash
repo init -u https://github.com/seL4/sel4test-manifest.git
repo sync
mkdir cbuild
cd cbuild
../init-build.sh -DPLATFORM={{ page.cmake_plat }} {{page.xcompiler_arg}}
# The default cmake wrapper sets up a default configuration for the target platform.
# To change individual settings, run `ccmake .` and change the configuration
# parameters to suit your needs.
ninja

{%- if page.simulation_target %}
# If your target binaries can be executed in an emulator/simulator, and if
# our build system happens to support that target emulator, then this script
# might work for you:
./simulate
{%- endif %}

```

{%- if page.simulation_target %}
If you plan to use the ./simulate script, please be sure to add the
`-DSIMULATION=1` argument when running cmake.
{%- endif %}

Generated binaries can be found in the `images/` directory.
