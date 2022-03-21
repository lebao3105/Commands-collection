program help;
var n:integer;
begin
  writeln('The "cmd" collection.');
  writeln('Version 1.0 by Le Bao Nguyen.');
  writeln('Here is the list of available programs:');
  writeln('cat                : See files content');
  writeln('cd                 : Change the current directory to other (Decrapted)');
  writeln('cls                : Clear the scren');
  writeln('chk_type           : Check the file type (other similiar features with this program will be merged into a program.');
  writeln('echo               : Prints text to screen');
  writeln('find_content       : Search for something in a file');
  writeln('getvar             : Prints the variable(s)');
  writeln('help               : Show this box and exit');
  writeln('mkdir              : Create a directory');
  writeln('move               : Move a file or folder(?)');
  writeln('printf             : Write text to a file');
  writeln('pwd                : Show the current directory');
  writeln('rename             : Rename a file');
  writeln('touch              : Creates a file.');
  writeln('rm/rmdir           : Remove a file or folder');
  writeln('This project is released under the GNU Gerenal Public License');
  writeln('Upcomming program(s):');
  writeln('1. file_date       : Find what time is your file created;');
  writeln('2. file_size       : Print the file size;');
  writeln('3. dir             : Show folder content');
  for n := 1 to ParamCount do begin
    if ParamStr(n) = 'mkdir' then begin
        writeln('mkdir Syntax:');
        writeln('mkdir [folder name] : Create [folder name] directory.');
        exit; end
    else if ParamStr(n) = 'cls' then begin 
        writeln('Just use cls to clear the screen, no other arguments needed.');
        exit; end
    else if ParamStr(n) = 'pwd' then begin
        writeln('Use pwd to show the current folder path. For example, if you are in C:\, pwd will give the');
        writeln('output C:\');
        exit; end
    else if ParamStr(n) = 'touch' then begin
        writeln('touch Syntax:');
        writeln('touch [filename] : Create file [filename].');
        exit; end
    else if ParamStr(n) = 'getvar' then begin
        writeln('getvar Syntax:');
        writeln('getvar [var] : Get the value of variable [var]');
        exit; end
    else if ParamStr(n) = 'move' then begin
        writeln('move Syntax:');
        writeln('move [original file name] [new file name] : Change the old file name to the new one.');
        exit; end
    else if ParamStr(n) = 'find_content' then begin
        writeln('find_content Syntax:');
        writeln('find_content [text1] [text2] --target [file name] : Find text1/2/... in filename');
        exit; end
    else if ParamStr(n) = 'printf' then begin
        writeln('printf Syntax: ');
        writeln('printf [text] --target [file name] : Writes [text] to [file name]');
        exit;
    end
    else if ParamStr(n) = 'echo' then begin
        writeln('echo Syntax: ');
        writeln('echo [text] : Writes [text] to the screen. Currently we dont support something to break the line like \n.');
        writeln('If you want to print a variables value, use getvar. For print texts to file use printf instead.');
        exit;
    end
    else if ParamStr(n) = 'chk_type' then begin
        writeln('chk_type Syntax: ');
        writeln('chk_type [file name] : Check the file type of [file name]');
    end
    else if ParamStr(n) = 'cat' then begin
        writeln('cat Syntax: ');
        writeln('cat <filename> <-v/--verbose> : Prints the content of [file name]');
    end;
    else if ParamStr(n) = 'rename' then begin
        writeln('rename Syntax: ');
        writeln('rename [old file name] [new file name] : Rename [old file name] to [new file name]');
    end;
    else if ParamStr(n) = 'rmdir' then begin
        writeln('rmdir Syntax: ');
        writeln('rmdir [folder name] : Remove folder name');
    end;
    else if ParamStr(n) = 'dir' then begin
        writeln('dir Syntax: ');
        writeln('dir [folder name] : Show the content of [folder name]');
    end;
    else if ParamStr(n) = 'rm' then begin
        writeln('rm Syntax: ');
        writeln('rm [file name] : Remove [file name]');
    end;
    else if ParamStr(n) = 'file_date' then begin
        writeln('file_date Syntax: ');
        writeln('file_date [file name] : Print the date of [file name]');
    end;
    else if ParamStr(n) = 'file_size' then begin
        writeln('file_size Syntax: ');
        writeln('file_size [file name] : Print the size of [file name]');
    end;
    else if ParamStr(n) = 'help' then begin
        writeln('help Syntax: ');
        writeln('help : Show this box and exit');
    end;
  end;
end.

