program touch;
uses
 Sysutils, utils, crt;
var
  tfIn: TextFile;
label createfile, help;
begin
   if ParamCount = 1 then begin
   if ParamStr(1) = 'help' then goto help
   else begin
    createfile: begin
        AssignFile(tfIn, ParamStr(1));
    // Embed the file handling in a try/except block to handle errors gracefully
    try
        rewrite(tfIn);
        CloseFile(tfIn);
    except
        on E: EInOutError do
        write('File handling error occurred. Details: ', E.Message);
    end;

  // Wait for the user to end the program
     writeln('File ', ParamStr(1), ' created.'); exit; end; end; end;
  if ParamCount = 0 then begin 
     help: begin
        textgreen('touch Usage: ');
        TextColor(White);
        writeln('touch <file name> : Create <file name> file. This program only can create one file at one time.');
        writeln('Exiting... Process will exit with code 0 (success).');
        Delay(800);
        exit;
  end;
  end;
end.
