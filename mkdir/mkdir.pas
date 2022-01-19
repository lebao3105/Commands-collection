program mkdir;
uses sysutils, crt, utils;
label help;
var n: integer;
begin
    if ParamCount = 0 then goto help
    else  for n := 1 to ParamCount do begin 
        if ParamStr(n) = '--help' then goto help
        else begin 
            If Not DirectoryExists(ParamStr(n)) then
                If Not CreateDir (ParamStr(n)) Then begin
                    textred('Failed to create directory !');
                    exit; end
                else begin
                    Write('Directory ', ParamStr(n), ' created.');
                    exit; end
            else textred('Fatal: '); TextColor(White); writeln('Directory ', ParamStr(n), 'exists!');
        end; 
    end;  
    help:
        begin
            writeln('mkdir usage: mkdir <direcory name>');
            writeln('Use --help flag to print this help, however; you dont need to use this flag yet.');
            writeln('Exiting... Process exited with code 0 (success).');
            Delay(800);
            exit;
        end;
end.
