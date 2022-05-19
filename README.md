## Commands-collection
A collection of various system commands in Pascal <br>
This repository has these directory = commands:
* cat                 : Write file content
* cd                  : "Change" to a folder (DECRAPTED)
* cls                 : Clear the screen
* date                : Show and the time & date (something went wrong... here)
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
To compile the projectany program, use:
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
make <program name> / build_all / clean
```

If the compiler says 'warn not found' or something else similar , you need to specify ```-Fu../rtl/``` option.

## What to know
* You should not install this project to your computer - replace original commands. Not of all commands are working as expected.
* You can use this project to learn Pascal, but not to learn C/C++.
* Why ```cd``` command is DECRAPTED? Because function used to change the directory - both ```ChDir()``` and ```SetCurrentDir()``` - are not working. They are used to change the directory ONLY in the current process - I mean the program which is running the function.



> **Useful tips:** If you want to use this project more than once, you can add build/progs folder to the PATH. Run ```make build_all``` (if not already done) then modify ~/.bashrc (Bash) or add the folder to PATH in Environment Variables (Windows). But not all programs are valid to use on your system. Rename some programs here:

* echo 
* cat
* cls (only on Windows
* mkdir 
* pwd (if you want, only on *NIX)
* rm (only on *NIX)
* touch (only on *NIX)

Note that if you use MSYS/MinGW and add it to PATH on Windows, rename all needed programs.