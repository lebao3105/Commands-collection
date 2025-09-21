# Commands-collection

Build status: [![Makefile CI](https://github.com/lebao3105/Commands-collection/actions/workflows/nightly.yml/badge.svg)](https://github.com/lebao3105/Commands-collection/actions/workflows/nightly.yml)

## What is this?

A collection of system commands written in Free Pascal.

They are:

* `calltime` = time & date getter
* `cat`
* `chk_type` = file / folder information getter
* `dir`
* `env`
* `inp` = asks for an input (e.g Press Enter to continue)
* `mkdir` + `touch` + `rm`
* `rename` = file / folder renamer
* `uname`

While some do tend to be compatible with GNU coreutils (like `uname`), many are not.

I personally *do not* intend to make this 100% coreutils-compatible, but cross-platform.

## Compiling

To compile a/any program, do:

```bash
$ make src/<program name>
```

Append `.exe` if you're on Windows (optional).

To build everything:

```bash
$ make
```

To clean everything:

```bash
$ make clean
```

Using `fpcmake -w -Tall` will (re)generate a `Makefile` for all supported platforms.

All targets are shown [here](https://www.freepascal.org/docs-html/prog/progse81.html#x296-312000E.2), although NOT all are meant to be used.

Also variables set by `fpcmake` [here](https://www.freepascal.org/docs-html/prog/progse86.html#x313-329000E.7).

There are still some more to use:

* `DEBUG` and `RELEASE` = build variants
* `CREATESMART` = create smartlinked library
* `LINKSMART` = smart linking
* `STRIP` = symbol and stuff stripping
* `VERBOSE` = a little bit more verbose'ing compile output
* `OPTIMIZE` = optimized output (level 2 according to 3.2.2 fpcmake)

## Run

All programs are set to be placed in `build/progs`.

> All non-executable build files (.o, .ppu) are placed in `build/obj_out`.

The universal usage documentation is [here](USAGE.md).

## Credits

* [@ikelaiah](https://github.com/ikelaiah) for cli-fp library. Part of it is used and modified.
