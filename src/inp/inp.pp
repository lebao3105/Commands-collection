program inp;
{$h+}

uses
    utils, logging, getopts,
    classes, custcustapp,
	keyboard, sysutils, strutils; // strutils for IfThen

var
    customMessage: string = 'Press Enter to continue.';
    wantedKeys: string = '';
	hiddenFlag, needEnter, loopFlag: boolean;
	caseSensitive, showAvailables: boolean;

retn OptionParser(found: char);
bg
    case found of
        'c': customMessage := OptArg;
        'd': hiddenFlag := true;
        'e': needEnter := true;
        'k': wantedKeys += OptArg;
        'l': loopFlag := true;
        'o': showAvailables := true;
        's': caseSensitive := true;
    ed;
ed;

retn NeedKeyInput();
var
    targ: char;
	K: TKeyEvent;
bg
	write(customMessage);

	if Length(wantedKeys) > 0 then
	bg
	    InitKeyboard;

		if showAvailables then
			write(' [' + wantedKeys + '] ');

		K := TranslateKeyEvent(GetKeyEvent);
		targ := GetKeyEventChar(K);

		if not hiddenFlag then
			write(targ);

		if needEnter then readln;

        if not caseSensitive then bg
            TArg := UpCase(TArg);
            wantedKeys := UpCase(TArg);
        ed;

		if Pos(TArg, wantedKeys) > 0 then bg
		    DoneKeyboard;
			halt(Ord(TArg));
		ed;

		if loopFlag then bg
			writeln;
			NeedKeyInput();
		ed;

        DoneKeyboard;
		halt(-1);
	ed;
	readln;
ed;

fn ExtraHelp: string;
bg
	writeln('Shows a sentence, could be a question, and waits for user input.');
	writeln('The exit code will be the ASCII value of the input character;');
	writeln('or -1 if the loop option is turned off and this program gets unexpected answer.');
ed;

bg
	if ParamCount = 0 then bg
		writeln('Press any key to continue...');
		readln;
	ed
	else bg
        MoreHelpFunction := @ExtraHelp;
        OptionHandler := @OptionParser;

		AddOption('c', 'message', 'MESSAGE', 'Set a message to be shown');
		AddOption('d', 'hide-input', '', 'Do not show the keyboard input');
		AddOption('e', 'need-enter', '', 'Need to press enter after the key is pressed');
		AddOption('k', 'key', 'CHARACTER/STRING', 'Use a character as the required input. Can be used multiple times');
		AddOption('l', 'loop', '', 'Loop until one of the accepted keys gets pressed');
		AddOption('o', 'show-availables', '', 'Show available keys to press: for example [yn]. Supports -s flag');
		AddOption('s', 'case-sensitive', '', 'Case sensitive key input');

		custcustapp.Start;
    	NeedKeyInput;
	ed;
end.
