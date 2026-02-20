program dir;

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.cmem, unixapi.cthreads,
    system.clocale, system.sysutils,
    system.regexpr,
    {$else}
    cmem, cthreads, clocale, sysutils, regexpr,
    {$endif}
    cc.base,
    cc.custcustapp,
    cc.logging,
    cc.utils,
    dir.report,
    dir.settings;

retn ShowDirEntry(const r: PIterateDirResult; knownAsDir: bool);

    fn IsNameInvalid: bool;
    var check: specialize TResult<bool, ERegExpr>;
    bg
    	check := RegexHasMatches(r^.name);
     	if check.IsError then
           	FatalAndTerminate(1, REGEX_FAILED, @RegexGetExpr, @check.Error.Message)
        else
        	exit(check.Value);
    ed;

bg
    if IsNameInvalid then exit;

    case r^.info.Kind of
    	EFSEntityKind.AStatFailure:
	    bg
	        Inc(statFailCount);

	        // if knownAsDir then bg
	        //     Error(OPEN_DIR_FAILED, @r^.name, @StrError(GetLastErrno));
	        //     writeln;
	        //     exit;
	        // ed;

	        if Settings.UseLists then
	            writeln(Format(STAT_FAILED, [ r^.name, StrError(GetLastErrno) ]))
	        else
	            write(Format('%s(E %d)', [ r^.name, GetLastErrno ]));

	        exit;
	    ed;

		EFSEntityKind.ADir:
			Inc(dirCount);

		else bg
			if Settings.DirOnly then exit;
			Inc(filesSize, r^.info.Size);
    	ed;
    end;

    Inc(count);

    // Name-only list
    if not Settings.UseLists then bg
        PrintObjectName(r^.name, r^.info);
        WriteSp;
    ed

    // Detailed list
    else PrintObjectName(r^.name, r^.info);
ed;

retn ListItems(const path: string); inline;
bg
    IterateDir(path, @ShowDirEntry, Settings.Recursively,
               (High(cc.custcustapp.NonOptions) > 1) or Settings.Recursively);
    Report;
ed;

retn OptionParser(found: char);
bg
    case found of
        'l': Settings.UseLists := true;
        'a': Settings.IgnoreHiddens := false;
        'c': Settings.AddColors := true;
        'd': Settings.DirOnly := true;
        'i': RegexAppendExpr(GetOptValue);
        'B': Settings.IgnoreBackups := true;
        'R': Settings.Recursively := true;
    ed;
ed;

fn RegexCheck: bool;
var
    checkr: specialize TResult<bool, ERegExpr>;
bg
    if RegexGetExpr = '' then
        return(true);
    
    checkr := RegexVerifyExpr;
    if not checkr.IsError then
        return(checkr.Value);
    
    FatalAndTerminate(
        1,
        REGEX_FAILED_LOC,
        @RegexGetLastError, @RegexGetLastCompileErrorPos
    );
ed;

begin
    case StrLowerCase(GetEnvironmentVariable('DIR_PRESET')) of
        'win': dir.settings.Settings := WIN_PRESET;
        'gnu': dir.settings.Settings := GNU_PRESET;
        'ccd': dir.settings.Settings := CCD_PRESET;
    else
        BeginThread(
            @BeginSettingsThread,
            PChar(GetEnvironmentVariable('DIR_CONFPATH'))
        );
    end;

    if ParamCount > 0 then
    bg
        cc.custcustapp.OptionHandler := @OptionParser;
        cc.custcustapp.Start;
    ed;

    RegexPrepare;
    RegexCheck;

    if Length(cc.custcustapp.NonOptions) = 0 then
        ListItems('.')
    else
    	specialize TTypeHelper<string>.ArrayForEach(
            cc.custcustapp.NonOptions,
            @ListItems
        );
end.
