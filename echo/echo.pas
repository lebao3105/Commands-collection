program echo;
//uses warn;

var 
  i : integer;
begin
  for i := 1 to ParamCount do 
    write(ParamStr(i), ' ');
    writeln();
end.

