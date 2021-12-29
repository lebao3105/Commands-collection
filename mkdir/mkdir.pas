program mkdir;
uses sysutils, utils, crt;
label help;
begin
    if ParamCount = 0 then goto help;
    if ParamCount >= 1 then begin 
        if ParamStr(1) = '' then goto help;
        if ParamStr(1) = 'help' then goto help
        else begin 
            If Not DirectoryExists(ParamStr(1)) then
                If Not CreateDir (ParamStr(1)) Then begin
                    textred('Failed to create directory !');
                    exit; end
                else
                    Write('Directory ', ParamStr(1), ' created.');
                    exit;
            end; 
    end;  
    help:
        begin
            textgreen('mkdir version 1.0 '); TextColor(White); writeln('by Le Bao Nguyen');
            writeln('This program a part of the "cmd" collection, which is released under');
            writeln('the GNU V3 License.');
            textgreenln('Usage:'); TextColor(White);
            writeln('help:                     Show this help. If you use mkdir without these tags');
            writeln('                                the program still show this help.');
            writeln('(dirname)                       Replace (dirname) with your own directory name and mkdir');
            write('                                will create it for you.');
            exit;
        end;
end.
