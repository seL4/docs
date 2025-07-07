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

{%- if page.simulation_target and page.simulation_only == false %}
# This platform is a simulation target. This script should work to run the
# generated image if you also use -DSIMULATION=1 for init-build above:
{%- endif %}
{%- if page.simulation_target %}
./simulate
{%- endif %}

```

{%- if page.simulation_target and page.simulation_only == false %}
If you plan to use the ./simulate script, please be sure to add the
`-DSIMULATION=1` argument when running cmake.
{%- endif %}

Generated binaries can be found in the `images/` directory.
