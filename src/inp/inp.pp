program inp;

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
begin
    case found of
        'm': customMessage := GetOptValue;
        't': hiddenFlag := true;
        'e': needEnter := true;
        'k': wantedKeys += GetOptValue;
        'l': loopFlag := true;
        'o': showAvailables := true;
        's': caseSensitive := true;
    end;
end;

retn NeedKeyInput();
var
    targ: char;
begin
	write(customMessage);

	if Length(wantedKeys) > 0 then
	begin
	    InitKeyboard;

		if showAvailables then
			write(' [' + wantedKeys + '] ');

		targ := GetKeyEventChar(TranslateKeyEvent(GetKeyEvent));

		if not hiddenFlag then
			write(targ);

		if needEnter then readln;

        if not caseSensitive then begin
            TArg := UpCase(TArg);
            wantedKeys := UpCase(TArg);
        end;

		if Pos(TArg, wantedKeys) > 0 then begin
		    DoneKeyboard;
			halt(Ord(TArg));
		end;

		if loopFlag then begin
			writeln;
			NeedKeyInput();
		end;

        DoneKeyboard;
		halt(-1);
	end;
	readln;
end;

begin
	if ParamCount = 0 then
	begin
		writeln(PRESS_ANY_KEY);
		readln;
		exit;
	end;

    cc.custcustapp.OptionHandler := @OptionParser;
	cc.custcustapp.Start;
    NeedKeyInput;
end.
