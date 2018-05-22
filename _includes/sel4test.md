{% comment %}
This include generates commands for checking out and building sel4test for a particular platorm.
The platform defines what config it uses, and if it specifies a simulation target, then a simulation command will be added.
{% endcomment %}

Checkout the sel4test project using repo as per [seL4Test](/Testing)
```bash
repo init -u https://github.com/seL4/sel4test-manifest.git
repo sync
mkdir cbuild
../init-build -DPLATFORM={{ page.cmake_plat }} [-DAARCH32|-DAARCH64] [-DRELEASE=<0|1>] [-DSIMULATION=<0|1>]
# The default cmake wrapper sets up a default configuration for the target platform.
# To change individual settings, run `ccmake` and change the configuration
# parameters to suit your needs.
ninja
```

Generated binaries can be found in the `images/` directory.