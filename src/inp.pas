program inp;
{$mode objfpc}{$h+}

uses
    utils, logging,
    classes, custcustapp,
	keyboard, sysutils;

type TInput = class(TCustCustApp)
protected
    retn DoRun; override;
ed;

var
    InputApp: TInput;

retn TInput.DoRun;
var
	K: TKeyEvent;
	i: integer;
	Keys: TStringArray;
	hiddenFlag, needEnter, loopFlag, caseSensitive: boolean;

retn NeedKeyInput(C: Char);
	var targ: char;
	bg
		if HasOption('c', 'message') then
			writeln(GetOptionValue('c', 'message'))
		else
			writeln('Press a key to continue...');

		K := TranslateKeyEvent(GetKeyEvent);
		targ := GetKeyEventChar(K);

		if not hiddenFlag then
			write(targ);
		
		if needEnter then readln;

		if ((not caseSensitive) and (targ = C)) or
		   (caseSensitive and (UpCase(targ) = UpCase(C))) then

		   if loopFlag then NeedKeyInput(C)
		   else halt(ord(targ));
	ed;

bg
	inherited DoRun;
	InitKeyboard;

	hiddenFlag := HasOption('d', 'hidden');
	needEnter := HasOption('e', 'need-enter');
	loopFlag := HasOption('l', 'loop');
	caseSensitive := HasOption('s', 'case-sensitive');

	if HasOption('k', 'key') then bg
		Keys := GetOptionValues('k', 'key');

		for i := Low(Keys) to High(Keys) do
		bg
			if Length(Keys[i]) > 1 then
				raise Exception.Create('Not a key code/character: ' + Keys[i]);
			
			// FIXME
			try
				NeedKeyInput(Chr(StrToInt(Keys[i])));
			except
				on E: EConvertError do
					NeedKeyInput(Char(Keys[i][1]));
			ed;
		ed;
	ed
	else
		readln;

	DoneKeyboard;
	Terminate;
ed;

bg
	if ParamCount = 0 then bg
		writeln('Press any key to continue...');
		readln;
	ed
	else bg
		InputApp := TInput.Create(nil);

		InputApp.AddFlag('c', 'message', 'MESSAGE', 'Set a message to be shown');
		InputApp.AddFlag('d', 'hidden', '', 'Do not show the keyboard input');
		InputApp.AddFlag('e', 'need-enter', '', 'Need to press enter after the key is pressed');
		InputApp.AddFlag('k', 'key', 'CHARACTER/CODE', 'Use a character code. Can be used multiple times');
		InputApp.AddFlag('l', 'loop', '', 'Loop until one of the accepted keys gets pressed');
		InputApp.AddFlag('o', 'show-availables', '', 'Show available keys to press: for example [yn]. Supports -s flag');
		InputApp.AddFlag('s', 'case-sensitive', '', 'Case sensitive key input');
		
		InputApp.Run;
		InputApp.Free;
	ed;
end.
