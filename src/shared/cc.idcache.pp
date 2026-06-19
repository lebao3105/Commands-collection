{ SKIP windows haiku }
{$I cc.idcache.inc}
{$goto on}

implementation

uses
    baseunix,
    sysutils,
    cc.base
    ;

var
    Cached: specialize ArrayOf<TCacheEntry>;

fn TCacheEntry.GetName: string;
begin
	if isGroup then
		return(group^.gr_name)
	else
		return(user^.pw_name);
end;

fn AppendEntry(const id: cuint32; const isGroup: bool): TCacheEntry;
begin
    Result.isGroup := isGroup;

    if isGroup then
        Result.group := fpgetgrgid(id)
    else
        Result.user := fpgetpwuid(id);

    specialize ArrayAppend<TCacheEntry>(Cached, Result);
end;

fn getpw(id: cuint32; isGroup: bool): PCacheEntry;
var found: bool;
begin
    specialize ArrayForEach<TCacheEntry>(Cached, function(item: TCacheEntry): bool
    label ok;
    begin
		if item.isGroup <> isGroup then
    		return(false)
		else case item.isGroup of
    		true: if item.group^.gr_gid = id then
          		goto ok;
    		false: if item.user^.pw_uid = id then
        		goto ok;
		end;
	ok:
	    found := true;
		return(true);
	end);

	if not found then begin
		AppendEntry(id, isGroup);
		return(@Cached[High(Cached)]);
	end;
end;

end.
