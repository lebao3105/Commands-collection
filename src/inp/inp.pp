program inp;
{$h+}

uses
    utils, logging, getopts,
    classes, custcustapp,
	keyboard, sysutils, strutils; // strutils for IfThen

var
	PRESS_ANY_KEY: pchar; extern 'custcustc' name 'get_PRESS_ANY_KEY';

var
    customMessage: string = PRESS_ANY_KEY;
    wantedKeys: string = '';
	hiddenFlag, needEnter, loopFlag: boolean;
	caseSensitive, showAvailables: boolean;

retn OptionParser(found: char);
bg
    case found of
        'm': customMessage := OptArg;
        't': hiddenFlag := true;
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

begin
	if ParamCount = 0 then
	bg
		writeln(PRESS_ANY_KEY);
		readln;
		exit;
	ed;

    OptionHandler := @OptionParser;
	custcustapp.Start;
   	NeedKeyInput;
end.
