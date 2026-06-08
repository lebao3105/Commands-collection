{$I cc.idcache.inc}
{$goto on}

implementation

uses
    baseunix,
    sysutils
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
label
    bailOut;
begin
    New(Result);
    Result^.isGroup := isGroup;
    Result^.next := nil;

    if isGroup then begin
        Result^.group := fpgetgrgid(id);
        if Result^.group = nil then goto bailOut;
    end
    else begin
        Result^.user := fpgetpwuid(id);
        if Result^.user = nil then goto bailOut;
    end;

    if Cached <> nil then
    begin
    	tmp := Cached;
    	while tmp <> nil do
        begin
            if tmp^.next = nil then
            begin
                tmp^.next := Result;
                break;
            end;
            tmp := tmp^.next;
        end;
    end
    else
        Cached := Result;

bailOut:
    Dispose(Result);
    return(nil);
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
