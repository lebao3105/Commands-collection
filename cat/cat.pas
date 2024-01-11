program cat;
{$mode objFPC}{$h+}

uses
	custapp, classes,
	sysutils, logging,
	crt;

type TCat = class(TCustomApplication)
protected
	procedure DoRun; override;
end;

var
	CatApp: TCat;
	files: TStringList;
	showLineNo: boolean;
	s: string;
	tfIn: TextFile;
	file_content: string;

// file read functions
procedure readfile;
begin
	assignFile(tfIn, s);
	reset(tfIn);
	try
		while not EOF(tfIn) do begin
			readln(tfIn, file_content);
			writeln(file_content);
		end;
	except
		on E: EInOutError do begin
			die('Error reading file ' + s + ': ' + E.Message);
		end;
	end;
	CloseFile(tfIn);
end;

procedure check;
begin
	if FileExists(s) then readfile
	else
		error('File ' + s + ' not found!');
		if ParamCount = 0 then
			halt(-1);
end;
// end

// TCat
procedure TCat.DoRun;
var
	errorMsg: string;
	args: TStringList; // flags with value (format: <flag>=<value>)
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
		halt(0);
	end;

	if HasOption('n', 'show-lineno') then showLineNo := true;

	for i := 0 to files.Count - 1 do
		s := files[i];
		check;

	args.Free;
	files.Free;
	Terminate;
end;


begin
	CatApp := TCat.Create(nil);
	CatApp.StopOnException := true;
	CatApp.Run;
	CatApp.Free;
end.
