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
	end;

	if ParamCount >= 1 then
		for n := 1 to ParamCount do begin
			// what if the user run this program on UNIX with USERPROFILE?
			// ignore them.
			// {$IFDEF UNIX}
			// if ParamStr(n) = 'USERPROFILE' then
			// 	writeln(GetEnv('HOME'));
			// {$ENDIF} 

			if ParamStr(n) = '--help' then
			begin
				writeLn('Use getvar with any environment variable (no % or $, just the name)');
				writeln('If you run this application without any arguments, getvar will');
				writeln('list all available variables.');
				writeln('Case may become important on your OS.');
			end

			else
				writeln(GetEnv(ParamStr(n)));
		end;
end.


