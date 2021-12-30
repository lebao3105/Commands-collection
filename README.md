# Commands-collection
A collection of various system commands in Pascal <br>
This repository has these directory = commands:
* cat                 : Write file content
* cd                  : "Change" to a folder (not working now due to...)
* cls                 : Clear the screen
* echo                : Just print text to screen.
* getvar              : Print variable (PATH, HOME, etc...)
* help                : Show the description of all commands hare, like this file :)
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
  * Open Laz -> File -> Open -> open your file here -> Select "Make a new project..." when prompted.
  * Choose Console application -> Chage TMainApp to ```main``` , TAppName to the current program name.

### Is there a ```Makefile``` for easier to compile?
The answer is: No.<br>
Free Pascal have its own Makefilie type is Makefile.fpc - which will be compiled into a normal Makefile. I tried it, but after create Makefile, I have this arror here:
```
  Line 15xx : Missing separator. Exiting. 
```
I know that you will say: "Well, just remove spaces to tabs." . I also check for this solution, but not work too. <br>
The other reason is there are both normal and non- Lazarus projects here. I made it beacause some program have errors while building by FPC (happends due to some support that only available in Lazarus). Make 2 specific Makefiles are the good idea, but I still have no way.
