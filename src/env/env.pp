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

fn SplitByEqualSign(const inp: string): TStringDynArray;
var
	p: sizeint;
begin
	p := pos('=', inp);
	if p > 0 then begin
		SetLength(Result, 2);
		result[0] := Copy(progArgs[i], 1, p - 1);
		result[1] := Copy(progArgs[i], p + 1, Length(progArgs[i]));
		return;
	end;
	
	SetLength(Result, 1);
	result[0] := inp;
end;

fn SetUnSetDifferences: TStringDynArray;
var	
	i, j: uint16;
	parts: TStringDynArray;
begin
	if (Length(setValues) = 0) or (Length(unsetValues) = 0) or (envc = 0) then
		return(setValues);

	for i := 1 to envc do begin
		Insert(GetEnvironmentString(i), Result, Length(Result) + 1);

		for j := Low(unsetValues) to High(unsetValues) do
			if SplitByEqualSign(Result[i - 1])[0] = unsetValues[j] then
				Result[i - 1] := '';

		for j := Low(setValues) to High(setValues) do
		begin
			parts := SplitByEqualSign(setValues[j]);
			if SplitByEqualSign(Result[i - 1])[0] = parts[0] then
				Result[i - 1] := setValues[j];
		end;
	end;

	if Length(Result) > 0 then
	for i := Low(Result) to High(Result) do
		if Result[i] = '' then
			Delete(Result, i, 1);
end;

begin
	envc := GetEnvironmentVariableCount;
	if ParamCount = 0 then
	begin
		for i := 1 to envc do
			pagedPrint(GetEnvironmentString(i), true);
		exit;
	end;

	cc.custcustapp.Start(@OptionParser);

	if Length(getValues) > 0 then
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
	if not cleanEnv then
		progEnv := ArrayStringToPPChar(SetUnsetDifferences, 0);

	// Launch.
	if fpExecVe(progArgs[0], progArgs, progEnv) = -1 then
		Fatal(ProcessExit, [ StrError(GetLastErrno) ]);

	Dispose(progEnv);
	Dispose(ProgArgs);
end.
