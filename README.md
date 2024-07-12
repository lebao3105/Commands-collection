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

## Compiling

To compile a/any program, do:

```
cd <command name>
fpc <command name>.pas
# or
fpc <command name>/<command name>.pas
# with make
make <command name>
```

> Some projects will require you to pass ```-Fuinclude``` to fpc.
> To identify what project you can check [Makefile](Makefile), or the source code of the program where you can look for included units in the `uses` section.

You can remove all previous build outputs by removing `build/`, or `make clean`. Setting `DO_CLEAN` to 1 before going to build anything with `make` will clean for you.

To build all programs:
```
make all
```

All outputs will be placed in build/ folder.

## Run

All programs are set to be placed in `build/progs`. Run them from there... many will show help messages for you to know what can it do.

> All non-executable build files (.o, .ppu) are placed in `build/obj_out`.

You can't combine short flags, like this:

* `-la` is wrong;
* but `-l -a` works.

This is due to TCustomApplication API used for parsing command-line arguments.

Tell me if this is fixed or has a fix on my side.

Do NOT use them over system programs - they are not made for that. Use in caution just like any other tools, whatever system ones or not.

## TODOs

* Use TCustomApplication class (not all programs will use this)
* [Probably I won't pass it lol] Learn more about OSes and yeah, my own system.pas etc (like a real OS being written in Pascal)
* Fix indentation (done)
* No crt (it can break outputs)
* And even create an installer? Cool btw
* ~Fix Makefile~ (completed)
