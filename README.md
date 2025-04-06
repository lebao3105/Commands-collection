# Commands-collection

## What is this?

Build status: [![Makefile CI](https://github.com/lebao3105/Commands-collection/actions/workflows/makefile.yml/badge.svg)](https://github.com/lebao3105/Commands-collection/actions/workflows/makefile.yml)

A collection of system commands in (Objective) Pascal, using FreePascal's library. Tend to be cross-platform.

This repository has these directories = commands:
* cat                 : Write file content
* dir                 : Show folder content
* calltime            : Print the current system time & date
* getvar              : Print variable (PATH, HOME, etc...)
* mkdir               : Create a directory
* presskey            : Pascal version of Windows's pause program
* printf              : Write something to file (work but not good as excepted)
* rename              : Rename file
* touch               : Create file

Most programs here have `-h` and `--help` for their usage help.

These are NOT meant to replace system utilities. There are better tools outside.

## Compiling

To compile a/any program, do:

```bash
$ make -C src <program name>.pas
```

To build everything:

```bash
$ make all
```

To clean everything:

```bash
$ make clean
```

To clean before building the project without running the clean command above: set `DO_CLEAN` environment variable to 1, then build as usual.

All outputs will be placed in build/ folder.

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

* Use TCustomApplication class (not all programs will use this)
* [Probably I won't pass it lol] Learn more about OSes and yeah, my own system.pas etc (like a real OS being written in Pascal)
* Fix indentation (done)
* No crt (it can break outputs)
* And even create an installer? Cool btw
* ~Fix Makefile~ (completed)

## Credits

* @ikelaiah for cli-fp library. Part of it is used and modified.