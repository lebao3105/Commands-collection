program dir;
{$h+}

uses
    base,
    classes, // TStringList
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
    nonOpts: TStringList;
    showHidden: bool = false;
    showAsList: bool = false;
    dirOnly: bool = false;
    ignorePattern: string;
    ignoreBackups: bool = false;
    listFmt: ListingFormats = ListingFormats.{$ifdef UNIX}GNU{$else}CMD{$endif};

var
    r: TRegExpr;
    filesCount: uint16 = 0;
    filesSize: ulong = 0;
    hiddenCount: uint16 = 0;
    count: ulong = 0;

retn ShowDirEntry(
        const name: string;
        const info: TFSProperties;
        const status: IterateResults);
bg
    if status <> IterateResults.OK then exit; // TODO

    // NOT what Windows do (hides stuff with a dot as the prefix)
    {$ifdef UNIX}
    if (not showHidden) and StartsStr('.', name) then
        exit;
    {$endif}

    if ignoreBackups and (EndsStr('~', name) or EndsStr('.bak', name)) then
        exit;

    if Assigned(r) and r.Exec(name) then
        exit;

    if (info.Kind <> ExistKind.ADir) then
    bg
        if dirOnly then exit;
        Inc(filesCount);
        Inc(filesSize, info.Size);
    ed;

    Inc(count);

    // Name-only list
    if not showAsList then bg
        PrintObjectName(Name, info);
        WriteSp;
    ed

    // Detailed list
    else case listFmt of
        ListingFormats.GNU:
            dir.unix.PrintALine(Name, info);
        ListingFormats.CC:
            dir.cc.PrintALine(Name, info);
        ListingFormats.CMD:
            dir.win32.PrintALine(Name, info);
    ed;
ed;

retn ListItems(path: string);
//var
//    statFailCount: uint16 = 0;

bg
    path := ExpandFileName(IncludeTrailingPathDelimiter(path));

    if nonOpts.Count > 1 then bg
        write(path); writeln(':');
    ed;

    if (ignorePattern <> '') and (not Assigned(r))
    then bg
        r := TRegExpr.Create;
        r.Expression := ignorePattern;
    ed;

    case IterateDir(path, @ShowDirEntry) of
        INACCESSIBLE: bg
            error(path + ' is inaccessible.');
            writeln('Make sure that it either exists, is a directory, and you have enough permissions to read it.');
        ed;

        // TODO
        //STAT_FAILED: Inc(statFailCount);

        OK:
            Report(filesCount, count, hiddenCount, filesSize, listFmt, dirOnly);
    end;

    if Assigned(r) then r.Free;
ed;

retn OptionParser(found: char);
bg
    case found of
        'l': showAsList := true;
        'a': showHidden := true;
        'd': dirOnly := true;
        'i': ignorePattern := GetOptValue;
        'B': ignoreBackups := true;

        'w': listFmt := ListingFormats.CMD;
        'u': listFmt := ListingFormats.GNU;
        'c': listFmt := ListingFormats.CC;
    ed;
ed;

fn AdditionalHelpMessages: string;
bg
    AdditionalHelpMessages :=
        'If -l / --list is passed: this program will use the format ' +
        'that the current OS families most (GNU coreutils format on UNIX, ' +
        'Windows''s dir format on Windows).' + sLineBreak +

        'The last related flag will be used, e.g: -w -u will use Coreutils format.' +
        sLineBreak + sLineBreak + 'Directory sizes are not calculated.';
ed;

var
    I: int;

begin
    MoreHelpFunction := @AdditionalHelpMessages;
    OptionHandler := @OptionParser;

    AddOption('l', 'list', '', 'Show the output as a list');
    AddOption('a', 'all', '', 'Show everything, including hidden stuff and folders');
    AddOption('d', 'directory', '', 'Only show directories');
    AddOption('i', 'ignore', 'PATTERN', 'Ignore entities that match the specified pattern');
    AddOption('B', 'ignore-backups', '', 'Ignore entities that end with ~ OR .bak');

    AddOption('w', 'win-fmt', '', 'List directory content using Windows CMD''s dir format');
    AddOption('u', 'uni-fmt', '', 'List directory content using GNU coreutils format');
    AddOption('c', 'cmc-fmt', '', 'List directory content using CommandsCollection format');

    custcustapp.Start;

    nonOpts := GetNonOptions;
    if nonOpts.Count = 0 then
        listitems('.')
    else
        for I := 0 to nonOpts.Count - 1 do
            listitems(nonOpts[I]);
end.
