{% comment %}
This include generates commands for checking out and building sel4test for a particular platorm.
The platform defines what config it uses, and if it specifies a simulation target, then a simulation command will be added.
{% endcomment %}

Checkout the sel4test project using repo as per [seL4Test](/Testing)
~~~bash
repo init -u https://github.com/seL4/sel4test-manifest.git
repo sync
make {{ page.defconfig }}
# The defconfig provides a set build configuration. You can use `make menuconfig` to customize build settings further if necessary.
make
{%- if page.simulation_target %}
make {{ page.simulation_target }}
{%- endif %}
~~~

Generated binaries can be found in the `images/` directory.