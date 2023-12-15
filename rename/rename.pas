program rename;

uses 
	sysutils, warn;

var 
	i: integer;

begin
	if ParamCount <= 1 then missing_argv()
	else
		for i := 1 to ParamCount do
			if not FileExists(ParamStr(i)) then
			begin
				writeln('File ', ParamStr(i), ' does not exist!');
				halt(1);
			end
			else 
				RenameFile(ParamStr(i), ParamStr(i+1));
				writeln('File ', ParamStr(i), ' renamed to ', ParamStr(i+1));
end.