program help;
var n:integer;
begin
  writeln('The "cmd" collection.');
  writeln('Version 1.0 by Le Bao Nguyen.');
  writeln('Here is the list of available programs:');
  writeln('cat                : See files content');
  writeln('cd                 : Change the current directory to other (Not working yet)');
  writeln('cls                : Clear the scren');
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
  for n := 1 to ParamCount do begin
    if ParamStr(n) = 'mkdir' then 
        writeln('mkdir Syntax:');
        writeln('mkdir [folder name] : Create [folder name] directory.');
        exit;
    if ParamStr(n) = 'cls' then 
        writeln('Just use cls to clear the screen, no other arguments needed.');
        exit;
    if ParamStr(n) = 'pwd' then
        writeln('Use pwd to show the current folder path. For example, if you are in C:\, pwd will give the');
        writeln('output C:\');
        exit;
    if ParamStr(n) = 'touch' then
        writeln('touch Syntax:');
        writeln('touch [filename] : Create file [filename].');
        exit;
  end;
end.

