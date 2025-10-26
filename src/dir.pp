program dir;
{$h+}

uses
    cthreads,
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
    showHidden: bool = false;
    showAsList: bool = false;
    dirOnly: bool = false;
    ignoreBackups: bool = false;

var
    rg: TRegExpr;
    filesCount: ulong = 0;
    filesSize: qword = 0;
    hiddenCount: longword = 0;
    count: longint = 0;

fn ShowDirEntry(p: pointer): ptrint;
var r: PIterateDirResult;
bg
    r := PIterateDirResult(p);
    if r^.status <> IterateResults.OK then exit; // TODO

    if r^.info.Kind <> ExistKind.ADir then
    bg
        if dirOnly then exit;
        InterLockedIncrement(filesCount);
        Inc(filesSize, r^.info.Size);
    ed;

    if (not showHidden) and StartsStr('.', r^.name) then
    bg
        InterLockedIncrement(hiddenCount);
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

    ShowDirEntry := 0;
ed;

retn ListItems(path: string);
//var
//    statFailCount: uint16 = 0;

bg
    path := ExpandFileName(IncludeTrailingPathDelimiter(path));

    if High(custcustapp.NonOptions) > 1 then bg
        write(path); writeln(':');
    ed;

    case IterateDir(path, @ShowDirEntry) of
        INACCESSIBLE: bg
            error(path + ' is inaccessible.');
            writeln('Make sure that it either exists, is a directory, and you have enough permissions to read it.');
        ed;

        // TODO
        //STAT_FAILED: Inc(statFailCount);

        OK: bg
            Report(filesCount, count, hiddenCount, filesSize, dirOnly);
            filesCount := 0;
            count := 0;
            hiddenCount := 0;
            filesSize := 0;
        ed;
    end;

    if Assigned(rg) then rg.Free;
ed;

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

        'w': listFmt := ListingFormats.CMD;
        'u': listFmt := ListingFormats.GNU;
        'm': listFmt := ListingFormats.CC;
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
    if ParamCount = 0 then
    bg
        ListItems('.');
        exit;
    ed;

    MoreHelpFunction := @AdditionalHelpMessages;
    OptionHandler := @OptionParser;

    AddOption('l', 'list', '', 'Show the output as a list');
    AddOption('a', 'all', '', 'Show everything, including hidden stuff and folders');
    AddOption('c', 'color', '', 'Use colors in the output');
    AddOption('d', 'directory', '', 'Only show directories');
    AddOption('i', 'ignore', 'PATTERN', 'Ignore entities that match the specified pattern');
    AddOption('B', 'ignore-backups', '', 'Ignore entities that end with ~ OR .bak');
    AddOption('R', 'recursive', '', 'List stuff, recursively');

    AddOption('w', 'win-fmt', '', 'List directory content using Windows CMD''s dir format');
    AddOption('u', 'uni-fmt', '', 'List directory content using GNU coreutils format');
    AddOption('m', 'cmc-fmt', '', 'List directory content using CommandsCollection format');

    custcustapp.Start;

    for I := 0 to High(custcustapp.NonOptions) do
        listitems(custcustapp.NonOptions[I]);
end.
