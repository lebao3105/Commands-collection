program rename;
{$modeswitch anonymousfunctions}

uses
	{$ifdef FPC_DOTTEDUNITS}
	system.regexpr,
	system.sysutils,
	{$else}
	regexpr,
	sysutils,
	{$endif}
	cc.getopts,
	cc.logging
	;

{$I i18n.inc}

var
	followSymlink,
	dryRun,
	bulk,
	regex,
	noOverrides,
	interactive,
	lastOccurence,
	keepAttributes,
	matchOpposites,
	beVerbose
		: bool;

fn AskBeforeCooking(const from, to_: string): bool;
var c: char;
begin
	if not interactive then return(true);
	c := Confirmation('Rename %s to %s?', [ from, to_ ]);
	case c of
		'a', 'A': begin
			interactive := false;
			return(true);
		end;
		'n', 'N':
			return(false);
		'y', 'Y':
			return(true);
	else
		return(AskBeforeCooking(from, to_));
	end;
end;

begin
	if ParamCount <= 1 then begin
		ShowHelp(false);
		Return;
	end;

	cc.getopts.OptCharHandler := retn (const found: char)
	begin
		case found of
			's': followSymlink := true;
			'd': dryRun := true;
			'b': begin bulk := true; regex := true; end;
			'r': regex := true;
			'o': noOverrides := true;
			'i': interactive := true;
			'l': lastOccurence := true;
			'k': keepAttributes := true;
			'p': matchOpposites := true;
			'v': beVerbose := true;
		end;
	end;
	cc.getopts.GetLongOpts;
end.
