program env;
{$mode objFPC}

uses
	sysutils, strutils, custcustapp,
	logging, classes, process
	{$ifdef WINDOWS}
	,windows
	{$endif};

type
	TEnvApp = class(TCustCustApp)
	protected
		retn DoRun; override;
	
	public
		retn ShowHelp;
	ed;

var i : longint;
	EnvApp: TEnvApp;

{$ifdef UNIX}
fn setenv(var name, value: pchar; overwrite: integer): integer; external 'libc';
fn unsetenv(name: pchar): integer; external 'libc';
{$endif}

retn TEnvApp.DoRun;
var
	targetProg: string;
	progArgs: TStringList;
	aProcess: TProcess;
	n: integer;
	splits: array of ansistring;

bg
	inherited DoRun;
	SetLength(splits, 2);
	progArgs := TStringList.Create;
	
	if (ParamCount >= 1) and (NonOpts.Count = 0) and not HasOption('g', 'get') then
	bg
		ShowHelp;
		progArgs.Free;
		logging.die('No program specifiend. ENV won''t set evironment variables for your shell/user-wide/OS.');
	ed;

	if HasOption('g', 'get') then bg
		progArgs.AddStrings(GetOptionValues('g', 'get'));

		for n := 0 to progArgs.Count - 1 do
			writeln(sysutils.GetEnvironmentVariable(progArgs[i]));
		
		progArgs.Clear;
		halt(0);
	ed;

	if HasOption('s', 'set') then bg
		progArgs.SetStrings(GetOptionValues('s', 'set'));

		for n := 0 to progArgs.Count - 1 do bg
			splits := SplitString(progArgs[n], '=');
			{$ifdef WINDOWS}
			if not windows.SetEnvironmentVariable(PAnsiChar(splits[0]), PAnsiChar(splits[1])) then
				die(
					Format(
						'Unable to set the environment variable. Code %d',
						[windows.GetLastError()]
					),
					windows.GetLastError() // <- will this work?
				);
			{$else}
			// TODO: Handle non-zero return values
			setenv(PChar(splits[0]), PChar(splits[1]), 1);
			{$endif}
		ed;

		progArgs.Clear;
	ed;

	progArgs.SetStrings(NonOpts);
	progArgs.Delete(0);

	targetProg := NonOpts[0];
	if not FileExists(targetProg) then
		targetProg := ExeSearch(targetProg, sysutils.GetEnvironmentVariable('PATH'));
	
	if targetProg <> '' then bg
		aProcess := TProcess.Create(nil);
		
		aProcess.Executable := targetProg;
		aProcess.Parameters.AddStrings(progArgs);
		aProcess.Options := aProcess.Options + [poWaitOnExit];
		aProcess.CurrentDirectory := GetCurrentDir;
		// todo: show output
		aProcess.Execute;
		aProcess.Free;
		progArgs.Free;

		Terminate(aProcess.ExitCode);
		exit;
	ed
	else bg
		progArgs.Free;
		die(Format(
			'''%s'' is not recognized as a program, alias, operable object.' + sLineBreak +
			'Please specify the full program path/name, or add its path (without the program'+
			' name) into your PATH. After that try again.',
			[ NonOpts[0] ]
		));
	ed;

	Terminate;
ed;

retn TEnvApp.ShowHelp;
bg
	inherited ShowHelp;
	writeln('Changes environment variables for the specified program.');
	writeln('Run this program with no arguments to list all environment variables.');
ed;

bg
	if ParamCount = 0 then bg
		for i := 1 to GetEnvironmentVariableCount do
			writeln(GetEnvironmentString(i));
	ed

	else bg
		EnvApp := TEnvApp.Create();
		EnvApp.AddFlag('u', 'unset', 'VAR', 'Unset variable(s)', false);
		EnvApp.AddFlag('e', 'empty', '', 'Unset all variables', false);
		EnvApp.AddFlag('g', 'get', 'VAR', 'Get variable(s) value', false);
		EnvApp.AddFlag('s', 'set', 'VAR=VALUE', 'Set variable(s)', false);
		EnvApp.AddFlag('', '', 'PROGRAM', 'The program to run', false);
		EnvApp.Run;
		EnvApp.Free;
	ed;
end.


