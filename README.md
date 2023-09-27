## Commands-collection
Build status: [![Makefile CI](https://github.com/lebao3105/Commands-collection/actions/workflows/makefile.yml/badge.svg)](https://github.com/lebao3105/Commands-collection/actions/workflows/makefile.yml)

A collection of various system commands in Pascal <br>
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
> If you don't use, some projects you will need to pass ```-Fu<source code root>/include``` to fpc.
> To identify what project you need to

If you want to clean all your build outputs which are in build/ folder, do:
```
make clean
```

Or do clean before the build:
```
* bash
$ do_clean=yes make <target>
* Windows
> make <target> do_clean=yes
```

To build all programs:
```
make build_all
```

All outputs will be placed in build/ folder.
