program printf;
uses 
     sysutils, crt, color, warn;
var 
     target:TextFile;
     i:longint;

label 
	help;

begin
    if ParamCount = 0 then help()
	else
		if ParamCount >= 3 then begin
		 if ParamStr(ParamCount) = '' then 
		 	begin 
				missing_file(); 
				exit; 
			end
         else 
		 	 if (ParamStr(ParamCount) = '--target') then 
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
		 		writeln('Error(s) occured while we editting the file.');
		 		write('Details: ');writeln(E.Message);
				CloseFile(target);
			end;
 		 end;
		 	writeln('File ', ParamStr(ParamCount), ' editted.'); exit;
		 end; 
	end;
        if ParamStr(1) = 'help' then help();
end.
