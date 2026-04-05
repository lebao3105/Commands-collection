program inp;
{$modeswitch anonymousfunctions}

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
    cc.getopts
	;

{$undef NEED_PROGRAM_HELP}
{$I i18n.inc}

var
    customMessage: string = PRESS_ANY_KEY;
    wantedKeys: string = '';
	hiddenFlag, needEnter, loopFlag: boolean;
	caseSensitive, showAvailables: boolean;

retn WaitForEnter;
begin
	repeat
		// Do literally nothing
	until
		GetKeyEventChar(TranslateKeyEvent(GetKeyEvent)) = #13;
end;

retn NeedKeyInput;
var
    targ: char;
begin
	write(customMessage);

	if Length(wantedKeys) > 0 then
	begin
	    InitKeyboard;

		if showAvailables then
			write(' [' + wantedKeys + '] ');

		TArg := GetKeyEventChar(TranslateKeyEvent(GetKeyEvent));

		if not hiddenFlag then
			write(targ);

		if needEnter then WaitForEnter;

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

	halt(Ord(GetKeyEventChar(TranslateKeyEvent(GetKeyEvent))));
end;

begin
	cc.getopts.OptCharHandler := retn (const found: char)
	begin
		case found of
			'm': customMessage := OptArg;
			't': hiddenFlag := true;
			'e': needEnter := true;
			'k': wantedKeys += OptArg;
			'l': loopFlag := true;
			'o': showAvailables := true;
			's': caseSensitive := true;
		end;
	end;
	cc.getopts.GetLongOpts;
    NeedKeyInput;
end.
