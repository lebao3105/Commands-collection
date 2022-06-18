## Commands-collection
A collection of various system commands in Pascal <br>
This repository has these directory = commands:
* cat                 : Write file content
* cd                  : "Change" to a folder (DECRAPTED)
* cls                 : Clear the screen
* date                : Show and the time & date (DECRAPTED)
* echo                : Just print text to screen
* find_content        : Find content in a file (not working as expected at parsing arguments)
* getvar              : Print variable (PATH, HOME, etc...)
* help                : Show the description of all commands hare, like this file :)
* mkdir               : Create a directory
* move                : Move a file / folder (?).
* printf              : Write something to file (work but not so good)
* pwd                 : Show the current directory 
* rename              : Rename file
* touch               : Create file

## Compiling
To compile the a (any) program, do:
```
cd <command name>
fpc <command name>.pas
```

Make the file executable (*NIX):
```
chmod +x ./<command name>
```

Even more, use ```make```:
```
make <program name>
```

To build all programs. you can use the command below - outputs will be placed in build/ :
```
make build_all
```

Clean: ```make clean```

If the compiler says 'warn not found' or something else similar , you need to specify ```-Fu../rtl/``` option.
