program rename;

uses 
	sysutils, crt{, warn};

var 
	i: integer;

begin
	{if ParamCount <= 1 then missing_argv()
	else} if ParamCount > 1 then 
			begin
				for i := 1 to ParamCount do
					if not FileExists(ParamStr(i)) then
						writeln('File ', ParamStr(i), ' does not exist!')
					else 
						RenameFile(ParamStr(i), ParamStr(i+1));
						writeln('File ', ParamStr(i), ' renamed to ', ParamStr(i+1));
			end;
end.