program rename;

uses
	custcustapp, regexpr,
	sysutils, logging;

var
	RENAMED_TO: pchar; CUSTCUSTC_EXTERN 'get_RENAMED_TO';
	RENAME_FAIL: pchar; CUSTCUSTC_EXTERN 'get_RENAME_FAIL';
	CONFIRM: pchar; CUSTCUSTC_EXTERN 'get_CONFIRM';

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
bg
	case found of
		's': followSymlink := true;
		'd': dryRun := true;
		'b': bg bulk := true; regex := true; ed;
		'r': regex := true;
		'o': noOverrides := true;
		'i': interactive := true;
		'l': lastOccurence := true;
		'k': keepAttributes := true;
		'p': matchOpposites := true;
		'v': beVerbose := true;
	end;
ed;

fn AskBeforeCooking(const from, to_: string): bool;
var c: char;
bg
	if not interactive then return(true);
	c := Confirmation('Rename %s to %s?', PChar(from), PChar(to_));
	case c of
		'a', 'A': bg
			interactive := false;
			return(true);
		ed;
		'n', 'N':
			return(false);
		'y', 'Y':
			return(true);
	else
		return(AskBeforeCooking(from, to_));
	end;
ed;

begin
	if ParamCount <= 1 then bg
		ShowHelp(0);
		Return;
	ed;

	custcustapp.OptionHandler := @OptionHdlr;
	custcustapp.Start;
end.
