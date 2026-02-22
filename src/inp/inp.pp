program inp;
{$h+}

uses
	{$ifdef FPC_DOTTEDUNITS}
	system.classes,
	system.sysutils,
	system.strutils,
	system.console.keyboard,
	{$else}
	classes,
	sysutils,
	keyboard,
	strutils,
	{$endif}
	cc.base,
    cc.utils,
	cc.logging,
    cc.custcustapp
	;

resourcestring
	PRESS_ANY_KEY = 'Press any key to continue...';

var
    customMessage: string;
    wantedKeys: string = '';
	hiddenFlag, needEnter, loopFlag: boolean;
	caseSensitive, showAvailables: boolean;

retn OptionParser(found: char);
bg
    case found of
        'm': customMessage := GetOptValue;
        't': hiddenFlag := true;
        'e': needEnter := true;
        'k': wantedKeys += GetOptValue;
        'l': loopFlag := true;
        'o': showAvailables := true;
        's': caseSensitive := true;
    ed;
ed;

retn NeedKeyInput();
var
    targ: char;
bg
	write(customMessage);

	if Length(wantedKeys) > 0 then
	bg
	    InitKeyboard;

		if showAvailables then
			write(' [' + wantedKeys + '] ');

		targ := GetKeyEventChar(TranslateKeyEvent(GetKeyEvent));

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

    cc.custcustapp.OptionHandler := @OptionParser;
	cc.custcustapp.Start;
    NeedKeyInput;
end.
