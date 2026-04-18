program rename;
{$modeswitch anonymousfunctions}
{$modeswitch result} // for anonymous functions
{$modeswitch implicitfunctionspecialization}
{$modeswitch functionreferences}

uses
	{$ifdef FPC_DOTTEDUNITS}
	system.regexpr,
	system.sysutils,
	system.types,
	{$else}
	regexpr,
	sysutils,
	types,
	{$endif}
	cc.getopts,
	cc.logging,
	cc.base
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
	c := Confirmation(CONFIRM, [ from, to_ ]);
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

	cc.getopts.GetOpt;

	specialize ArrayForEach<TStringDynArray>(
		cc.getopts.GetArgPairs,
		fn(const pair: TStringDynArray): boolean
		     begin writeln(pair[0], ' ', pair[1]); exit(false); end
	);
end.
