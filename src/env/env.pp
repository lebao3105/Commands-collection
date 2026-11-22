program env;
{$modeswitch pchartostring}
{$modeswitch result}
{$modeswitch anonymousfunctions}

uses
	sysutils, // GetEnvironmentVariable*
	types,	  // TStringDynArray
	strutils,
		{$ifdef UNIX}
	baseunix
		{$else}
	ctypes
	{$endif}, // fpExecVe
	small.i18n,
	small.arr,
	small.getopts,
	small.logging,
	small.base
	;

{$ifdef WINDOWS}
function fpExecVe(const cmdName: pchar;
            const argv: ppchar;
            const envp: ppchar): cint; external 'msvcrt' name '_execve';
{$endif}

var
    getValues,
    setValues,
    unsetValues
		: TStringDynArray;
    cleanEnv: bool = false;
	separateByPathSep: bool = true;
	progArgs, progEnv: PPChar;
    i: uint16;
	envc: int;

function SplitByEqualSign(const inp: string): specialize TArray<String>;
var
	p: sizeint;
begin
	p := pos('=', inp);
	if p > 0 then begin
		SetLength(Result, 2);
		result[0] := Copy(inp, 1, p - 1);
		result[1] := Copy(inp, p + 1, Length(inp));
		return;
	end;

	SetLength(Result, 1);
	result[0] := inp;
end;

procedure SplitByPathSep(const inp: string);
begin
	specialize ArrayForEach<string>(SplitString(inp, PathSeparator), procedure(path: string)
	begin
		if Length(path) > 0 then
			writeln(#9 + path + PathSeparator);
	end);
end;

function SetUnSetDifferences: TStringDynArray;
var
	j: uint16;
	parts: TStringDynArray;
begin
	if (Length(setValues) = 0) or (Length(unsetValues) = 0) or (envc = 0) then
		return(setValues);

	for i := 1 to envc do begin
		Insert(GetEnvironmentString(i), Result, Length(Result) + 1);

		specialize ArrayForEach<string>(unsetValues, procedure(value: string)
			if SplitByEqualSign(Result[i - 1])[0] = value then
				Result[i - 1] := '';
		end);

		specialize ArrayForEach<string>(setValues, procedure(value: string)
		begin
			parts := SplitByEqualSign(value);
			if SplitByEqualSign(Result[i - 1])[0] = parts[0] then
				Result[i - 1] := value;
		end);
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
			procedure
			var splits: specialize TArray<string>;
			begin
				splits := SplitByEqualSign(GetEnvironmentString(i));
				writeln(splits[0] + ' =');
				SplitByPathSep(splits[1]);
			end();
		exit;
	end;

	small.getopts.OptCharHandler := procedure (const found: char)
	begin
		case (found) of
			'g': specialize ArrayAppend<string>(getValues, OptArg);
			's': specialize ArrayAppend<string>(setValues, OptArg);
			'u': specialize ArrayAppend<string>(unsetValues, OptArg);
			'p': separateByPathSep := true;
			'c': cleanEnv := true;
		end;
	end;

	specialize ArrayForEach<string>(getValues, procedure(value: string)
	begin
		write(value + '=');
		SplitByPathSep(GetEnvironmentVariable(value));
	end);

	if Length(small.getopts.NonOpts) = 0 then
		FatalAndTerminate(1, NoProgSpecified);

	// Create array of arguments
	if not FileExists(small.getopts.NonOpts[0]) then
		small.getopts.NonOpts[0] := ExeSearch(small.getopts.NonOpts[0], GetEnvironmentVariable('PATH'));

	if small.getopts.NonOpts[0] = '' then
		FatalAndTerminate(1, ExeNotFound, [ small.getopts.NonOpts[0] ]);

	progArgs := ArrayStringToPPChar(small.getopts.NonOpts, 0);

	// Create array of environment variables
	if not cleanEnv then
		progEnv := ArrayStringToPPChar(SetUnsetDifferences, 0);

	AddExitProc(procedure
	begin
		Dispose(progEnv);
		Dispose(ProgArgs);
	end);

	// Launch.
	if fpExecVe(progArgs[0], progArgs, progEnv) = -1 then
		Fatal(ProcessExit, [ GetLastStrErrno ]);
end.
