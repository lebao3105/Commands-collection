program echo;
//uses warn;

var 
  i, u : integer;
begin
  for i := 1 to ParamCount do 
    write(ParamStr(i), ' ');
    writeln();
end.

