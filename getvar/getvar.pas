program getvar;
{$mode objFPC}

uses
    Dos, crt, 
    sysutils, color;

var i : longint;
    n : integer;

begin
  if ParamCount = 0 then  
      for i:=1 to EnvCount do
        WriteLn(EnvStr(i));

  if ParamCount >=1 then begin
      for n :=1 to ParamCount do
          writeln(GetEnv(ParamStr(n)));

      // but what if the user run this program on Linux with USERPROFILE?
      if ParamStr(n) = 'USERPROFILE' then 
        {$IFDEF WINDOWS}
        GetEnv('USERPROFILE');
        {$ELSE}
        GetEnv('HOME');
        {$ENDIF} 
        
      if ParamStr(n) = '--help' then
      begin
          textgreenln('getvar version 1.0');
          TextColor(White);
          WriteLn('Use getvar with anything you want to get its value.');
          writeln('If you run this application without any arguments, getvar will');
          writeln('list all available variables.');
      end;
  end;
end.


