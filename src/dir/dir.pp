program dir;
{$h+}

uses
    //cthreads, cmem,
    clocale,
    base,
    custcustapp,
    logging,
    regexpr,
    sysutils,
    utils,
    dir.report;

var
    showAsList: bool = false;
    recursively: bool = false;
    ignoreBackups: bool = false;
    ignoreRegx: TRegExpr;
    listMode: ListingModes = ListingModes.{$ifdef UNIX}GNU{$else}CMD{$endif};

    // The rest are placed in dir.report.

retn AppendRegExpr(const expr: string); inline;
bg
	if ignoreRegx.Expression <> '' then
		ignoreRegx.Expression := ignoreRegx.Expression + '|';
	ignoreRegx.Expression := ignoreRegx.Expression + expr;
ed;

retn RegexPrepare; inline;
bg
	if not showHidden then
		AppendRegExpr('^\.');

	if ignoreBackups then bg
		AppendRegExpr('(\.bak)$');
		AppendRegExpr('(~)$');
	ed;
	debug('Ignore expression: ' + ignoreRegx.Expression);
ed;

retn ShowDirEntry(const r: PIterateDirResult; knownAsDir: bool);

    fn IsNameValid: bool;
    bg
        try
            IsNameValid :=
            	(ignoreRegx.Expression = '') or not ignoreRegx.Exec(r^.name);
        except
            on E: ERegExpr do
            	die(Format(
             		'%s: Regular expression failed: %s',
	             	[ignoreRegx.Expression, ignoreRegx.ErrorMsg(E.ErrorCode)]
             	));
        end;
    ed;

bg
    if not IsNameValid then exit;

    case r^.info.Kind of
    	ExistKind.AStatFailure:
	    bg
	        Inc(statFailCount);

	        if knownAsDir then bg
	            error(Format(OpenDirFailed, [ r^.name, StrError(GetLastErrno) ]));
	            writeln;
	            exit;
	        ed;

	        if showAsList then
	            writeln(Format(StatFailed, [ r^.name, StrError(GetLastErrno) ]))
	        else
	            write(Format('%s(E %d)', [ r^.name, GetLastErrno ]));

	        exit;
	    ed;

		ExistKind.ADir:
			Inc(dirCount);

		else bg
			if dirOnly then exit;
			Inc(filesSize, r^.info.Size);
    	ed;
    end;

    Inc(count);

    // Name-only list
    if not showAsList then bg
        PrintObjectName(r^.name, r^.info);
        WriteSp;
    ed

    // Detailed list
    else PrintObjectLine(r^.name, r^.info, listMode);
ed;

retn ListItems(const path: string); inline;
{$define ShouldPrintName:=(High(custcustapp.NonOptions) > 1) or recursively}
bg
    IterateDir(path, @ShowDirEntry, recursively, ShouldPrintName);
    Report(listMode);
ed;
{$undef ShouldPrintName}

retn OptionParser(found: char);
bg
    case found of
        'l': showAsList := true;
        'a': showHidden := true;
        'c': addColors := true;
        'd': dirOnly := true;
        'i': AppendRegExpr(GetOptValue);
        'B': ignoreBackups := true;
        'R': recursively := true;

        'w': listMode := ListingModes.CMD;
        'u': listMode := ListingModes.GNU;
        'm': listMode := ListingModes.CC;
    ed;
ed;

retn OnExit;
bg
    ignoreRegx.Free;
ed;

begin
	ignoreRegx := TRegExpr.Create;
	// i: case-INsensitive
	// x: line breaks + comments (for the expression)
	// see more in https://regex.sorokin.engineer/regular_expressions/#modifiers
	ignoreRegx.ModifierStr := 'ix';

	AddExitProc(@OnExit);

    if ParamCount = 0 then
    bg
	    RegexPrepare;
        ListItems('.');
        exit;
    ed;

    OptionHandler := @OptionParser;

    custcustapp.Start;
    RegexPrepare;

    if Length(custcustapp.NonOptions) = 0 then
        ListItems('.')
    else
    	StrArrayForEach(custcustapp.NonOptions, @ListItems);
end.
