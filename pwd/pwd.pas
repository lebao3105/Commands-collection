program pwd; // program to show the current directory
uses 
    sysutils, warn;
var 
    n : integer;
begin
    if ParamCount > 0 then
    for n := 1 to ParamCount do begin
        if ParamStr(n) = '--verbose' then
            writeln('pwd shows the current directory. And now its output is...')
        else if ParamStr(n) = '' then
            break
        else if ParamStr(n) = '--help' then
            help_prog();
    end;
        writeln(GetCurrentDir); // that's it
    exit;
end.
