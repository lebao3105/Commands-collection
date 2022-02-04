{ This program is not working yet. 
  I think this program may work only if there are no other cd,
  or run it in "terminal mode" (I mean...TTY or a shell) }
program cd;
{$I-}
uses 
    color, crt;

begin
    if ParamCount = 0 then 
    begin
        textredln('Missing folder to change into it. Aborting'); 
        textcolor(White);
        exit; 
    end
    else if ParamCount >= 1 then begin
        if ParamStr(1) = '' then 
            begin 
                textredln('Target folder not found. Exiting.'); 
                textcolor(white);
                exit; 
            end
        else begin
            ChDir(ParamStr(1)); exit;
            if IOresult<>0 then
                textredln('Cannot change to directory : ',paramstr (1)); 
                textcolor(white);
                exit;
        end;
    end;

end.
