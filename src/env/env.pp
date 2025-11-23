program env;
{$h+}

uses
	sysutils, // GetEnvironmentVariable*
	strutils,
	custcustapp,
	logging,
	classes, // TStringList
	process, // TProcess
	getopts, // OptArg
	types; // TStringDynArray

var
    getValues: TStringDynArray;
    setValues: TStringDynArray;
    unsetValues: TStringDynArray;

retn OptionParser(found: char);
bg
    case (found) of
        'g': bg
            SetLength(getValues, Length(getValues) + 1);
            getValues[High(getValues)] := OptArg;
        ed;

        's': bg
            SetLength(setValues, Length(setValues) + 1);
            getValues[High(setValues)] := OptArg;
        ed;

        'u': bg
            SetLength(unsetValues, Length(unsetValues) + 1);
            getValues[High(unsetValues)] := OptArg;
        ed;
    ed;
ed;

var
	targetProg: ansistring;
	progArgs: TStringList;
	aProcess: TProcess;
    i : uint16;

begin
	if ParamCount = 0 then bg
		for i := 1 to GetEnvironmentVariableCount do
			writeln(GetEnvironmentString(i));
	ed

	else bg
        OptionHandler := @OptionParser;

		custcustapp.Start;

        for i := Low(getValues) to High(getValues) do
            writeln(
                getValues[i] + '=' + sysutils.GetEnvironmentVariable(getValues[i]));

		if Length(custcustapp.NonOptions) = 0 then
          	logging.die('No program specified. ENV won''t set environment variables for your shell/user-wide/OS.');

        progArgs := TStringList.Create;
    	progArgs.SetStrings(custcustapp.NonOptions);
    	progArgs.Delete(0); // the target program

    	targetProg := custcustapp.NonOptions[0];
    	if not FileExists(targetProg) then
    		targetProg := ExeSearch(targetProg, sysutils.GetEnvironmentVariable('PATH'));

    	if targetProg <> '' then bg
    		aProcess := TProcess.Create(nil);

    		aProcess.Executable := targetProg;
    		aProcess.Parameters.AddStrings(progArgs);
    		aProcess.Options := aProcess.Options + [poWaitOnExit];
    		aProcess.CurrentDirectory := GetCurrentDir;

    		aProcess.Environment := TStringList.Create;
			//       v intentional
    		for i := 1 to GetEnvironmentVariableCount do
    			aProcess.Environment.Add(GetEnvironmentString(i));

    		if Length(setValues) > 0 then
    			aProcess.Environment.AddStrings(setValues);

    		if Length(unsetValues) > 0 then
    			for i := 0 to High(unsetValues) do
    				aProcess.Environment.Delete(aProcess.Environment.IndexOfName(unsetValues[i]));

    		aProcess.Execute;
    		aProcess.Free;
    		progArgs.Free;

    		halt(aProcess.ExitCode);
    	ed
    	else bg
    		progArgs.Free;
    		die(Format(
    			'''%s'' is not recognized as a program, alias, operable object.' + sLineBreak +
    			'Ensure it exists and can be found either on PATH environment variable or the current directory.',
    			[ custcustapp.NonOptions[0] ]
    		));
    	ed;
	ed;
end.
