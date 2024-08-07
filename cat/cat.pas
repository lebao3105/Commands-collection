program cat;
{$mode objFPC}{$h+}

uses
	custapp, classes,
	sysutils, logging;

type TCat = class(TCustomApplication)
protected
	procedure DoRun; override;

private
	files: TStringList;
	showLineNo: boolean;
	procedure readFile(path: string);
end;

procedure TCat.readFile(path: string);
var
	tfIn: TextFile;
	line: string;
	currLine: integer = 1;

begin
	if not FileExists(path) then begin
		error(path + ': no such file or directory');
		if ParamCount = 0 then halt(1);
	end;

	assignFile(tfIn, path);
	reset(tfIn);
	try
		while not EOF(tfIn) do begin
			readln(tfIn, line);
			if showLineNo then
				writeln(IntToStr(currLine):6, line:12)
			else
				writeln(line);
			currLine := currLine + 1;
		end;
	except
		on E: EInOutError do begin
			error('Error reading ' + path + ': ' + E.Message);
			CloseFile(tfIn);
			halt(1);
		end;
	end;

	CloseFile(tfIn);
end;

procedure TCat.DoRun;
var
	errorMsg: string;
	args: TStringList; // flags with value (format: --<long flag>=<value> or -<short flag> value)
	i: integer;

begin
	args := TStringList.Create();
	files := TStringList.Create();

	// https://github.com/alrieckert/freepascal/blob/master/packages/fcl-base/examples/testapp.pp
	// args is a dummy argument for now, as no flag requires a value yet
	errorMsg := CheckOptions('hn', ['help', 'show-lineno'], args, files);
	if errorMsg <> '' then die(errorMsg);

	if HasOption('h', 'help') then
	begin
		writeln(ParamStr(0), ' [options] [files]');
		writeln('Prints out passed file paths.');
		writeln('--help / -h			: Show this help');
		writeln('-n / --show-lineno		: Show line number');
		Terminate;
		Exit;
	end;

	showLineNo := HasOption('n', 'show-lineno');

	for i := 0 to files.Count - 1 do readFile(files[i]);

	args.Free;
	files.Free;
	Terminate;
end;

var
	CatApp: TCat;

begin
	CatApp := TCat.Create(nil);
	CatApp.StopOnException := true;
	CatApp.Run;
	CatApp.Free;
end.
