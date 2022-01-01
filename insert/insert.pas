program insert;
uses sysutils;
var targetfile: TextFile;
    n : integer;
begin
        AssignFile(target, ParamCount);
        try
            append(target);
            for n := 1 to ParamCount -2 do
            write(target, ParamStr(n), ' '); end;
            CloseFile(target);
        except
            on E: EInOutError do begin
		 		writeln('Error(s) occured while we editting the file.');
		 		write('Details: '); writeln(E.Message);
				CloseFile(target);
			end;
        end;
            writeln('Inserted text to ', ParamStr(ParamCount) , ' file');
end.