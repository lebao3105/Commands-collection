program chk_type;
uses 
    sysutils;
var
    n : integer;

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
            if (value_type and faReadOnly) <> 0 then
                writeln('The file is read only. You should not touch to this file, except this is yours.');
            if (value_type and faHidden) <> 0 then
                //writeln('What a hidden file!'); // I don't want to have problems because of this
                writeln('The file is hidden.'); // simply use this
            if (value_type and faSysfile) <> 0 then
                writeln('This is a system file - you shouldnt touch to it.');
            if (value_type and faVolumeID) <> 0 then
                writeln('This is a disk label');
            If (value_type and faArchive) <> 0 then
                Writeln ('File is a archive.');
            If (value_type and faDirectory) <> 0 then
                Writeln ('This is a directory. Use dir <item name> to check if a file is a dir/dir is empty istead of using this program.');
        end
        else writeln('An error occured while checking the file!');
end;

begin
    if ParamCount = 0 then
        writeln('Missing argument. Exiting.')
    else for n := 1 to ParamCount do begin
        check_type(ParamStr(n));
    end;
end.
