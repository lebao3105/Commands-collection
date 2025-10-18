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

retn ListItems(path: string);
var
    filesCount: int = 0;
    filesSize: ulong = 0;
    hiddenCount: int = 0;
    count: ulong = 0;
    f: TSearchRec;
    props: TFSProperties;
    r: TRegExpr;

bg
    path := ExpandFileName(IncludeTrailingPathDelimiter(path));

    if nonOpts.Count > 1 then bg
        write(path); writeln(':');
    ed;

    if FindFirst(path + '*', faAnyFile, f) = 0 then
    bg
        if ignorePattern <> '' then bg
            r := TRegExpr.Create;
            r.Expression := ignorePattern;
        ed;

        {$define IS_DIR:=((Attr and faDirectory) = faDirectory)}
        {$define IS_HIDDEN:=((Attr and faHidden) = faHidden)}
        repeat
            with f do bg
                if not IS_DIR then bg
                    if dirOnly then continue;
                    Inc(filesCount);
                ed;

                if IS_HIDDEN then bg
                    if not showHidden then continue;
                    Inc(hiddenCount);
                ed;

                if ignoreBackups and EndsStr('~', Name) then continue;

                if Assigned(r) and r.Exec(Name) then continue;

                if not showHidden then bg
                    if (Name = '.') or (Name = '..') then
                        continue;
                ed;

                Inc(count);
                PopulateFSInfo(path + '/' + Name, props);
                filesSize += props.Size;

                // Name-only list
                if not showAsList then bg
                    PrintObjectName(Name, props);
                    WriteSp;
                ed

                // Detailed list
                else bg
                    PopulateFSInfo(path + '/' + Name, props);
                    filesSize += props.Size;

                    case listFmt of
                        ListingFormats.GNU:
                            dir.unix.PrintALine(Name, props);
                        ListingFormats.CC:
                            dir.cc.PrintALine(Name, props);
                        ListingFormats.CMD:
                            dir.win32.PrintALine(Name, props);
                    ed;
                ed;
            ed;
        until FindNext(f) <> 0;

        FindClose(f);
        r.Free;

        writeln;
        Report(filesCount, count, hiddenCount, filesSize, listFmt, dirOnly);
    ed

    else
        error('Unable to open directory ' + path + '!');
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
    AddOption('B', 'ignore-backups', '', 'Ignore entities that end with ~');

    AddOption('w', 'win-fmt', '', 'List directory content using Windows CMD''s dir format');
    AddOption('u', 'uni-fmt', '', 'List directory content using GNU coreutils format');
    AddOption('c', 'cmc-fmt', '', 'List directory content using CommandsCollection format');

    custcustapp.Start;

    nonOpts := GetNonOptions;
    if nonOpts.Count = 0 then
        listitems('./')
    else
        for I := 0 to nonOpts.Count - 1 do
            listitems(nonOpts[I]);
end.
