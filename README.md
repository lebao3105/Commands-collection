## Commands-collection
A collection of various system commands in Pascal <br>
This repository has these directory = commands:
* cat                 : Write file content
* cd                  : "Change" to a folder (not working now due to...)
* cls                 : Clear the screen
* date                : Show and the time & date (error found!)
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

Some program should be here now:
* rm : Remove file
* get file date/time : Get file created date/time
And more...

## Compiling
To compile the project, use:
```
cd <command name>
fpc <command name>.pas
```

Make the file executable (*NIX):
```
chmod +x <command name>
```

If the compiler says 'warn not found', you need to specify ```-Fu../rtl/``` option. Make sure you have included fpc path (points to fpc.exe program) in the PATH.

## What to know
* You should not install this project to your computer - replace original commands. Not of all commands are working as expected.
* You can use this project to learn Pascal, but not to learn C/C++.
* This is easier if we have a ```makefile``` here, but you can switch between directories and compile:
```
cd <command name>
fpc <command name>.pas -Fu../rtl
# When needed, go to other dir(s)
cd ..\<other dir> & fpc <command name>.pas -Fu../rtl # Windows
cd ../<other dir> & fpc <command name>.pas -Fu../rtl # *NIX
```

And add it to PATH (if needed):
```
cd .. # To project root folder
mkdir bin # Make a folder

# Windows - copy .exe files
cp */*.exe bin/ 

# *NIX - the binary is the file which don't have a file extension
cp */{echo,cat,cls,date,getvar,help,insert,mkdir,move,pwd,rename,touch} bin/

# Set the PATH (temporary)
set PATH=%PATH%;<path to .exe file> # Windows
export PATH=$PATH:<path to .exe file> # *NIX

# Set the PATH permanently (*NIX with bash)
echo 'export PATH=$PATH:<path to bin>' >> ~/.bashrc
source ~/.bashrc

# Windows
Open windows search -> type and search for env -> Launch first search result -> Environment Variables -> User/System PATH -> Add -> Browse -> Head to the bin folder -> OK to apply. Reopen any Command window to get the changes. 
```

But not at all commands are vaid to use. Rename some programs here:
* echo 
* cat
* cls (*NIX)
* mkdir 
* date (but we can't use it now:))
* cd
* pwd (if you want, only for *NIX)
* rm
* touch (*NIX)