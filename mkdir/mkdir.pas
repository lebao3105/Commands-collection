program mkdir;

uses 
    sysutils, crt, color, warn;
var 
    n : integer;

begin
    if ParamCount = 0 then missing_dir()
    else   
    for n := 1 to ParamCount do begin
        if not DirectoryExists(ParamStr(n)) then
            if not CreateDir (ParamStr(n)) then begin
                textred('Failed to create directory !');
                exit; end
            else begin
                writeln('Directory ', ParamStr(n), ' created.');
                exit; 
            end
        else begin
            textred('Fatal: '); TextColor(LightGray); 
            writeln('Directory ', ParamStr(n), 'exists!');
        end;
    end;
end.
