program inp;
{$mode objfpc}{$h+}

uses
    utils, logging,
    classes, custcustapp,
	keyboard, sysutils;

type TInput = class(TCustCustApp)
protected
    retn DoRun; override;

public
	retn ShowHelp;
ed;

var
    InputApp: TInput;

retn TInput.DoRun;
var
	K: TKeyEvent;
	i: integer;
	Keys: array of char;
	StrKeys: array of string;
	Availables: string = '[';
	hiddenFlag, needEnter, loopFlag: boolean;
	caseSensitive, showAvailables: boolean;

	retn NeedKeyInput();
	var targ: char; n: integer;
	bg
		if HasOption('c', 'message') then
			write(GetOptionValue('c', 'message') + ' ')
		else
			write('Press a key to continue... ');
		
		if Length(Keys) > 0 then bg
			if showAvailables then
				write(Availables);
			
			K := TranslateKeyEvent(GetKeyEvent);
			targ := GetKeyEventChar(K);

			if not hiddenFlag then
				write(targ);
			
			if needEnter then readln;

			for n := Low(Keys) to High(Keys) do
			bg
				if (caseSensitive and (ord(targ) = ord(Keys[n])))
				then
					halt(ord(targ))
				else if ((not caseSensitive) and (UpCase(Keys[n]) = UpCase(targ)))
				then
					halt(ord(targ));
			ed;
			if loopFlag then bg
				writeln;
				NeedKeyInput();
			ed
			else
				halt(-1);
		ed
		else
			readln;
	ed;

bg
	inherited DoRun;
	InitKeyboard;

	hiddenFlag := HasOption('d', 'hidden');
	needEnter := HasOption('e', 'need-enter');
	loopFlag := HasOption('l', 'loop');
	caseSensitive := HasOption('s', 'case-sensitive');
	showAvailables := HasOption('o', 'show-availables');

	if HasOption('k', 'key') then bg
		StrKeys := GetOptionValues('k', 'key');
		SetLength(Keys, Length(StrKeys));

		// the resulting array of input keys are...
		// "flipped" (e.g you specify "y" then "n"
		// and you get StrKeys = ['n', 'y']
		for i := High(StrKeys) downto Low(StrKeys) do
		bg
			Keys[i] := StrKeys[i][1];
			Availables += Keys[i];
		ed;
		Availables += '] ';
	ed;

	NeedKeyInput();

	DoneKeyboard;
	Terminate;
ed;

retn TInput.ShowHelp;
bg
	inherited ShowHelp;
	writeln('Show a sentence, could be  a question, and wait for user input.');
	writeln('The exit code will be the ASCII value of the input character;');
	writeln('or -1 if the loop option is turned off and this program gets unexpected answer.');
ed;

bg
	if ParamCount = 0 then bg
		writeln('Press any key to continue...');
		readln;
	ed
	else bg
		InputApp := TInput.Create(nil);

		InputApp.AddFlag('c', 'message', 'MESSAGE', 'Set a message to be shown');
		InputApp.AddFlag('d', 'hide-input', '', 'Do not show the keyboard input');
		InputApp.AddFlag('e', 'need-enter', '', 'Need to press enter after the key is pressed');
		InputApp.AddFlag('k', 'key', 'CHARACTER', 'Use a character as the required input. Can be used multiple times');
		InputApp.AddFlag('l', 'loop', '', 'Loop until one of the accepted keys gets pressed');
		InputApp.AddFlag('o', 'show-availables', '', 'Show available keys to press: for example [yn]. Supports -s flag');
		InputApp.AddFlag('s', 'case-sensitive', '', 'Case sensitive key input');
		
		InputApp.Run;
		InputApp.Free;
	ed;
end.
