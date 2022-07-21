program rmdir;

uses
	sysutils, warn, color, crt;

var 
		value_type: longint;
		i : integer;

begin
		if ParamCount = 0 then missing_dir()
		else 
			for i := 1 to ParamCount do begin
				if not DirectoryExists(ParamStr(i))
				then begin
					// there may be many non-exist folders,
					// so we can't use not_a_dir function
					textredln('Directory not found or is not a directory: '+ ParamStr(i));
					TextColor(LightGray);
					halt(-1);
				end

				else begin
					value_type := FileGetAttr(ParamStr(i));
					while value_type <> -1 do begin
						if (value_type and faReadOnly) <> 0 then begin
							writeln('Target folder ' + ParamStr(i) + ' is read only.');
							halt(1);
						end
						else begin
							RmDir(ParamStr(i));
							writeln('Done.');
							halt(0);
						end;
					end;
				end;
			end;
end.