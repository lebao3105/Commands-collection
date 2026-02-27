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
    cc.regex,
    cc.fs,
    dir.report,
    dir.settings
    ;

retn ShowDirEntry(const r: PIterateDirResult; knownAsDir: bool);

    fn IsNameInvalid: bool;
    var check: specialize TResult<bool, ERegExpr>;
    begin
    	check := RegexHasMatches(r^.name);
     	if check.IsError then
           	FatalAndTerminate(1, REGEX_FAILED, [RegexGetExpr, check.Error.Message])
        else
        	exit(check.Value);
    end;

begin
    if IsNameInvalid then exit;

    case r^.info.Kind of
    	EFSEntityKind.AStatFailure:
	    begin
	        Inc(statFailCount);

	        // if knownAsDir then begin
	        //     Error(OPEN_DIR_FAILED, @r^.name, @StrError(GetLastErrno));
	        //     writeln;
	        //     exit;
	        // end;

	        if Settings.UseLists then
	            writeln(Format(STAT_FAILED, [ r^.name, StrError(GetLastErrno) ]))
	        else
	            write(Format('%s(E %d)', [ r^.name, GetLastErrno ]));

	        exit;
	    end;

		EFSEntityKind.ADir:
			Inc(dirCount);

		else begin
			if Settings.DirOnly then exit;
			Inc(filesSize, r^.info.Size);
    	end;
    end;

    Inc(count);

    // Name-only list
    if not Settings.UseLists then begin
        PrintObjectName(r^.name, r^.info);
        WriteSp;
    ed

    // Detailed list
    else PrintObjectName(r^.name, r^.info);
end;

retn ListItems(const path: string); inline;
begin
    IterateDir(path, @ShowDirEntry, Settings.Recursively,
               (High(cc.custcustapp.NonOptions) > 1) or Settings.Recursively);
    Report;
end;

retn OptionParser(found: char);
begin
    case found of
        'l': Settings.UseLists := true;
        'a': Settings.IgnoreHiddens := false;
        'c': Settings.AddColors := true;
        'd': Settings.DirOnly := true;
        'i': RegexAppendExpr(GetOptValue);
        'B': Settings.IgnoreBackups := true;
        'R': Settings.Recursively := true;
    end;
end;

fn RegexCheck: bool;
var
    checkr: specialize TResult<bool, ERegExpr>;
begin
    if RegexGetExpr = '' then
        return(true);
    
    checkr := RegexVerifyExpr;
    if not checkr.IsError then
        return(checkr.Value);
    
    FatalAndTerminate(
        1,
        REGEX_FAILED_LOC,
        [RegexGetLastError, RegexGetLastCompileErrorPos]
    );
end;

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

    cc.custcustapp.OptionHandler := @OptionParser;
    cc.custcustapp.Start;

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
