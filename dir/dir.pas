program dir;

uses
  listing, warn, verbose;

var i: integer;

begin
  if ParamCount = 0 then
  begin
    writeln('Usage: dir [directory]');
    missing_argv();
    halt(1);
  end
  
  else if ParamCount > 1 then
  begin
      for i := 1 to ParamCount do
        dir_prog('begin', ParamStr(i));
        listitems(ParamStr(i));
  end

  else listitems(ParamStr(1));

end.
