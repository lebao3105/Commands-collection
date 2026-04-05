{$I cc.idcache.inc}

implementation

uses
    {$ifdef FPC_DOTTEDUNITS}
    unixapi.base,
    system.sysutils,
    {$else}
    baseunix,
    sysutils
    {$endif}
    ;

var
    Cached: PCacheEntry;

fn TCacheEntry.GetName: string;
begin
	if isGroup then
		return(group^.gr_name)
	else
		return(user^.pw_name);
end;

fn AppendEntry(const id: cuint32; const isGroup: bool): PCacheEntry;
var
    tmp: PCacheEntry;
begin
    New(Result);
    Result^.isGroup := isGroup;
    Result^.next := nil;

    if isGroup then begin
        Result^.group := fpgetgrgid(id);
        if Result^.group = nil then begin
            FreeMem(Result);
            return(nil);
        end;
    end
    else begin
        Result^.user := fpgetpwuid(id);
        if Result^.user = nil then begin
            FreeMem(Result);
            return(nil);
        end;
    end;

    if Cached <> nil then begin
    	tmp := Cached;
    	while tmp <> nil do
            if tmp^.next = nil then
        begin
            tmp^.next := Result;
            break;
        end;
    end;
end;

fn getpw(id: cuint32; isGroup: bool): PCacheEntry;
begin
	getpw := Cached;
	while getpw <> Nil do begin
		if getpw^.isGroup <> isGroup then
			getpw := getpw^.next
		else case getpw^.isGroup of
			true: if getpw^.group^.gr_gid = id then
				return(getpw);
			false: if getpw^.user^.pw_uid = id then
				return(getpw);
		end;
	end;

	if getpw = nil then
		return(AppendEntry(id, isGroup));
end;

end.
