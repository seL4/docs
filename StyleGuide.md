---
toc: true
---

# C Coding Conventions and Style Guide

These are conventions which we attempt to follow in all of our code.
They do not apply to external libraries, where we stick with the
existing conventions.

Much of our code pre-dates the conventions, so it may not all comply.
However, please try to ensure that any new code does follow the rules.
In general, we strive to abide by Robert Baden-Powell's rule for
scouting: "Try and leave [the code] a little better than you found it."

This guide is in three parts: first, we list general coding conventions;
then we divide the rest of the conventions between kernel and
user-level.  Please read the appropriate guide, as kernel and user-level
conventions sometimes contradict each other.

## General C code

This guide applies to general C code at user-level.  For developing the
seL4 kernel and other verified code, please refer to the verification
requirements below, which override the general conventions.

* Code should compile without warnings, with `-Wall`.

### Automatic formatting

For automatic formatting of C code, we use
[astyle](http://astyle.sourceforge.net/), version 2.05.1, with the
settings declared in our
[astylerc](https://github.com/seL4/seL4_tools/blob/master/misc/astylerc).

### Spacing and braces

* Indent using four (4) spaces.  Do not use tabs for indentation at all.
* Use no space between `*` and the variable name in pointer
  expressions (`int *foo`).
* Use space between keywords and parentheses; e.g., `if (condition)`.
* Put the opening brace of a function implementation on the line _after_
  the function's return type, name, and argument list.
  ```c
  int atoi(const char *nptr)
  {
      /* ... */
  }
  ```
* Use the "one true brace style" (1TBS); use braces everywhere the
  syntax allows (including single-statement scopes).
  ```c
  if (x == FOO) {
      do_something();
  } else if (y == BAR) {
      do_something_else();
  } else {
      do_last_else();
  }
  ```
* When a function argument list gets too long for one line, indent the
  remaining arguments on the next line just inboard of the parenthesis
  on the line above.  For example:
  ```c
  void myfunc(my_ridiculously_long_type_t foo,
              my_ridiculously_long_type_t bar)
  {
      /* ... */
  }
  ```

### Choosing data types

* When using integral types (`char`, `int`, `long`, etc.), qualify them
  explicitly as `unsigned` except where negative values are meaningful
  and must be handled.  (Overflow of signed integral types is undefined
  in the C standard.)

### Naming of symbols (variables), types, and type aliases (`typedef`)

* Use `typedef` to create aliases for all `struct` types.
* The names of type aliases should always end in `_t`.
* Function pointer type aliases should always end in `_fn_t`.
* Do not alias pointer types with `typedef`; we keep them explicit.
  ```c
  typedef tick_count unsigned int;

  typedef tick_count_ptr_t *tick_count; /* NO */
  tick_count *tick_count_ptr; /* yes */
  ```
* Use `snake_case` to name a multi-word variable or type.
* Non-`static` functions should be prefixed with appropriate names to
  avoid polluting the namespace.
    * The convention in library code is to use the name of the library.
    * A good guide for application code is to use the filename.
* Name Boolean variables with a verb phrase including a verb like `is_`,
  `has_`, or `want_` so that the intent of the variable is clear in
  expressions and conditionals.
* Avoid magic numbers; define meaningful constants.  Prefer C language
  symbols over preprocessor symbols, because the former are visible in a
  symbolic debugger like `gdb`.
* Use `SCREAMING_SNAKE_CASE` for, and _only_ for, preprocessor symbols
  and values of enumeration type.
* Prefix architecture-specific code with `arch_`, platform-specific
  code with `plat_`, and mode-specific code with `mode_`.

### Expressions

* Avoid pointer arithmetic unless necessary.
* Always use preprocessor macros for bit manipulation (e.g., use
  `BIT(7)` instead of `1 << 7`).

### Structure

* Put architecture- and platform-specific code in dedicated directories.
* Only `static inline` functions are permitted in header files, and then
  only for performance.
* Variables at file scope must be marked as `static`.
* Use public/private header files; avoid `extern` unless necessary.
* General-purpose utility functions belong in shared libraries, not
  library-specific files, and vice versa.  (Consider checking `libutils`
  in the `util_libs` Git repository for existing functionality, and
  consider making useful additions there.)
* Prefer `static inline` functions over preprocessor macros unless
  preprocessor features are required or the macro is simple.
* Put a comment after the `#endif` of an `#if`, `#ifdef`, or `#ifndef`
  blocks that refers to the preprocessor symbol(s) upon which the code
  is guarded.
```c
  #ifdef CONFIG_BLAH
  /* ... */
  #endif /* CONFIG_BLAH */
```

### Memory allocation

* For memory that should be zeroed, use `calloc` rather than `malloc`
  followed by `memset` or `bzero`.

### Commenting

* Prefer `/* this style */` comments over `// this style`.
* Use Javadoc-style comments on function prototypes in headers.
* Document function parameters and return types, at minimum.

## User-level code

### Type conventions

Be aware that our code needs to be portable across 32- and 64-bit
platforms.

* Use `seL4_Word` for word-sized things.
* Use `void *` for untyped addresses.
* Use `uintptr_t` for pointer arithmetic.
    * ...but avoid pointer arithmetic unless necessary.
* Use `size_t` for sizes of objects (including pointers themselves).
* Use `unsigned int` for values known to be small.
* Use fixed-width types only when necessary, e.g., in device drivers.
* Use `long` variants of built-in functions (`CLZL`) for 64-bit
  compatibility, unless operating on a fixed-width type.
* Use `typedef` to create aliases for all `enum` types.

### Format strings

* Use 64-bit-friendly printing macros for `printf` (e.g., `PRIi32` for
  `uint32_t`).
* Use `%p` for pointers.
* Use `%zd` and `%zu` for `ssize_t` and `size_t` respectively.

### Header guards

* Use `#pragma once` in header files to avoid duplicated includes.

### Error handling

* Always check error codes.
* Use `assert` only to test invariants in code.
* Use `ZF_LOGF` for fatal errors: it will call `abort()`.
* For all other error reporting, use the appropriate `ZF_LOG` level.
* Use only `ZF_LOG` macros for diagnostic messages--not `printf`.
* Try to follow a transactional approach to error handling: check input
  and report errors before modifying state.

## Kernel code

* Use `word_t` for word-sized things.
* Do not explicitly typecast between pointers and references (i.e.,
  integers used as, e.g., offsets into structures): use object-specific
  macros for this purpose, such as `TCB_REF` and `TCB_PTR`.

### Format strings

The in-kernel `printf` implementation is limited.

* Use `%p` for pointers.
* Use `%lu` for words, and cast to avoid warnings.

### Header guards

* Do not use `#pragma once`; use header guards.

### Error handling

* Within seL4, the `decode` stage must only check conditions; the
  `invoke` stage can alter state.

### Verification requirements

Verified code (such as that in the seL4 kernel) must follow these
requirements.  Note that the verified code requirements override
anything in the general guide.

* Follow the
  [C99](http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf)
  standard.  (The link is to the final draft before ratification; the
  official standard document cannot be distributed freely.)
* Avoid taking the address of a variable of automatic storage class.
  (In most C implementations, this means stack-allocated locals.)
* Do not use floating-point types, e.g., `double` or `float`.
* Do not use `restrict`.
* `union` types cannot be used; use the bitfield generator instead.
* Do not preincrement or predecrement variables (`++x`, `--y`).
* Do not use variable names that duplicate `typedef` type aliases:
  ```c
  typedef int A;
  A A;
  ```
* Do not use fall-through cases in `switch` statements.
* Do not use variadic argument lists.
* Declare functions that take no arguments as taking a `void` argument.
* References to linker addresses must be via `extern char[]` declarations
  rather than declarations of other types (such as `extern char` or
  `extern void *`).
* Do not pass arrays as arguments to functions expecting pointers.
  ```c
  void foo(int *some_pointer);
  int my_array[10];
  foo(my_array);
  ```
* Do not declare local variables as `static`.
* Prefix `struct` fields with the name of the `struct` to avoid
  namespace conflicts in the proof.  (Much existing kernel code does not
  follow this directive; new code should adopt the recommended practice
  to avoid namespace collisions in proofs.)
* Do not use `typedef` to create a type alias for an `enum`; always
  specify `enum` types as `word_t` (otherwise, the `enum` size is
  determined by the compiler).

## Further resources

* [What is the difference between K&R and One True Brace Style (1TBS) styles?](https://softwareengineering.stackexchange.com/questions/99543/what-is-the-difference-between-kr-and-one-true-brace-style-1tbs-styles)
* [Linux kernel coding style](https://www.kernel.org/doc/Documentation/process/coding-style.rst)
* [How to C in 2016](http://matt.sh/howto-c)
* [Google C++ Style Guide: 64-bit Portability](https://google.github.io/styleguide/cppguide.html#64-bit_Portability)
* [Google C++ Style Guide: Integer Types](https://google.github.io/styleguide/cppguide.html#Integer_Types)
* [Baden-Powell quotation](https://www.brainyquote.com/quotes/robert_badenpowell_753084)
