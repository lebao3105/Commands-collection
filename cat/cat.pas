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
        halt(-1);
end;

function reader(filepath : string): boolean;
begin
    getFileName(filepath);
    assign(tfIn, filepath);
    try
      reset(tfIn);
      while not eof(tfIn) do
      begin
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

begin
  if ParamCount = 0 then
  begin
      textred('Usage:');
      TextColor(LightGray);
      writeln(' cat [file] [-v/--verbose] ...');
      halt(1);
  end else if ParamCount = 1 then reader(ParamStr(1))
  else
    begin
      for i := 1 to ParamCount do
          if (ParamStr(i) = '-v') and (ParamStr(i) = '--verbose') 
          then
          begin
              for k := 1 to ParamCount do
                if k <> i then 
                begin
                    cat_prog('begin', ParamStr(k));
                    reader(ParamStr(k));
                end;
          end else reader(ParamStr(i));
    end;
end.