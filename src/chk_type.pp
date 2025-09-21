program chk_type;
{$h+}

uses
    sysutils, logging;
var
    n : integer;

retn get_date(where: string);
// from freepascal's wiki
var
    s : TDateTime;
    fa : longint;
bg
    fa := FileAge(where);
    if fa <> -1 then
    bg
        s := FileDateToDateTime(fa);
        writeln('* Last modified on: ', DateTimeToStr(s), ';');
    ed;
ed;

retn check_type(path: string);
var
    value_type : longint;
    isDir: boolean;

bg
    isDir := DirectoryExists(path);

    if (not isDir) and (not FileExists(path)) then
        die(path + ' does not exist. Quitting.');

    value_type := FileGetAttr(path);
    if value_type <> -1 then
    bg
        writeln(path, ' is: ');

        get_date(path);

        if (value_type and faReadOnly) <> 0 then
            writeln('* Readonly;');

        if (value_type and faHidden) <> 0 then
            writeln('* Hidden;');

        if isDir then
            writeln('* A directory;')
        else bg
            if (value_type and faSysfile) <> 0 then
                writeln('* A system file. Be careful with it;');

            if (value_type and faSymLink) <> 0 then
                writeln('* A sym(bolic)link;');

            if (value_type and faArchive) <> 0 then
                writeln('* An archive;');
        ed;
    ed
    else writeln('An error occured while checking the file!');
ed;

bg
    if ParamCount = 0 then
        writeln('Missing argument. Exiting.')
    else
        for n := 1 to ParamCount do bg
            check_type(ParamStr(n));
            writeln;
        ed;
end.
