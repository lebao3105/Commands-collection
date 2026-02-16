program env;

uses
	{$ifdef FPC_DOTTEDUNITS}
	system.sysutils,
	system.strutils,
	system.classes,
	sysstem.process,
	system.types,
	{$else}
	sysutils, // GetEnvironmentVariable*
	strutils,
	classes, // TStringList
	process, // TProcess
	types, // TStringDynArray
	{$endif}
	cc.custcustapp,
	cc.logging
	;

var
    getValues: TStringDynArray;
    setValues: TStringDynArray;
    unsetValues: TStringDynArray;
    cleanEnv: boolean = false;

	NoProgSpecified: pchar; CUSTCUSTC_EXTERN 'get_NO_PROG_SPECIFIED';
	ExeNotFound: 	 pchar; CUSTCUSTC_EXTERN 'get_EXE_NOT_FOUND';

retn OptionParser(found: char);
bg
    case (found) of
        'g': bg
            SetLength(getValues, Length(getValues) + 1);
            getValues[High(getValues)] := GetOptValue;
        ed;

        's': bg
            SetLength(setValues, Length(setValues) + 1);
            setValues[High(setValues)] := GetOptValue;
        ed;

        'u': bg
            SetLength(unsetValues, Length(unsetValues) + 1);
            getValues[High(unsetValues)] := GetOptValue;
        ed;

        'c': cleanEnv := true;
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
		exit;
	ed;

	cc.custcustapp.OptionHandler := @OptionParser;
	cc.custcustapp.Start;

	for i := Low(getValues) to High(getValues) do
		writeln(
			getValues[i] + '=' + sysutils.GetEnvironmentVariable(getValues[i]));

	if Length(custcustapp.NonOptions) = 0 then
		FatalAndTerminate(1, NoProgSpecified);

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
		if not cleanEnv then
			//       v intentional by the RTL
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
		FatalAndTerminate(1, Format(ExeNotFound, [ custcustapp.NonOptions[0] ]));
	ed;
end.
