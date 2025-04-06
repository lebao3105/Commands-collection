program chk_type;
{$h+}
uses 
    sysutils, logging;
var
    n : integer;

procedure get_date(where: string);
// from freepascal's wiki
var
    s : TDateTime;
    fa : longint;
begin
    fa := FileAge(where);
    if fa <> -1 then
        s := FileDateToDateTime(fa);
        writeln('* Last modified on: ', DateTimeToStr(s), ';');
end;

procedure check_type(path: string);
var
    value_type : longint;
    isDir: boolean;

begin
    if FileExists(path) then
        isDir := false
    else if DirectoryExists(path) then
        isDir := true
    else
        die(path + ' does not exist. Quitting.');

    value_type := FileGetAttr(path);
    if value_type <> -1 then
    begin
        writeln(path, ' is: ');

        get_date(path);

        if (value_type and faReadOnly) <> 0 then
            writeln('* Readonly;');
        
        if (value_type and faHidden) <> 0 then
            writeln('* Hidden;');

        if isDir then
            writeln('* A directory;')
        else begin
            {$ifdef win32}
            if (value_type and faSysfile) <> 0 then
                writeln('* A system file. Be careful with it;');
            {$endif}
            
            if (value_type and faSymLink) <> 0 then
                writeln('* A sym(bolic)link;');

            if (value_type and faArchive) <> 0 then
                writeln('* An archive;');
        end;
    end
    else writeln('An error occured while checking the file!');
end;

begin
    if ParamCount = 0 then
        writeln('Missing argument. Exiting.')
    else
        for n := 1 to ParamCount do begin
            check_type(ParamStr(n));
            writeln;
        end;
end.
