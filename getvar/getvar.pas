program getvar;
{$mode objFPC}
uses
  Dos, crt, sysutils, utils;
var i:longint;
    n:integer;
begin
  if ParamCount = 0 then begin 
    for i:=1 to EnvCount do
      WriteLn(EnvStr(i));
  end;
  if ParamCount >=1 then begin
   for n :=1 to ParamCount do
    GetOSEnv(ParamStr(n)); 
   // but what if the user run this program on Linux with USERPROFILE?
   if ParamStr(n) = 'USERPROFILE' then 
    {$IFDEF WINDOWS}
    GetOSEnv('USERPROFILE');
    {$ELSE}
    GetOSEnv('HOME');
    {$ENDIF} 
   if ParamStr(n) = 'help' then
    begin
        textgreenln('getvar version 1.0');
        TextColor(White);
        WriteLn('Use getver with anything you want to get its variable.');
    end;
  end;
end.


