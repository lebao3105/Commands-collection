program dir;
{$modeswitch result}
{$modeswitch anonymousfunctions}

uses
    sysutils,
    small.arr,
    small.base,
    small.getopts,
    small.regex,
    small.fs,
    small.i18n,
    dir.presets, // Preset from environment variable
    dir.report,
    dir.dsl,
    dir.dsl.cols,
    dir.dsl.ignore
    ;

var
    recursively: bool = false;
    addFooter: bool = false;

procedure ShowDirEntry(const name: string; const p: TFSProperties);
begin
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

procedure ListItems(path: TFSProperties);
var s, s2: string;
    d: TFSProperties;
    l: array of TFSProperties;
begin
    if path.Kind <> FOLDER then return;

    if RegexIsMatched(path.Name) then
    begin
        inc(ignoredCount);
        return;
    end;

    currentPath := path.Path;
    if recursively then
        writeln(path.Path + ':');

    for s in path.GetDirEnumerator do
    begin
        if RegexIsMatched(s) then
        begin
            inc(ignoredCount);
            continue;
        end;

        s2 := IncludeTrailingPathDelimiter(path.Path) + s;
        d := TFSProperties.Create(s2, ColumnsEnabled);
        if recursively and (d.Kind = FOLDER) and (s <> '.') and (s <> '..') then
            specialize ArrayAppend<TFSProperties>(l, d);
        ShowDirEntry(s, d);
    end;

    writeln;
    if addFooter then
        Report;

    if recursively then
    begin
        writeln;
        specialize ArrayForEach<TFSProperties>(l, @ListItems);
    end;
end;

begin
    small.getopts.OptCharHandler := procedure (const found: char)
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
    if Length(small.getopts.NonOpts) > 0 then
        specialize ArrayForEach<string>(
            small.getopts.NonOpts,
            procedure(path: string)
            begin
                ListItems(TFSProperties.Create(path));
            end
        )
    else
        ListItems(TFSProperties.Create(GetCurrentDir));
end.
