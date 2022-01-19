program mkdir;
uses sysutils, crt, utils;
label help;
begin
    if ParamCount = 0 then goto help
    else   
        if ParamStr(1) = '--help' then goto help
        else begin  
            If Not DirectoryExists(ParamStr(1)) then
                If Not CreateDir (ParamStr(1)) Then begin
                    textred('Failed to create directory !');
                    exit; end
                else begin
                    Write('Directory ', ParamStr(1), ' created.');
                    exit; end
            else textred('Fatal: '); TextColor(White); writeln('Directory ', ParamStr(1), 'exists!');
        end; 
    help:
        begin
            writeln('mkdir usage: mkdir <direcory name>');
            writeln('Use --help flag to print this help, however; you dont need to use this flag yet.');
            writeln('Sorry about that but mkdir can only create 1 folder at one time.');
            writeln('Exiting... Process exited with code 0 (success).');
            Delay(800);
            exit;
        end;
end.
