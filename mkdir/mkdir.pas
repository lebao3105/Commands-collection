program mkdir;

uses 
    sysutils, crt, color, warn;
var 
    n : integer;

begin
    if ParamCount = 0 then missing_dir()
    else   
    for n := 1 to ParamCount do begin
        If Not DirectoryExists(ParamStr(n)) then
            If Not CreateDir (ParamStr(n)) Then begin
                textred('Failed to create directory !');
                exit; end
            else begin
                writeln('Directory ', ParamStr(n), ' created.');
                exit; 
            end
        else begin
            textred('Fatal: '); TextColor(White); 
            writeln('Directory ', ParamStr(n), 'exists!');
        end;
    end;
end.
