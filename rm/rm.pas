program rm;
uses Sysutils;
var i : integer;
begin
    for i := 1 to ParamCount do
        DeleteFile(ParamStr(i));
end.