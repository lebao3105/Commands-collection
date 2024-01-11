program touch;
{$mode objfpc}{$h+}
uses 
    logging,
    sysutils;

var 
    i : integer;
    haserrors: boolean; // not always we return code 0

begin
    if ParamCount = 0 then die('Missing arguments. Stop.')
    else
        for i := 1 to ParamCount do
            try
                FileCreate(ParamStr(i));
            except
                on E: Exception do begin
                    error('Failed to create ' + ParamStr(i) + ': ' + E.Message);
                    haserrors := true;
                end;
            end;
        if haserrors then halt(1);
end.