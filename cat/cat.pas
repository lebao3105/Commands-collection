program cat;
uses
 Sysutils, utils, crt;

var
  tfIn: TextFile;
  s: string;
label readfile, help;
begin
   if ParamCount = 1 then begin
   if ParamStr(1) = 'help' then goto help
   else begin
	readfile: begin
  		writeln('Reading the contents of file: ', ParamStr(1));
  		writeln('=========================================');
		  AssignFile(tfIn, ParamStr(1));
	// Embed the file handling in a try/except block to handle errors gracefully
  try
    // Open the file for reading
    	reset(tfIn);
    // Keep reading lines until the end of the file is reached
      while not eof(tfIn) do
        begin
          readln(tfIn, s);
          writeln(s);
      end;
      CloseFile(tfIn);

  except
    	on E: EInOutError do
     	    writeln('File handling error occurred. Details: ', E.Message);
 	    end;

  // Wait for the user to end the program
  	writeln('=========================================');
  	writeln('File ', ParamStr(1), ' was probably read. Press enter to stop.');
  	readln; end; end; end;
  if ParamCount = 0 then begin 
  	 help: begin
        textgreen('cat version 1.0'); TextColor(White); writeln('by Le Bao Nguyen');
        writeln('This program a part of the "cmd" collection, which is released under');
        writeln('the GNU V3 License.');
        textgreenln('Usage:');
        writeln('help:                     Show this help. If you use touch without these tags');
        writeln('                                 cat still show this help.');
        writeln('(filename)                       Replace (filename) with your own file name and touch');
        writeln('                                 will read it for you.');
        exit;
  end;
  end;
end.
