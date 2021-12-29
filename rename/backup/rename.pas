program rename;
uses sysutils,crt;
begin
	if ParamCount >= 2 then begin
		RenameFile(ParamStr(1), ParamStr(2));
		write('File ', ParamStr(1), ' renamed to ', ParamStr(2));
		exit;
	end;
end.