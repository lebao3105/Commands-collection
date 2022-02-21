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
* insert              : Insert texts to file (like printf, working on progress)
* mkdir               : Create a directory
* move                : Move a file / folder (?).
* printf              : Write something to file (work but not so good)
* pwd                 : Show the current directory 
* rename              : Rename file
* touch               : Create file

## FAQ + How to use
### I see in some folders have backup, lib directory, *.lpi and .lps file. What are they?
Well, they are related to a Lazarus project - you need to open the direcory as a Lazarus project. Here's how:
* Install [Lazarus](https://lazarus-ide.org). Make sure that Free Pascal is NOT installed in your computer before (uninstall it before install Laz).
* Go to any folder you want to open as a Lazarus project.
* For existing project, open any .lpi/lps file. A prompt will open and says that there is a project exists here and you choose Yes to load the "project".

### Can I install this project to my computer?
At least the answer is: Yes. <br>
There are many ways: Include it to the PATH, or copy the output (file that have .exe or don't have file extension please!) to %PROGRAMFILES% or /usr/bin (NOT RECOMMENDED!), do anything you want.

### Why can't I install the project to /usr/bin or anything else?
Well, the project are the remastered version of ```System commands```, which are installed on /usr/bin or %SYSTEM32%. So if you are place your own files to these directories, you may can REPLACE the original file. So make sure that you have backed up your computer. Reinstall binutils from its website is not recommended.

### Can I open some non-Lazarus project as a Lazarus project or Why there are some folder only have the source code files?
* First, folders that don't have any *.lpi/lps file... and only have <application name>.pas (or also have utils.pas too) are not Lazarus project. You can use FPC to compile and run it from Terminal.
* Second, you can make a non-Laz project into a normal project like others. 
  * Open Laz -> File -> Open -> open your file here -> Select "Make a new project...(something like that)" when prompted.
  * Choose Console application -> Chage the class name to ```main``` , Title(window title) to the current program name.

### Is there a ```Makefile``` for easier to compile?
The answer is: No.<br>
Free Pascal have its own Makefilie type is Makefile.fpc - which will be compiled into a normal Makefile. I tried it, but after create Makefile, I have this arror here:
```
  Line 15xx : Missing separator. Exiting. 
```
I know that you will say: "Well, just remove spaces to tabs." . I also check for this solution, but not work too. <br>
The other reason is there are both normal and non- Lazarus projects here. I made it beacause some program have errors while building by FPC (happends due to some support that only available in Lazarus). Make 2 specific Makefiles are the good idea, but I still have no way.

### How to use
For all commands, the syntax is:
 ```
 <program name> <options if have> <file/dir name/required argument>
 ```
Some commands you can run it without any argument: help, cls, getvar.<br>
Wait, how can I compile these files?<br>
  * For Lazarus project:
     * Open any project you want to start.
     * Use Shift + F9 to build the project. 
     * Dont use Run in Lazarus, open Command Prompt, "cd" to the project direcory, and run the newly-built executable file instead.
  * For non-Laz one:
     * If you have installed Laz before, the FPC (Free Pascal Compiler) is included with Laz. Find it in <lazarus root folder>/fpc.
     * If not, install FPC [here](https://freepascal.org).
     * Because we will compile from Terminal, include the fpc direcory to the PATH first. For example, you installed FPC 3.2.2 x64 in C:\FPC\3.2.2\, include C:\FPC\3.2.2\bin\x86_64_win64\ to the PATH.
     * Re-open cmd if you are opened it before (to apply the new PATH), go to the folder you want, use ``` fpc <programname>.pas ```. If there is error "Unit color not found" (the old utils Unit), add ```-Fu..\rtl\color.pas``` after the command.
     * Some time in *NIX the output is not excutable, use ```chmod +x ./<filename> ``` to make it run easier.


### Which OSes can work on this project?
Commands-collection is available in Windows, and *NIX (including macOS, Linux). BSD wiil work too.
  
### Can I replace the system's commands with these commands?
You can, but this is not recommended, like some other question. However, this should be interesting if you try one time, and report your experience with me!<br>
And there is a way to place the project on your system without to rename the original files:
* Compile all the files, and find the Application/Excutable files (have .exe extenextension in Windows, or don't have any extensions in *NIX).
* Rename all your output to <programname>-new. For example, ```echo``` -> ```echo-new```. Or you can change the originel filename and keep the new one.
* Now move your files into ```%SYSTEM32%``` (Windows) or ```/usr/bin``` (*NIX). You can use a new folder to easier find, but you may need to include it in PATH.
Some programs that you don't need to rename (if there're no any other similar programs with the same name installed):

You may need to rename in other OSes.
```
| Program | OS(es) that have the same program name | Program have same function in other OSes |
|---------|----------------------------------------|------------------------------------------|
| cls     | Windows                                | clear                                    |
| pwd     | All OSes                               |                                          |
| printf  | Unix                                   | echo [text] > filename.txt               |
| touch   | Unix                                   | None                                     |
| echo    | All OSes                               | None                                     |
| date    | All OSes                               | None                                     |
```
  
### Why some commands source code are so simple, like ```echo``` or ```cls```?
I made this commands just to work its basic function: like echo will be print texts to screen (write to file use printf), or cls clear the screen. And, they are also made with Pascal function, some are so simple (for example cls just run clrscr() and done :-).
Yeah, like app1, I have my goal "Just working as expected".<br>
More: many programs are made with parsing arguments, so it may cause some errors here. Find and fix that bug are so important.

### What is the DecodeDate error in the new program ```date```?
DecodeDate tries to decode the date, month and year stored in Date variable, and return them in its own variables. For example, check this program - which is still working after the error in my program:
```
Program Example9;

{ This program demonstrates the DecodeDate function }

Uses sysutils;

Var YY,MM,DD : Word;

Begin
  DecodeDate(Date,YY,MM,DD);
  Writeln (Format ('Today is %d/%d/%d',[dd,mm,yy]));
End.
```
In the example, DecodeDate decodes the year, month and day in YY (year), MM (month), DD (day); then writeln prints them.<br>
What's my error here? While I making the program with arguments like this:
```
// we are in the loop 
if ParamStr(n) = '--show-time' then
  DecodeDate(Date,YY,MM,DD); 
  writeln('The current date is: ', [dd], [mm], [yy]); // this without the format function. However, this doesn't work.
  // do stuff...
```
The debug log:
```
fpc date.pas
Free Pascal Compiler version 3.2.0 [2021/02/21] for x86_64
Copyright (c) 1993-2020 by Florian Klaempfl and others
Target OS: Win64 for x64
Compiling date.pas
date.pas(28,28) Fatal: Syntax error, "." expected but "," found // this DecodeDate line!
Fatal: Compilation aborted
Error: D:\pascal\fpc\3.2.0\bin\x86_64-win64\ppcx64.exe returned an error exitcode
```
I checked the error position in source code, and found its stop in Date variable from the DecodeDate variable.<br>
"." expected but "," found... Hmm, I also checked for begin..end blocks, and is there any other syntax errors, but nothing incorrect...

## Program(s) notes
1. Printf: The "parse arguments" is not fully completed yet. Its hard to say, there are many problems on how the users can work on this program.
2. Touch: Currently we have our new program, but I found that -Fu option is not working here, with both cmd and powershell. This program has been rewritten with new features, such as create file even you are running this app with multi arguments, for example:
```
> touch 9 hello.txt
There are many arguments that we are detected here. Which one you want to create?
Note that --help flag is not available for this application.
Arg no.1 : 9
Arg no.2 : hello.txt
Enter your answer here (all to use all args): <-- I use writeln here, fixed
all
All your required file has been created.
> touch helloworld.pas
File helloworld.pas has been created.
```
What I want here:
  * Allow user to create multi files at one time using array of integer (before edit this file I want to use the string one) or using a flag. 

3. echo: Line-breaking (like \n in original echo in Linux or in printf from C++) is not supported. I tried it many times, but there are problems with argument-parsing.