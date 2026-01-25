program dir;

uses
    clocale,
    base,
    custcustapp,
    logging,
    sysutils,
    utils,
    regexpr, // ERegExpr
    dir.report;

var
    showAsList: bool = false;
    recursively: bool = false;
    ignoreBackups: bool = false;
    listMode: ListingModes = ListingModes.{$ifdef UNIX}GNU{$else}CMD{$endif};

    // The rest are placed in dir.report.

retn RegexPrepare; inline;
bg
	if not showHidden then
		RegexAppendExpr('^\.');

	if ignoreBackups then bg
		RegexAppendExpr('(\.bak)$');
		RegexAppendExpr('(~)$');
	ed;
	debug('Ignore expression: %s', PChar(RegexGetExpr));
ed;

retn ShowDirEntry(const r: PIterateDirResult; knownAsDir: bool);

    fn IsNameInvalid: bool;
    var check: specialize TResult<bool, ERegExpr>;
    bg
    	check := RegexHasMatches(r^.name);
     	if check.IsError then
           	FatalAndTerminate(1,
          		'%s: Regular expression failed: %s',
	            PChar(RegexGetExpr), PChar(RegexGetLastError)
           	)
        else
        	exit(check.Value);
    ed;

bg
    if IsNameInvalid then exit;

    case r^.info.Kind of
    	ExistKind.AStatFailure:
	    bg
	        Inc(statFailCount);

	        if knownAsDir then bg
	            Error(OpenDirFailed, PChar(r^.name), PChar(StrError(GetLastErrno)));
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
        'i': RegexAppendExpr(GetOptValue);
        'B': ignoreBackups := true;
        'R': recursively := true;

        'w': listMode := ListingModes.CMD;
        'u': listMode := ListingModes.GNU;
        'm': listMode := ListingModes.CC;
    ed;
ed;

begin
	// i: case-INsensitive
	// x: line breaks + comments (for the expression)
	// r: Russian ranges
	// g: greediness
	RegexSetModifiers('ixr-g');

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
    	specialize TTypeHelper<string>.ArrayForEach(custcustapp.NonOptions, @ListItems);
end.
