program getvar;
{$mode objFPC}

uses
    Dos, crt, 
    sysutils, color, strutils;

var i : longint;
    n : integer;

begin
  if ParamCount = 0 then begin
    for i := 1 to EnvCount do
        WriteLn(EnvStr(i));
    textgreen('Done ');
    TextColor(LightGray);
    writeln('showing ALL defined variables on the system.');
  end;

  if ParamCount >= 1 then
    for n := 1 to ParamCount do begin
      // what if the user run this program on Linux with USERPROFILE?
      {$IFDEF UNIX}
      if ParamStr(n) = 'USERPROFILE' then
        writeln(GetEnv('HOME'));
      {$ENDIF} 

      if ParamStr(n) = '--help' then
      begin
        writeLn('Use getvar with anything you want to get its value.');
        writeln('If you run this application without any arguments, getvar will');
        writeln('list all available variables.');
        writeln('On UNIX, you can use USERPROFILE variable!');
        writeln('Examples:');
        writeln(ParamStr(0) , ' windir will return C:\Windows on Windows.');
        writeln(ParamStr(0), ' path will return the system''s path.');
      end

      else
        writeln(GetEnv(ParamStr(n)));
    end;
  halt(0);
end.


