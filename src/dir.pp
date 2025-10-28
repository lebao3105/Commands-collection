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
    strutils, // EndsStr
    utils, // FS stat

    dir.report,
    dir.unix,
    dir.win32,
    dir.cc;

var
    showAsList: bool = false;
    recursively: bool = false;
    ignoreBackups: bool = false;
    rg: TRegExpr;

    // The rest are placed in dir.report.

retn ShowDirEntry(const r: PIterateDirResult; knownAsDir: bool);

    fn IsNameValid: bool;
    bg
        IsNameValid := false;

        if StartsStr('.', r^.name) then bg
            if showHidden then bg
            (*InterLocked*)Inc(*rement*)(hiddenCount);
                return(true);
            ed;
            exit;
        ed;

        if ignoreBackups and
           (EndsStr('~', r^.name) or EndsStr('.bak', r^.name)) then
            exit;

        try
            if Assigned(rg) and rg.Exec(r^.name) then
                exit;
        except
            // TODO
        end;

        IsNameValid := true;
    ed;

bg
    if r^.info.Kind = ExistKind.AStatFailure then
    bg
        (*InterLocked*)Inc(*rement*)(statFailCount);

        if IsNameValid then bg
            if knownAsDir then bg
                error(Format(OpenDirFailed, [ r^.name, StrError(GetLastErrno) ]));
                writeln;
                exit;
            ed;

            if showAsList then
                writeln(Format(StatFailed, [ r^.name, StrError(GetLastErrno) ]))
            else
                write(Format('%s(E %d)', [ r^.name, GetLastErrno ]));
        ed;
        exit;
    ed;

    if not IsNameValid then exit;

    if r^.info.Kind <> ExistKind.ADir then
    bg
        (*InterLocked*)Inc(*rement*)(filesCount);
        if dirOnly then exit;
        Inc(filesSize, r^.info.Size);
    ed;

    Inc(count);

    // Name-only list
    if not showAsList then bg
        PrintObjectName(r^.name, r^.info);
        WriteSp;
    ed

    // Detailed list
    else case listFmt of
        ListingFormats.GNU:
            dir.unix.PrintALine(r^.name, r^.info);
        ListingFormats.CC:
            dir.cc.PrintALine(r^.name, r^.info);
        ListingFormats.CMD:
            dir.win32.PrintALine(r^.name, r^.info);
    ed;
ed;

retn ListItems(path: string); inline;
{$define WantToPrintName:=(High(custcustapp.NonOptions) > 1) or recursively}
bg
    IterateDir(path, @ShowDirEntry, recursively, WantToPrintName);
    Report;
ed;
{$undef WantToPrintName}

retn OptionParser(found: char);
bg
    case found of
        'l': showAsList := true;
        'a': showHidden := true;
        'c': addColors := true;
        'd': dirOnly := true;
        'i': bg
            if rg = nil then
                rg := TRegExpr.Create;
            rg.Expression := GetOptValue;
        ed;
        'B': ignoreBackups := true;
        'R': recursively := true;

        'w': listFmt := ListingFormats.CMD;
        'u': listFmt := ListingFormats.GNU;
        'm': listFmt := ListingFormats.CC;
    ed;
ed;

retn OnExit;
bg
    if Assigned(rg) then rg.Free;
ed;

var
    I: int;

begin
    if ParamCount = 0 then
    bg
        ListItems('.');
        exit;
    ed;

    AddExitProc(@OnExit);

    OptionHandler := @OptionParser;

    AddOption('l', 'list', '', ListDes);
    AddOption('a', 'all', '', AllDes);
    AddOption('c', 'color', '', ColorDes);
    AddOption('d', 'directory', '', DirOnlyDes);
    AddOption('i', 'ignore', 'PATTERN', IgnoreDes);
    AddOption('B', 'ignore-backups', '', IgnoreBckDes);
    AddOption('R', 'recursive', '', RecursiveDes);

    AddOption('w', 'win-fmt', '', WinFmtDes);
    AddOption('u', 'gnu-fmt', '', GNUFmtDes);
    AddOption('m', 'cmc-fmt', '', CCFmtDes);

    custcustapp.Start;

    if Length(custcustapp.NonOptions) = 0 then
        ListItems('.')
    else
        for I := 0 to High(custcustapp.NonOptions) do
            listitems(custcustapp.NonOptions[I]);
end.
