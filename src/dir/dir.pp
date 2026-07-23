program dir;
{$modeswitch result}
{$modeswitch anonymousfunctions}

uses
    // classes,
    sysutils,
    small.base,
    small.getopts,
    small.logging,
    small.regex,
    small.fs,
    i18n,
    dir.report,
    dir.settings,
    dir.dsl.cols
    ;

retn ShowDirEntry(const name: string; const p: TFSProperties);
begin
    if RegexHasMatches(name) then
    begin
        inc(ignoredCount);
        return;
    end;

    case p.Kind of
    	EFSEntityKind.StatFailure:
	    begin
	        Inc(statFailCount);

	        if Settings.UseLists then
	            writeln(Format(STAT_FAILED, [ name, GetLastStrErrno ]))
	        else
	            write(Format('%s(E %d)', [ name, GetLastErrno ]));

	        exit;
	    end;

		EFSEntityKind.Dir:
			Inc(dirCount);

		else if Settings.DirOnly then exit;
    end;

    Inc(count);

    PrintObjectName(name, p);
end;

retn ListItems(const path: string);
var s: string;
    d: TFSProperties;
    // l: TStringList;
begin
    // l := TStringList.Create();
    d := TFSProperties.Create(path);
    for s in d.GetDirEnumerator do begin
        // l.Add(s);
        ShowDirEntry(s, TFSProperties.Create(s));
    end;
    // l.Sort;
    // for s in l do
    //     writeln(s);
    // l.Free;
    writeln;
    Report;
end;

begin
    case GetEnvironmentVariable('DIR_PRESET').ToLower of
        'win': dir.settings.Settings := WIN_PRESET;
        'gnu': dir.settings.Settings := GNU_PRESET;
        'ccd': dir.settings.Settings := CCD_PRESET;
    else
        dir.settings.Settings := CCD_PRESET;
    end;

    small.getopts.OptCharHandler := retn (const found: char)
    begin
        case found of
            'l': ColumnsEnabled := true;
            'a': Settings.IgnoreHiddens := false;
            'c': Settings.AddColors := true;
            'd': Settings.DirOnly := true;
            'i': RegexAppendExpr(small.getopts.OptArg);
            'B': Settings.IgnoreBackups := true;
            'R': Settings.Recursively := true;
        end;
    end;
    small.getopts.GetOpt;
    RegexPrepare;
    ReadSettingsFromFile;

    // Note for runs using xmake r: xmake sets
    // the working directory to where the exe is
    if Length(small.getopts.NonOpts) = 0 then
        ListItems(GetCurrentDir)
    else
       	specialize ArrayForEach<string>(
            small.getopts.NonOpts,
            fn (where: string): bool
            begin
                ListItems(where);
                Result := false;
            end
        );
end.
