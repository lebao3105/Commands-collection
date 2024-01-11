program mkdir;

uses 
    sysutils, crt, color, logging;
var 
    n : integer;

begin
    // TODO: -v (verbose) and -p (create parent directory if able) flags
    if ParamCount = 0 then missing_dir()
    else   
    for n := 1 to ParamCount do begin
        if not DirectoryExists(ParamStr(n)) then
            try
                CreateDirectory(ParamStr(n));
            except
                on E: Exception do begin
                    die(Format('Unable to create %s: %s',
                               [ParamStr(n), E.Message]));
                end;
            end
        else
            die(ParamStr(n) + ' already exists');
    end;
end.
