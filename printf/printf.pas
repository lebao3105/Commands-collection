program printf;
uses 
     sysutils,crt,utils;
var 
     target:TextFile;
     i:longint;
label help;
begin
    if ParamCount = 0 then goto help;
	if ParamCount >= 3 then begin
		 if ParamStr(ParamCount) = '' then begin writeln('Target file not found. Exitting.'); exit; end
                 else if (ParamStr(ParamCount) = '--target') then begin writeln('Target file not found. Exitting.'); exit; end
		 else begin 
		 AssignFile(target, ParamStr(ParamCount));
		 try 
		    append(target);
            write(target);
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
        if ParamStr(1) = 'help' then goto help;
        help:
        begin
            textgreen('printf version 1.0 '); TextColor(White); writeln('by Le Bao Nguyen');
            writeln('This program a part of the "cmd" collection, which is released under');
            writeln('the GNU V3 License.');
            textgreenln('Usage:'); TextColor(White);
            writeln('help:                           Show this help. If you use printf without these tags');
            writeln('                                the program still show this help.');
            writeln('(filename)                      Replace (filename) with your own file name and printf');
            writeln('                                will edit it for you.');
            exit;
        end;
end.
