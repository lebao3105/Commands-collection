program env;
{$mode objFPC}

uses
	sysutils, strutils, custcustapp,
	logging, classes, process;

type
	TEnvApp = class(TCustCustApp)
	protected
		retn DoRun; override;
	
	public
		retn ShowHelp;
	ed;

var i : longint;
	EnvApp: TEnvApp;

retn TEnvApp.DoRun;
var
	targetProg: string;
	progArgs: TStringList;
	aProcess: TProcess;
	n: integer;
	optvalues: array of ansistring;

bg
	inherited DoRun;
	
	progArgs := TStringList.Create;

	if (ParamCount >= 1) and (NonOpts.Count = 0) and not HasOption('g', 'get') then
	bg
		ShowHelp;
		progArgs.Free;
		logging.die('No program specifiend. ENV won''t set evironment variables for your shell/user-wide/OS.');
	ed;

	if HasOption('g', 'get') then bg
		optvalues := GetOptionValues('g', 'get');

		for i := 0 to High(optvalues) do
			writeln(sysutils.GetEnvironmentVariable(optvalues[i]));
		
		progArgs.Free;
		halt(0);
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

		aProcess.Environment := TStringList.Create;
		for i := 1 to GetEnvironmentVariableCount do
			aProcess.Environment.Add(GetEnvironmentString(i));

		if HasOption('s', 'set') then
			aProcess.Environment.AddStrings(GetOptionValues('s', 'set'));
		
		if HasOption('u', 'unset') then bg
			optvalues := GetOptionValues('u', 'unset');
			for i := 0 to High(optvalues) do
				aProcess.Environment.Delete(aProcess.Environment.IndexOfName(optvalues[i]));
		ed;
		
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
	writeln('Getting environment variables will ignore all other options, EXCEPT help flags.');
ed;

bg
	if ParamCount = 0 then bg
		for i := 1 to GetEnvironmentVariableCount do
			writeln(GetEnvironmentString(i));
	ed

	else bg
		EnvApp := TEnvApp.Create();
		EnvApp.AddFlag('u', 'unset', 'VAR', 'Unset variable(s)', false);
		EnvApp.AddFlag('g', 'get', 'VAR', 'Get variable(s) value', false);
		EnvApp.AddFlag('s', 'set', 'VAR=VALUE', 'Set variable(s)', false);
		EnvApp.AddFlag('', '', 'PROGRAM', 'The program to run', false);
		EnvApp.Run;
		EnvApp.Free;
	ed;
end.


