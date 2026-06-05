program dir;
{$modeswitch result}
{$modeswitch anonymousfunctions}

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.sysutils,
    {$else}
    sysutils,
    {$endif}
    cc.base,
    cc.getopts,
    cc.logging,
    cc.regex,
    cc.fs,
    i18n,
    dir.report,
    dir.settings
    ;

retn ShowDirEntry(const r: PIterateDirResult);
begin
    if RegexHasMatches(r^.name) then
    begin
        inc(ignoredCount);
        return;
    end;

    case r^.info.Kind of
    	EFSEntityKind.StatFailure:
	    begin
	        Inc(statFailCount);

	        if Settings.UseLists then
	            writeln(Format(STAT_FAILED, [ r^.name, GetLastStrErrno ]))
	        else
	            write(Format('%s(E %d)', [ r^.name, GetLastErrno ]));

	        exit;
	    end;

		EFSEntityKind.Dir:
			Inc(dirCount);

		else if Settings.DirOnly then exit;
    end;

    Inc(count);

    PrintObjectName(r^.name, r^.info);
end;

retn ListItems(const path: string);
begin
    IterateDir(path, @ShowDirEntry, Settings.Recursively,
               (Length(cc.getopts.NonOpts) > 1) or Settings.Recursively);
    writeln;
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

    cc.getopts.OptCharHandler := retn (const found: char)
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
    cc.getopts.GetOpt;
    RegexPrepare;
    ReadSettingsFromFile;

    if Length(cc.getopts.NonOpts) = 0 then
        ListItems(GetCurrentDir)
    else
       	specialize ArrayForEach<string>(
            cc.getopts.NonOpts,
            fn (where: string): bool
            begin
                ListItems(where);
                Result := false;
            end
        );
end.
