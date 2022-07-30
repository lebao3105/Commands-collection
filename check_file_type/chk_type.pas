program chk_type;
uses 
    sysutils;
var
    n : integer;

procedure get_date(filepath:string);
// referenced from freepascal's wiki
var
    s : TDateTime;
    fa : longint;
begin
    fa := FileAge(filepath);
    if fa <> -1 then
        s := FileDateToDateTime(fa);
        writeln('Last modification time: ', DateTimeToStr(s));
end;

procedure check_type(file_name : String);
var
    value_type : longint;
begin
    if not FileExists(file_name) then 
    begin
        if DirectoryExists(file_name) then
        begin
            writeln('This is a directory.');
            halt(0);
        end
        else begin
            writeln('File ', file_name, ' does not exist. Aborting.');
            halt(1);
        end;
    end
    else
    value_type := FileGetAttr(file_name);
    if value_type <> -1 then
        begin
            writeln('File ', file_name, ' checked. Here is the result: ');
            get_date(file_name);
            if (value_type and faReadOnly) <> 0 then
                writeln('The file is read only. You should not touch to this file, except this is yours.');
            if (value_type and faHidden) <> 0 then
                //writeln('What a hidden file!'); // I don't want to have problems because of this
                writeln('The file is hidden.'); // simply use this
            if (value_type and faSysfile) <> 0 then
                writeln('This is a system file - you shouldnt touch to it.');
            if (value_type and faSymLink) <> 0 then
                writeln('The file is a symlink to another item');
            If (value_type and faArchive) <> 0 then
                Writeln ('File is a archive.');
            If (value_type and faDirectory) <> 0 then
                Writeln ('This is a directory.');
        end
    else writeln('An error occured while checking the file!');
end;

begin
    if ParamCount = 0 then
        writeln('Missing argument. Exiting.')
    else
        for n := 1 to ParamCount do begin
            check_type(ParamStr(n));
        end;
end.
