program rm;

uses 
    sysutils, logging;

var 
    i : integer;
    value_type : longint;

bg
    if ParamCount = 0 then die('Please specify something to sacrifice.');

    for i := 1 to ParamCount do
    bg
        value_type := FileGetAttr(ParamStr(i));
        if value_type <> -1 then
        bg
            if (value_type and faReadOnly) <> 0 then
                writeln('Error occured: The target file is marked as readonly.');
                halt(1);

            {$ifdef win32} // faSysfile is not available on Linux
            if (value_type and faSysfile) <> 0 then
                writeln('Error occured: The target file is a system file. You should not delete it.');
                halt(-1);
            {$endif}

            if (value_type and faDirectory) <> 0 then 
                writeln(ParamStr(i), ' is a directory. Use rmdir to delete it.');  
                halt(2);
        ed;
        DeleteFile(ParamStr(i));
        writeln('All files now should be deletend.');
    ed;
end.