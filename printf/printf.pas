program printf;
{$mode objFPC}{$H+}
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
			case ParamStr(ParamCount) of
				'': begin 
					missing_file(); 
					halt(1); 
				end;
        		'--target': begin 
					missing_file(); 
			  		halt(1);
				end;
			else
		 		AssignFile(target, ParamStr(ParamCount));
				try 
		    		Append(target);
		    		for i := 1 to (ParamCount - 2) do
		    			write(target, ParamStr(i), ' ');
		    		CloseFile(target);
				except
					on E: EInOutError do begin
						writeln('Error(s) occured while we edit the file.');
						write('Details: ');writeln(E.Message);
						CloseFile(target);
				end;
 		 	end;
		 	writeln('File ', ParamStr(ParamCount), ' editted.');
		end; 
	end;
end.
