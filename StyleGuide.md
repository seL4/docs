---
toc: true
---

# C Coding Conventions

These are conventions which we attempt to follow in all of our code. They do not apply to external
libraries, where we stick with the existing conventions.

Much of our code pre-dates the conventions, so it may not all comply. However, please try to ensure
that any new code does follow the rules. In general, we strive to abide by the scout rule:
"Try and leave the code a little better than you found it"

This guide is in three parts: first, we list general coding conventions, then we divide the rest of
the conventions between kernel and user-level. Please read the appropriate guide, as often kernel
and user-level conventions contradict each other.

## General C code

This guide applies to general C code at user-level. For developing seL4 kernel and other verified
code, please refer to the verification requirements below, which override the general conventions.

* Code should compile without warnings, with `-Wall`.

### Automatic formatting

For automatic formatting of c code, we use the [astyle](http://astyle.sourceforge.net/), version 2.05.1, with the following settings:

```
max-instatement-indent=120
style=otbs
pad-header
indent=spaces=4
pad-oper
```

### Spacing and braces

* 4 space indent, no tabs
* No space between * and variable name for pointers (`int *foo`)
* Space between keywords and parentheses
* Function prototypes should be all on the same line
* We use "the one true brace style" (OTBS)
    * always brace everything (including single scope statments)
```c
if (x == FOO) {
    do_something();
} else if (y == BAR) {
    do_something_else();
} else {
    do_last_else();
}
```

### Naming

* typedefs should always end in `_t`.
* Never typedef a pointer, we keep them explicit.
* We use `under_scores` for separate words in a variable name.
* Avoid pointer arithmetic unless neccessary.
* Non-static functions should be prefixed with appropriate names to avoid polluting the namespace:
    * the convention in library code is to use the name of the library,
    * a good guide for application code is to use the filename.
* Boolean types should be a verb (e.g `is_alive`).
* Avoid magic numbers, define meaningful constants.
* Constants and macros should be in upper case.
* Typedef structs and enums.
* Prefix arch specific code with `arch_` and platform specific code with `plat_`.

### Structure

* Architecture and platform specific code belongs in dedicated directories.
* Only `static inline` functions are permitted in header files, and then only for performance.
* File local global variables must be marked as `static`.
* Use public/private header files, avoid `extern` unless neccessary.
* General purpose utiliy functions belong in shared libraries, not library specific files, and
  vice-versa.
* Prefer `static inline` functions over preprocessor macros if the macro is even remotely complex,
  and preprocessor features are not required.
* `#ifdef` blocks should always be commented at the end, e.g.:
```c
#ifndef CONFIG_BLAH
...
#endif /* CONFIG_BLAH */
```
* Always use defined macros for bit-manipulation (e.g `BIT(7)` over `1 << 7`).

### Memory allocation

* For memory that should be zeroed, use `calloc` rather than `malloc` + `bzero`.

### Commenting

* Prefer `/* this style */` comments over `// this style`.
* Use javadoc style comments on function prototypes in headers.
* Document function return types and parameters, at minimum.

## User-level code

### Type conventions

Be aware that our code needs to be portable across 32- and 64-bit platforms.

* Use `void *` for untyped addresses.
* Use `uintptr_t` for pointer arithmetic.
    + but avoid pointer arithmetic unless neccessary.
* Use `intptr_t` or `uintptr_t` for sizes of pointers
* Use `size_t` for sizes of objects.
* Use `int` for values known to be small.
* Only use fixed-width types when neccessary, e.g. drivers.
* Only use signed types when neccessary.
* Use long variants of builtin functions (`CLZL`) for 64-bit compatability, unless operating on a
  fixed-width type.

### Format strings

* Use 64-bit friendly printing macros for printf (e.g. `PRIi32` for `uin32_t`).
* Use `%p` for pointers.
* Use `%zd` and `%zu` for `ssize_t` and `size_t` respectively.

### Header Guards

* Use `#pragma once` in header files to avoid duplicated includes.

### Error handling

* Always check error codes.
* `assert` should only be used for testing invariants in code.
* Use `ZF_LOGF` for fatal errors: it will call `abort()`.
* For all other error reporting, use the appropriate `ZF_LOG` level.
* Only use `printf` for general application output.
* Try to follow a transactional approach to error handling: check input and report errors before
  modifying state.

## Kernel code

* Use `word_t` for word-sized things.
* Do not explicity type cast between pointers and references: use object specific macros for this
  purpose, e.g. `TCB_REF` and `TCB_PTR`.

### Format strings

The in-kernel `printf` implementation is limited.

* Use `%p` for pointers.
* Use `%lu` for words, and cast to avoid warnings.

### Header Guards

* Do not use `#pragma once`, use header guards.

### Error handling

* Within seL4, the `decode` stage must only check conditions, the `invoke` stage can alter state.

### Verification requirements

Verified code (such as that in the seL4 kernel) must follow these requimrents. Note that when
the verified code requirements override anything in the general guide.

* Follow the [C99](http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf) standard.
* Avoid taking the address of a local variables.
* No floating point types, e.g. `double` or `float`.
* `restrict` cannot be used.
* `unions` cannot be used, use the bitfield generator instead.
* No preincrement (`++x`)
* No variables that alias typedefs:
```c
typedef int A;
A A;
```
* No self-modifying code (e.g. no jump tables).
* No fall-through cases in `switch` statements.
* No use of `varargs`.
* Must provide `void` in function definitions without arguments.
* References to linker addresses must be sized arrays (e.g. `extern char xxx[]`)
* No function calls that decay arrays to pointers:
```c
void foo(int *some_pointer);
int my_array[10];
foo(my_array);
```
* No static local variables.
* No unneccesary signed variables.
* Prefix struct fields with the name of the struct, to avoid namespace conflicts in the proof.

## Further resources

* [Linux coding conventions](http://www.kernel.org/doc/Documentation/CodingStyle)
* [A modern guide to C style](http://matt.sh/howto-c)
* [64-bit portability](https://google.github.io/styleguide/cppguide.html#64-bit_Portability)
* [Intger types](https://google.github.io/styleguide/cppguide.html#Integer_Types)

