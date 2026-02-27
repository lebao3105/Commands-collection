program rename;

uses
	{$ifdef FPC_DOTTEDUNITS}
	system.regexpr,
	system.sysutils,
	{$else}
	regexpr,
	sysutils,
	{$endif}
	cc.custcustapp,
	cc.logging
	;

var
	RENAMED_TO:  pchar; CUSTCUSTC_EXTERN 'get_RENAMED_TO';
	RENAME_FAIL: pchar; CUSTCUSTC_EXTERN 'get_RENAME_FAIL';
	CONFIRM: 	 pchar; CUSTCUSTC_EXTERN 'get_CONFIRM';

var
	followSymlink: bool;
	dryRun: bool;
	bulk: bool;
	regex: bool;
	noOverrides: bool;
	interactive: bool;
	lastOccurence: bool;
	keepAttributes: bool;
	matchOpposites: bool;
	beVerbose: bool;

retn OptionHdlr(const found: char);
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

fn AskBeforeCooking(const from, to_: string): bool;
var c: char;
begin
	if not interactive then return(true);
	c := Confirmation('Rename %s to %s?', PChar(from), PChar(to_));
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
		ShowHelp(0);
		Return;
	end;

	cc.custcustapp.OptionHandler := @OptionHdlr;
	cc.custcustapp.Start;
end.
