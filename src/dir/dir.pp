program dir;
{$modeswitch anonymousfunctions}

uses
    {$ifdef FPC_DOTTEDUNITS}
        {$ifdef UNIX}
    system.cmem, unixapi.cthreads,
    system.clocale,
        {$endif}
    system.sysutils,
    system.regexpr,
    {$else}
        {$ifdef UNIX}
    cmem, cthreads, clocale,
        {$endif}
    sysutils, regexpr,
    {$endif}
    cc.base,
    cc.getopts,
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
           	FatalAndTerminate(1, REGEX_FAILED, [RegexGetExpr, check.GetError.Message])
        else
        	exit(check.GetOK);
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
    if not Settings.UseLists then
    begin
        PrintObjectName(r^.name, r^.info);
        WriteSp;
    end

    // Detailed list
    else PrintObjectName(r^.name, r^.info);
end;

retn ListItems(const path: string); inline;
begin
    IterateDir(path, @ShowDirEntry, Settings.Recursively,
               (High(cc.getopts.NonOpts) > 1) or Settings.Recursively);
    Report;
end;

begin
    case StrLowerCase(GetEnvironmentVariable('DIR_PRESET')) of
        'win': dir.settings.Settings := WIN_PRESET;
        'gnu': dir.settings.Settings := GNU_PRESET;
        'ccd': dir.settings.Settings := CCD_PRESET;
    else
        dir.settings.Settings := CCD_PRESET;
    end;

    BeginSettingsThread(
        // @BeginSettingsThread,
        PChar(GetEnvironmentVariable('DIR_CONFPATH'))
    );

    cc.getopts.OptCharHandler := retn (found: char)
    begin
        case found of
            'l': Settings.UseLists := true;
            'a': Settings.IgnoreHiddens := false;
            'c': Settings.AddColors := true;
            'd': Settings.DirOnly := true;
            'i': RegexAppendExpr(cc.getopts.OptArg);
            'B': Settings.IgnoreBackups := true;
            'R': Settings.Recursively := true;
        end;
    end;
    cc.getopts.GetLongOpts;

    if Length(cc.getopts.NonOpts) = 0 then
        ListItems(GetCurrentDir)
    else
    	specialize TTypeHelper<string>.ArrayForEach(
            cc.getopts.NonOpts,
            @ListItems
        );
end.
