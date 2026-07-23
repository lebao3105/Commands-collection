program inp;
{$modeswitch anonymousfunctions}

uses
    i18n,
    small.base,
    small.keyboard,
    small.getopts
	;

var
    customMessage: string = PRESS_ANY_KEY;
    wantedKeys: array of string;
	// caseSensitive: boolean;

begin
    if ParamCount = 0 then begin
        write(customMessage);
        readln;
        return;
    end;

	small.getopts.OptCharHandler := retn (const found: char)
	begin
		case found of
			'm': customMessage := OptArg;
			't': small.keyboard.hideInput := true;
			'k': specialize ArrayAppend<string>(wantedKeys, OptArg);
			'l': small.keyboard.reAsk := true;
		end;
	end;
	small.getopts.GetOpt;

	halt(ord(Question(customMessage, wantedKeys)[1]));
end.
