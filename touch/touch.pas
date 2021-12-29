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
        textgreen('touch version 1.0 '); TextColor(White); writeln('by Le Bao Nguyen');
        writeln('This program is a part of the "cmd" collection, which is released under');
        writeln('the GNU V3 License.');
        textgreenln('Usage:'); TextColor(White);
        writeln('help                      Show this help. If you use touch without these tags');
        writeln('                                 the program still show this help.');
        writeln('(filename)                       Replace (filename) with your own file name and touch');
        writeln('                                 will create it for you.');
        exit;
  end;
  end;
end.
