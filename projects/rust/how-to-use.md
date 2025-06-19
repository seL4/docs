---
parent: /projects/rust/

SPDX-License-Identifier: CC-BY-SA-4.0
SPDX-FileCopyrightText: 2020 seL4 Project a Series of LF Projects, LLC.
---

# Rust: How to Use

Using these crates requires a compatible Rust toolchain. See the project's [rust-toolchain.toml](https://github.com/seL4/rust-sel4/blob/main/rust-toolchain.toml) for the particular toolchain version that is used for testing. Note that these crates use nightly-only features, so, if you are using a stable toolchain, you must set the environment variable `RUSTC_BOOTSTRAP=1`.

These crates are not yet hosted on [crates.io](https://crates.io). Use them either as Git or path
Cargo dependencies.

### Environment Variables

Some of these crates depend, at build time, on external components and configuration. In all cases,
information for locating these dependencies is passed to the dependant crates via environment
variables which are interpreted by `build.rs` scripts. Here is a list of environment variables and
the crates which use them:

- `sel4-config` and `sel4-sys`, whose dependants include `sel4`, `sel4-root-task`, `sel4-microkit`,
  and many more, use `$SEL4_INCLUDE_DIRS` (defaulting to `$SEL4_PREFIX/libsel4/include` if
  `$SEL4_PREFIX` is set) which must contain a colon-separated list of include paths for the libsel4
  headers. See the the `sel4` crate's rustdoc for more information.
- `sel4-platform-info`, whose dependants include `sel4-kernel-loader`, uses `$SEL4_PLATFORM_INFO`
  (defaulting to `$SEL4_PREFIX/support/platform_gen.yaml` if `$SEL4_PREFIX` is set) which must
  contain the path of the `platform_gen.yaml` file from the seL4 kernel build system.
- `sel4-kernel-loader` uses `$SEL4_KERNEL` (defaulting to `$SEL4_PREFIX/bin/kernel.elf` if
  `$SEL4_PREFIX` is set) which must contain the path of the seL4 kernel (as an ELF executable).

### Language Runtime Crates

Two language runtime crates, one for root tasks and another for Microkit protection domains, provide runtime elements such as an entrypoint, thread-local storage, panic handling, a stack, and a heap. See their API docs (linked below) for information on how to use them.

- [`sel4-root-task`](./crates/sel4-root-task): A runtime for root tasks that supports thread-local
storage and unwinding, and provides a global allocator.
[rustdoc](https://sel4.github.io/rust-sel4/views/aarch64-root-task/aarch64-sel4/doc/sel4_root_task/index.html)
- [`sel4-microkit`](./crates/sel4-microkit): A runtime for [seL4
Microkit](../microkit) protection domains, including an implementation of
libmicrokit and abstractions for IPC.
[rustdoc](https://sel4.github.io/rust-sel4/views/aarch64-microkit/aarch64-sel4-microkit/doc/sel4_microkit/index.html)

### Choosing a `--target` argument for `rustc` {#target-spec}

`rustc`'s baremetal builtin target triples (e.g. `aarch64-unknown-none`) will suffice, but we provide a collection of [custom target specifications](https://doc.rust-lang.org/beta/rustc/targets/custom.html) that are tuned specifically for use in seL4 userspace, and that cover a range of language runtime configurations. See [the source directory that contains them](https://github.com/seL4/rust-sel4/tree/main/support/targets#readme) for more information.

### Demos

These demos provide concrete examples of how to integrate these crates into a seL4-based project:

- [Simple root task](https://github.com/seL4/rust-root-task-demo)
- [Simple system using the seL4 Microkit](https://github.com/seL4/rust-microkit-demo)
- [HTTP server using the seL4 Microkit](https://github.com/seL4/rust-microkit-http-server-demo)
