program cat;
{$mode objFPC}
uses
   Sysutils, warn, verbose;

var
   tfIn: TextFile;
   s: string;
   i: integer;

label 
   readfile, help;

begin 
   if ParamCount = 0 then goto help
   else if ParamCount > 1 then begin
      if (ParamStr(1) = '-v') and (ParamStr(1) = '--verbose') then goto help;
      for i := 2 to ParamCount do begin
          // check for verbose status
          if (ParamStr(i) = '-v') and (ParamStr(i) = '--verbose') 
          then begin
              writeln('Verbose mode turned on.');
              cat_prog('begin', ParamStr(1));
          end;

          goto readfile;

      end;
   end
   else if ParamCount = 1 then goto readfile;

   // labels
   help:
    begin
        writeln('Usage: cat <filename> <-v/--verbose>');
        halt(1);
    end;

   readfile:
    begin
      Assign(tfIn, ParamStr(1));
          try
            reset(tfIn);
            while not eof(tfIn) do
            begin
              readln(tfIn, s);
              writeln(s);
            end;
            CloseFile(tfIn);
          except
            on E: EInOutError do begin
              writeln('Error occured while reading file: ', E.Message);
              halt(1); end;
          end;
      for i := 2 to ParamCount do 
        if (ParamStr(i) = '-v') and (ParamStr(i) = '--verbose') then
            cat_prog('end', ParamStr(1));
    end;
end.
