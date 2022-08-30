program cat;
{$mode objFPC}

uses
	sysutils, warn, 
	verbose, color, crt;

var
	tfIn: TextFile;
	s: string;
	file_content: string;
	i, k: integer;

label
	check, readfile;

begin
	if ParamCount = 0 then
	begin
		textred('Usage: ');
		TextColor(LightGray);
		writeln(ParamStr(0), ' [file]');
		missing_argv;
		halt(1);
	end

	else begin
		for i := 1 to ParamCount do
			s := ParamStr(i);
			goto readfile;
		halt(0);
	end;

	check: begin
		if FileExists(s) then begin
			cat_prog(s, 'begin');
			goto readfile;
		end
		else begin
			textredln('File '+s+' not found!');
			TextColor(LightGray);
			if ParamCount = 0 then
				writeln('Exiting now.');
				halt(-1);
		end;
	end;

	readfile: begin
		assignFile(tfIn, s);
		reset(tfIn);
		try
			while not EOF(tfIn) do begin
				readln(tfIn, file_content);
				writeln(file_content);
			end;
			CloseFile(tfIn);
			cat_prog(s, 'end');
		except
			on E: EInOutError do begin
				textredln('Error occured while reading file '+s+': '+E.Message);
				halt(1);
			end;
		end;
	end;
end.
