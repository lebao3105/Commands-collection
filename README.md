## Commands-collection
Build status: [![Makefile CI](https://github.com/lebao3105/Commands-collection/actions/workflows/makefile.yml/badge.svg)](https://github.com/lebao3105/Commands-collection/actions/workflows/makefile.yml)

A collection of system commands in Pascal, using FreePascal's library.

Can use in normal life, basic stuff. Or better say, this is mostly for education purposes.

This repository has these directories = commands:
* cat                 : Write file content
* dir                 : Show folder content
* calltime            : Print the current system time
* calldate            : Same as calltime, but with date
* echo                : Just print text to screen
* getvar              : Print variable (PATH, HOME, etc...)
* mkdir               : Create a directory
* presskey            : Pascal version of Windows's pause program
* printf              : Write something to file (work but not good as excepted)
* pwd                 : Show the current directory 
* rename              : Rename file
* touch               : Create file

echo and pwd are 2 simplest programs here.

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

> Some projects will ask you to pass ```-Fu<source code root>/include``` to fpc.
> To identify what project you can check [Makefile](Makefile), or the source code of the program where you can look for the included unit in the uses section. The self-made units are placed in [include/](include/).

Or clean before building anything:
```
* bash
$ do_clean=yes make <target>
* Windows
> make <target> do_clean=yes
* Or just do clean, let me do something else first
make clean
```

To build all programs:
```
make all
```

All outputs will be placed in build/ folder.

## TODOs

* Use TCustomApplication class (not all programs will use this)
* [Probably I won't pass it lol] Learn more about OSes and yeah, my own system.pas etc (like a real OS being written in Pascal)
* Fix indentation (done)
* No crt (it can break outputs)
* And even create an installer? Cool btw
* ~Fix Makefile~ (completed)
