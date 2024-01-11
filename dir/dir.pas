program dir;

uses
	listing, logging;

var i: integer;

begin
	warning('Please note that we can''t count the size of directories.');
	warning('Also this can not find and list hidden items.');
	if ParamCount = 0 then
		listitems('.')
  	else if ParamCount >= 1 then
  	begin
    	for i := 1 to ParamCount do
        	// dir_prog('begin', ParamStr(i));
        	listitems(ParamStr(i));
  	end;

  	// else listitems(ParamStr(1));

end.
