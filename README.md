# Commands-collection

## What is this?

Build status: [![Makefile CI](https://github.com/lebao3105/Commands-collection/actions/workflows/nightly.yml/badge.svg)](https://github.com/lebao3105/Commands-collection/actions/workflows/nightly.yml)

A collection of system commands in Objective Pascal, using FreePascal's run-time library (RTL). Tend to be cross-platform.

The universal usage documentation is [here](USAGE.md).

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

All outputs are placed in build/ folder.

Using `fpcmake -w -Tall` will (re)generate a `Makefile` for all supported platforms.

All targets are shown here, although NOT all are meant to be used:

https://www.freepascal.org/docs-html/prog/progse81.html#x296-312000E.2

Also variables set by `fpcmake`:

https://www.freepascal.org/docs-html/prog/progse86.html#x313-329000E.7

There are still some more to use:

* `DEBUG` and `RELEASE` = build variants
* `CREATESMART` = create smartlinked library
* `LINKSMART` = smart linking
* `STRIP` = symbol and stuff stripping
* `VERBOSE` = a little bit more verbose'ing compile output
* `OPTIMIZE` = optimized output (level 2 according to 3.2.2 fpcmake)

## Run

All programs are set to be placed in `build/progs`. Run them from there - many will show help messages for you to know what can it do and what can you pass to the program.

> All non-executable build files (.o, .ppu) are placed in `build/obj_out`.

## TODOs

* Use TCustomApplication class (not all programs will use this) (done)
* Fix indentation (done)
* No crt (it can break outputs) (done)
* And even create an installer? Cool btw
* ~Fix Makefile~ (completed)

## Credits

* @ikelaiah for cli-fp library. Part of it is used and modified.
