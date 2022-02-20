program help;
var n:integer;
begin
  writeln('The "cmd" collection.');
  writeln('Version 1.0 by Le Bao Nguyen.');
  writeln('Here is the list of available programs:');
  writeln('cat                : See files content');
  writeln('cd                 : Change the current directory to other (Not working yet)');
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
  writeln('All programs are released under the GNU Gerenal Public License V3');
  writeln('Upcomming program(s):');
  writeln('1. file_date       : Find what time is your file created;');
  writeln('2. file_size       : Print the file size;');
  writeln('3. dir             : Show folder content');
  writeln('4. rm              : Remove file/folder');
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
    else if ParamStr(n) = 'cd' then begin
        writeln('cd Syntax:');
        writeln('cd [directory] : Change the current directory to the other'); 
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
    end;
  end;
end.

