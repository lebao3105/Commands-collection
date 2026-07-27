program dir;
{$modeswitch result}
{$modeswitch anonymousfunctions}

uses
    // classes,
    sysutils,
    small.arr,
    small.base,
    small.getopts,
    small.logging,
    small.regex,
    small.fs,
    i18n,
    dir.dsl,
    dir.presets,
    dir.report,
    dir.dsl.cols,
    dir.dsl.ignore
    ;

var
    recursively: bool = false;
    addFooter: bool = false;

retn ShowDirEntry(const name: string; const p: TFSProperties);
begin
    if RegexIsMatched(name) then
    begin
        inc(ignoredCount);
        return;
    end;

    case p.Kind of
    	EFSEntityKind.StatFailure:
	    begin
	        Inc(statFailCount);

	        if ColumnsEnabled then
	            writeln(Format(STAT_FAILED, [ name, GetLastStrErrno ]))
	        else
	            write(Format('%s(E %d)', [ name, GetLastErrno ]));

	        exit;
	    end;

		EFSEntityKind.Folder:
			Inc(dirCount);

        otherwise if (IgnoreFlags and IGNORE_DIRS) <> 0 then
        begin
            inc(ignoredCount);
            return;
        end;
    end;

    Inc(count);

    PrintObjectName(name, p);
end;

retn ListItems(path: TFSProperties);
var s, s2: string;
    d: TFSProperties;
    l: array of TFSProperties;
    // l: TStringList;
begin
    // l := TStringList.Create();
    if path.Kind <> FOLDER then return;

    currentPath := path.Path;
    if recursively then
        writeln(path.Path + ':');

    for s in path.GetDirEnumerator do begin
        // l.Add(s);
        s2 := IncludeTrailingPathDelimiter(path.Path) + s;
        d := TFSProperties.Create(s2, ColumnsEnabled);
        if recursively and (d.Kind = FOLDER) and (s <> '.') and (s <> '..') then
            specialize ArrayAppend<TFSProperties>(l, d);
        ShowDirEntry(s, d);
    end;

    // l.Sort;
    // for s in l do
    //     writeln(s);
    // l.Free;
    writeln;
    if addFooter then
        Report;

    if recursively then
    begin
        writeln;
        specialize ArrayForEach<TFSProperties>(l, @ListItems);
    end;
end;

retn ReadSettingsFromFile;
var setting_file: string;
begin
    setting_file := GetEnvironmentVariable('DIR_CONF');
    if FileExists(setting_file) then
    begin
        debug('DIR_CONF =' + setting_file);
        DSL_init;
        DSL_cols_init;
        DSL_ignore_init;
        DSL_run_file(setting_file);
        DSL_deinit;
    end;
end;

begin
    ReadSettingsFromFile;

    small.getopts.OptCharHandler := retn (const found: char)
    begin
        case found of
            'a': IgnoreFlags := IgnoreFlags and not IGNORE_HIDDEN;
            'c': TODO;
            'd': IgnoreFlags := IgnoreFlags or IGNORE_DIRS;
            'i': RegexAppendExpr(small.getopts.OptArg);
            'l': ColumnsEnabled := true;
            'r': addFooter := true;
            'u': IgnoreFlags := IgnoreFlags or IGNORE_UNMATCH;
            'B': IgnoreFlags := IgnoreFlags or IGNORE_BACKUPS;
            'R': recursively := true;
        end;
    end;
    small.getopts.GetOpt;
    RegexPrepare;

    // Note for runs using xmake r: xmake sets
    // the working directory to where the exe is
    if Length(small.getopts.NonOpts) = 0 then
        ListItems(TFSProperties.Create(GetCurrentDir))
    else
       	specialize ArrayForEach<string>(
            small.getopts.NonOpts,
            retn(path: string)
            begin
                ListItems(TFSProperties.Create(path));
            end
        );
end.
