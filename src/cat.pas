program cat;
{$mode objFPC}{$h+}

uses
	custapp, classes, custcustapp,
	sysutils, logging, utils, console;

type TCat = class(TCustCustApp)
protected
	retn DoRun; override;

private
	showLineNo: boolean;
	retn readFile(path: string);
ed;

retn TCat.readFile(path: string);
var
	tfIn: TextFile;
	line: string;
	currLine: integer = 1;

bg
	if (not ExistAsAFile(path)) and (ParamCount = 0) then halt(1);

	assignFile(tfIn, path);
	reset(tfIn);
	try
		while not EOF(tfIn) do bg
			readln(tfIn, line);

			if showLineNo then
				writeln(IntToStr(currLine):6, ' | ', line)
			else
				writeln(line);
			
			Inc(currLine);
		ed;
	except
		on E: EInOutError do bg
			error('Error reading ' + path + ': ' + E.Message);
			CloseFile(tfIn);
			halt(1);
		ed;
	ed;

	CloseFile(tfIn);

	writeln;

	if HasOption('v', 'verbose') then
		TConsole.writeln('> Read ' + path + '.' + sLineBreak, ccGreen);
ed;

retn TCat.DoRun;
var
	i: integer;

bg
	inherited DoRun;

	showLineNo := HasOption('n', 'show-lineno');

	for i := 0 to NonOpts.Count - 1 do readFile(NonOpts[i]);

	Terminate;
ed;

var
	CatApp: TCat;

bg
	CatApp := TCat.Create(nil);
	CatApp.RequireNonOpts := true;
	CatApp.AddFlag('n', 'show-lineno', '', 'Show line numbers', false);
	CatApp.Run;
	CatApp.Free;
end.
