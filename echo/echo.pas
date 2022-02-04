program echo;
var i:integer;
 begin
 	if ParamCount = 0 then begin
 		writeln(); exit; end;
 	if ParamCount >= 1 then begin
 		for i := 1 to ParamCount do
 			write(ParamStr(i), ' ');
 			writeln();
 			exit;
 		end;
 end. 	
