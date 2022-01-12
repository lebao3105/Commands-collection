{ This program is not working yet. 
  I think this program may work only if there are no other cd,
  or run it in "terminal mode" (I mean...TTY or a shell) }
program cd;
{$I-}
uses 
    utils, crt;

begin
    if ParamCount = 0 then writeln('Missing folder to change into it. Aborting'); exit;
    if ParamCount >= 1 then begin
        if ParamStr(1) = '' then begin writeln('Target folder not found. Exiting.'); exit end;
        else begin
            ChDir(ParamStr(1)); exit;
            if IOresult<>0 then
                Writeln ('Cannot change to directory : ',paramstr (1)); exit
        end;
    end;

end.
