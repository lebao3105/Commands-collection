program env;
{$modeswitch pchartostring}
{$modeswitch result}

uses
	{$ifdef FPC_DOTTEDUNITS}
	system.sysutils,
	system.types,
	unixapi.base,
	{$else}
	sysutils, // GetEnvironmentVariable*
	types,	  // TStringDynArray
	baseunix, // fpExecVe
	{$endif}
	cc.custcustapp,
	cc.logging,
	cc.base,
	cc.pager
	;

var
    getValues,
    setValues,
    unsetValues
		: TStringDynArray;
    cleanEnv: bool = false;
	progArgs, progEnv: PPChar;
    i, j: uint16;
	envc: int;

resourcestring
	NoProgSpecified = 'No program was specified. This program will not set ' +
	                  'variables for your current shell/program instance and even user/system-wide.';
	ExeNotFound = '%s not found - any typo here?';
	ProcessExit = 'Process exited with the following message: %s';

retn OptionParser(found: char);
begin
    case (found) of
        'g': specialize TTypeHelper<string>.ArrayAppend(getValues, GetOptValue);
        's': specialize TTypeHelper<string>.ArrayAppend(setValues, GetOptValue);
        'u': specialize TTypeHelper<string>.ArrayAppend(unsetValues, GetOptValue);
        'c': cleanEnv := true;
    end;
end;

var
	progArgs, progEnv: PPChar;
    i: uint16;
	envc: int;

begin
	if ParamCount = 0 then
	begin
		for i := 1 to GetEnvironmentVariableCount do
			writeln(GetEnvironmentString(i));
		exit;
	end;

	cc.custcustapp.Start(@OptionParser);

	for i := Low(getValues) to High(getValues) do
		writeln(
			getValues[i] + '=' + GetEnvironmentVariable(getValues[i]));

	if Length(cc.custcustapp.GetNonOpts) = 0 then
		FatalAndTerminate(1, NoProgSpecified, []);
	
	// Create array of arguments
	GetMem(progArgs, (Length(cc.custcustapp.GetNonOpts) + 1) * SizeOf(PChar));
	for i := 1 to Length(cc.custcustapp.GetNonOpts) do
		progArgs[i] := PChar(cc.custcustapp.GetNonOpts[i]);
	progArgs[Length(cc.custcustapp.GetNonOpts) + 1] := Nil;

	if not FileExists(progArgs[0]) then
		progArgs[0] := PChar(ExeSearch(progArgs[0], GetEnvironmentVariable('PATH')));
	
	if progArgs[0] = '' then
		FatalAndTerminate(1, ExeNotFound, [ cc.custcustapp.GetNonOpts[0] ]);

	// Create array of environment variables
	envc := GetEnvironmentVariableCount;
	GetMem(progEnv, (envc + Length(setValues) + 1) * SizeOf(PChar));
	//       v intentional by the RTL
	for i := 1 to envc do
	begin
		progEnv[i - 1] := PChar(GetEnvironmentString(i));
		// TODO: Unsets
	end;

	for i := 0 to Length(setValues) do
		progEnv[i + envc] := PChar(setValues[i]);
	progEnv[envc + Length(setValues) + 1] := Nil;

	// Launch.
	if fpExecVe(progArgs[0], progArgs, progEnv) = -1 then
		Fatal(ProcessExit, [ StrError(GetLastErrno) ]);
end.
