## Commands-collection
A collection of various system commands in Pascal <br>
This repository has these directories = commands:
* cat                 : Write file content
* cls                 : Clear the screen
* dir                 : Show folder content
* echo                : Just print text to screen
* find_content        : Find content in a file (REMOVED)
* getvar              : Print variable (PATH, HOME, etc...)
* help                : Show the description of all commands hare, like this file - but it's removed too
* mkdir               : Create a directory
* move                : Move a file / folder (?).
* printf              : Write something to file (work but not good as excepted)
* pwd                 : Show the current directory 
* rename              : Rename file
* touch               : Create file
* rmdir               : Remove folder - but I have compile problem on RMDir function

echo, cls and pwd are 3 simplest programs.

## Compiling
To compile a/any program, do:
```
cd <command name>
fpc <command name>.pas
```

Or, use ```make```:
```
make <program name>
```

To build all programs. you can use the command below - outputs will be placed in build/ :
```
make build_all
```

Clean: ```make clean```

If the compiler says 'warn not found' or something else similar , you need to specify ```-Fu../rtl/``` option.
