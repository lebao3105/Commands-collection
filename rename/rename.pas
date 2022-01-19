program rename;
uses sysutils,crt;
begin
	if ParamCount <=1 then writeln('Missing argument(s). Exiting.');
	if ParamCount >= 2 then begin
		if not FileExists(ParamStr(1)) then
			writeln('The file ', ParamStr(1), ' does not exist. You may need to correct the target file name.')
		else 
			RenameFile(ParamStr(1), ParamStr(2));
			write('File ', ParamStr(1), ' renamed to ', ParamStr(2));
	end;
end.