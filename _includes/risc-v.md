{% comment %}
SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
{% endcomment %}

It is recommended to build the toolchain from source.

```sh
git clone https://github.com/riscv/riscv-gnu-toolchain.git
cd riscv-gnu-toolchain
git submodule update --init --recursive
export RISCV=/opt/riscv
./configure --prefix="${RISCV}" --enable-multilib
make linux
```

After it is built, add the `$RISCV/bin` folder to your PATH. The built
toolchain works for both 32-bit and 64-bit.

Alternatively, any pre-built toolchain with `multilib` enabled should work.
