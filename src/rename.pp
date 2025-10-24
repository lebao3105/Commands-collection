program rename;

uses
	sysutils, logging;

begin
	if ParamCount <= 1 then die('2 arguments are required.')
	else
		if not FileExists(ParamStr(1)) then die(ParamStr(1) + ' does not exist!')
		else
			RenameFile(ParamStr(1), ParamStr(2));
			writeln('File ', ParamStr(1), ' renamed to ', ParamStr(2));
end.
