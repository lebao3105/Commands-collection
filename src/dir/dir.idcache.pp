unit dir.idcache;
{<
    Database of users & groups.
    Known and implemented thanks to the GNU ls source code.
}

{$modeswitch result}
{$modeswitch anonymousfunctions}
{$modeswitch advancedrecords}
{$goto on}

interface

uses
    ctypes,
    grp,
    pwd
    ;

type
    PCacheEntry = ^TCacheEntry;
    TCacheEntry = record
    public
        isGroup: bool;
        group: PGroup;
        user: PPasswd;

        fn GetName: string;
    end;

fn getpw(id: cuint32; isGroup: bool): PCacheEntry;

implementation

uses
    baseunix,
    sysutils,
    small.arr
    ;

var
    Cached: specialize TArray<TCacheEntry>;

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
