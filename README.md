## Commands-collection
[![Makefile CI](https://github.com/lebao3105/Commands-collection/actions/workflows/makefile.yml/badge.svg)](https://github.com/lebao3105/Commands-collection/actions/workflows/makefile.yml)

A collection of various system commands in Pascal <br>
This repository has these directories = commands:
* cat                 : Write file content
* dir                 : Show folder content
* calltime            : Print the current system time
* calldate            : Same as calltime, but with date
* echo                : Just print text to screen
* find_content        : Find content in a file (REMOVED)
* getvar              : Print variable (PATH, HOME, etc...)
* mkdir               : Create a directory
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
```
In some projects you will need to pass ```-Fu../rtl```.

Or, use ```make```:
```
make <program name>
```
If you want to clean all your build outputs which are in build/ folder, do:
```
make clean
```
Or build something after cleaning:
```
* *Nix OSes
$ do_clean=yes make <target>
* Windows
> make <target> do_clean=yes
```

To build all programs:
```
make build_all
```

All outputs will be placed in build/ folder.
