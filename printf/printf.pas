program printf;
{$mode objFPC}
uses 
     sysutils, crt, color, warn;
var 
     target:TextFile;
     i:longint;

label 
	help;

begin
	help: begin
		writeln('Usage: printf [string] --target [file]');
		writeln('Append texts to a file.');
		writeln('The file must be exist, or the program will throw error.');
		missing_argv();
		halt(1);
	end;

    if (ParamCount < 3) then goto help
	else
		if ParamCount >= 3 then begin
		 if ParamStr(ParamCount) = '' then 
		 	begin 
				missing_file(); 
				exit; 
			end
         else if (ParamStr(ParamCount) = '--target') then 
			begin 
				missing_file(); 
			  	exit; 
			end
		 else begin 
		 AssignFile(target, ParamStr(ParamCount));
		 try 
		    append(target);
		    for i := 1 to (ParamCount - 2) do begin
		    	write(target, ParamStr(i), ' '); end;
		    	CloseFile(target);
		 except
		 	on E: EInOutError do begin
		 		writeln('Error(s) occured while we edit the file.');
		 		write('Details: ');writeln(E.Message);
				CloseFile(target);
			end;
 		 end;
		 	writeln('File ', ParamStr(ParamCount), ' editted.'); exit;
		 end; 
	end;
end.
