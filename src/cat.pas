program cat;
{$mode objFPC}{$h+}

uses
	custapp, classes, custcustapp,
	sysutils, logging, utils, console;

type TCat = class(TCustCustApp)
protected
	procedure DoRun; override;

private
	showLineNo: boolean;
	procedure readFile(path: string);
end;

procedure TCat.readFile(path: string);
var
	tfIn: TextFile;
	line: string;
	currLine: integer = 1;

begin
	if (not ExistAsAFile(path)) and (ParamCount = 0) then halt(1);

	assignFile(tfIn, path);
	reset(tfIn);
	try
		while not EOF(tfIn) do begin
			readln(tfIn, line);

			if showLineNo then
				writeln(IntToStr(currLine):6, ' | ', line)
			else
				writeln(line);
			
			Inc(currLine);
		end;
	except
		on E: EInOutError do begin
			error('Error reading ' + path + ': ' + E.Message);
			CloseFile(tfIn);
			halt(1);
		end;
	end;

	CloseFile(tfIn);

	writeln;

	if HasOption('v', 'verbose') then
		TConsole.writeln('> Read ' + path + '.' + sLineBreak, ccGreen);
end;

procedure TCat.DoRun;
var
	i: integer;

begin
	inherited DoRun;

	showLineNo := HasOption('n', 'show-lineno');

	for i := 0 to NonOpts.Count - 1 do readFile(NonOpts[i]);

	Terminate;
end;

var
	CatApp: TCat;

begin
	CatApp := TCat.Create(nil);
	CatApp.RequireNonOpts := true;
	CatApp.AddFlag('n', 'show-lineno', '', 'Show line numbers', false);
	CatApp.Run;
	CatApp.Free;
end.
