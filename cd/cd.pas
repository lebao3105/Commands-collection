{ This program is not working yet. 
  I think this program may work only if there are no other cd.}
program cd;
{$I-}
uses 
    utils, crt;
label 
    help;

begin
    if ParamCount = 0 then goto help;
    if ParamCount >= 1 then begin
        if ParamStr(1) = '' then begin writeln('Target folder not found. Exiting.'); exit end;
        if ParamStr(1) = 'help' then goto help
        else begin
            ChDir(ParamStr(1)); exit;
            if IOresult<>0 then
                Writeln ('Cannot change to directory : ',paramstr (1)); exit
        end;
    end;
    help:
        begin
            textgreen('cd version 1.0 '); TextColor(White); writeln('by Le Bao Nguyen');
            writeln('This program a part of the "cmd" collection, which is released under');
            writeln('the GNU V3 License.');
            textgreenln('Usage:'); TextColor(White);
            writeln('help                            Show this help. If you use cd without these tags');
            writeln('                                the program still show this help.');
            writeln('(dirname)                       Replace (dirname) with your own directory name and cd');
            writeln('                                will go to that folder for you.');
            exit;
        end;

end.
