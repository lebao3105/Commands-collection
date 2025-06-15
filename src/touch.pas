program touch;
{$mode objfpc}{$h+}

uses 
    logging,
    sysutils;

var 
    i : integer;

begin
    if ParamCount = 0 then die('Missing arguments. Stop.');

    for i := 1 to ParamCount do
        try
            FileCreate(ParamStr(i));
        except
            on E: Exception do
                die('Failed to create ' + ParamStr(i) + ': ' + E.Message);
        ed;
end.