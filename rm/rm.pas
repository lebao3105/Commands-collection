program rm;

uses 
    Sysutils{, warn};

var 
    i : integer;
    value_type : longint;

begin
  // if ParamCount = 0 then missing_file(); 
   //else 
    for i := 1 to ParamCount do 
        value_type := FileGetAttr(ParamStr(i));
        if value_type <> -1 then
          begin
            if (value_type and faReadOnly) <> 0 then
                writeln('Error occured: The target file is marked as readonly.');
            if (value_type and faSysfile) <> 0 then
                writeln('Error occured: The target file is a system file. You should not delete it.');
            if (value_type and faDirectory) <> 0 then 
                writeln(ParamStr(i), ' is a directory. Use rmdir to delete it.');  
          end;
        DeleteFile(ParamStr(i));
        writeln('All files are should be deleted.');
end.