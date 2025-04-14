# Commands-collection

## What is this?

Build status: [![Makefile CI](https://github.com/lebao3105/Commands-collection/actions/workflows/makefile.yml/badge.svg)](https://github.com/lebao3105/Commands-collection/actions/workflows/makefile.yml)

A collection of system commands in (Objective) Pascal, using FreePascal's library. Tend to be cross-platform.

All programs have their own document in `docs/`.

Most programs here have `-h` and `--help` for their usage help.

These are NOT meant to replace system utilities because of missing features and being too simple. There are better tools outside.

## Compiling

To compile a/any program, do:

```bash
$ make src/<program name>
```

Append `.exe` if you're on Windows.

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

## Run

All programs are set to be placed in `build/progs`. Run them from there - many will show help messages for you to know what can it do and what can you pass to the program.

> All non-executable build files (.o, .ppu) are placed in `build/obj_out`.

You can't combine short flags, like this:

* `-la` is wrong;
* but `-l -a` works.

This is due to TCustomApplication API used for parsing command-line arguments.

Tell me if this is fixed or has a fix on my side.

Also long flags (ones with 2 dashes: `--`) that needs a value must be followed by a `=` like this:

```
--format=dddd
```

Short flags (ones with one dash: `-`) do not need to:

```
-f dddd
```

## TODOs

* Use TCustomApplication class (not all programs will use this) (done)\
* Fix indentation (done)
* No crt (it can break outputs) (done)
* And even create an installer? Cool btw
* ~Fix Makefile~ (completed)

## Credits

* @ikelaiah for cli-fp library. Part of it is used and modified.