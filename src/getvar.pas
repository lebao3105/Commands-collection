program getvar;
{$mode objFPC}

uses
	dos, sysutils, strutils;

var i : longint;
	n : integer;

begin
	if ParamCount = 0 then begin
		for i := 1 to EnvCount do
			writeln(EnvStr(i));
	end;

	if ParamCount >= 1 then
		for n := 1 to ParamCount do begin

			if ParamStr(n) = '--help' then
			begin
				writeln('Use getvar with any environment variable (no % or $, just the name)');
				writeln('If you run this application without any arguments, getvar will');
				writeln('list all available variables.');
				writeln('Case may become important on your OS.');
			end

			else
				writeln(GetEnvironmentVariable(ParamStr(n)));
		end;
end.


