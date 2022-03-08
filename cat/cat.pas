program cat;
{$mode objFPC}
uses
 Sysutils, warn, crt;

var
  tfIn: TextFile;
  s: string;

label 
  readfile;
                                                                  
begin
   if ParamCount = 1 then begin
   if ParamStr(1) = 'help' then help()
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
  if ParamCount = 0 then help();
end.
