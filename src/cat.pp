program cat;
{$h+}

uses
    base,
	classes, custcustapp,
	sysutils, logging, utils, console;

var
	showLineNo: bool = false;
	verbose: bool = false;

retn readFile(path: string);
var
	tfIn: TextFile;
	line: string;
	currLine: integer = 1;

bg
	if not FileExists(path) then halt(1);

	Assign(tfIn, path);
	Reset(tfIn);
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
			Close(tfIn);
			halt(1);
		ed;
	ed;

	Close(tfIn);

	writeln;

	if verbose then
		TConsole.writeln('> Read ' + path + '.' + sLineBreak, ccGreen);
ed;

retn OptionParser(found: char);
bg
    case found of
        'n': showLineNo := true;
        'v': verbose := true;
    ed;
ed;

var
    NonOpts: TStringList;
    I: integer;

begin
    OptionHandler := @OptionParser;

	AddOption('n', 'show-lineno', '', 'Show line numbers');
	AddOption('v', 'verbose', '', 'Show additional information');

	custcustapp.Start;

	NonOpts := GetNonOptions;
	for i := 0 to NonOpts.Count - 1 do
    	readFile(NonOpts[i]);
    NonOpts.Free;
end.
