program cat;
{$mode objFPC}

uses
   Sysutils, warn, 
   verbose, color, crt;

var
   tfIn: TextFile;
   s: string;
   i, k: integer;

function getFileName(filepath : string): boolean;
begin
    if FileExists(filepath) then
       getFileName := true
    else
        textredln('File '+filepath+' not found! Exiting.');
        TextColor(LightGray);
		getFileName := false;
        halt(-1);
end;

function reader(filepath : string): boolean;
var checkResult: boolean;
begin
  checkResult := getFileName(filepath);
  if (checkResult = true) then begin
    assignFile(tfIn, filepath);
	reset(tfIn);
    try
      while not eof(tfIn) do begin
		readln(tfIn, s);
		writeln(s);
	  end;
      CloseFile(tfIn);
    except
      on E: EInOutError do
      begin
        textredln('File '+filepath+' could not be read!');
        textredln('Details: '+E.Message);
        halt(-1);
      end;
    end;
  end;
end;

begin
  if ParamCount = 0 then
  begin
      textred('Usage:');
      TextColor(LightGray);
      writeln(' cat [file]...');
      halt(1);
  end
  else
    for i := 1 to ParamCount do
        reader(ParamStr(i));
end.
