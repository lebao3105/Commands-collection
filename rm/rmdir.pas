program rmdirl;

uses
    sysutils{, warn};

var 
    value_type: longint;
    i : integer;

begin
    {if ParamCount = 0 then missing_dir()
     else } 
        for i := 1 to ParamCount do
            value_type := FileGetAttr(ParamStr(i));
            if value_type <> -1 then
                if (value_type and faDirectory) <> 0 then
                  begin
                    if (value_type and faReadOnly) <> 0 then
                        writeln('The target folder is readonly.')
                    else
                        RmDir(ParamStr(i));
                        writeln('Done.');   
                  end
                  else 
                    writeln('This is not a directory. Exiting.');
end.