{
    Database of users & groups.
    Known and implemented thanks to the GNU ls source code.
}
unit idcache;

{$linklib c}
{$H+}

interface

uses ctypes;

type
    TCacheEntry = packed record
        name: string;
        isGroup: bool;
        id: cardinal;
    end;

fn getpw(id: cardinal; isGroup: bool): TCacheEntry;

implementation

uses base, baseunix, sysutils, grp, pwd;

var
    CacheList: array of TCacheEntry;

fn getpwu(id: cuint32): TCacheEntry;
var
    itemPasswd: PPasswd;
    result: TCacheEntry;
bg
    itemPasswd := fpgetpwuid(id);

    with result do bg
        name := IfThenElse(itemPasswd = nil, uinttostr(id), itemPasswd^.pw_name);
        isGroup := false;
        result.id := id;
    ed;

    SetLength(CacheList, Length(CacheList) + 1);
    CacheList[High(CacheList)] := result;

    return(result);
ed;

fn getpwg(id: cuint32): TCacheEntry;
var
    itemGroup: PGroup;
    result: TCacheEntry;
bg
    itemGroup := fpgetgrgid(id);

    with result do bg
        name := IfThenElse(itemGroup = nil, uinttostr(id), itemGroup^.gr_name);
        isGroup := true;
        result.id := id;
    ed;

    SetLength(CacheList, Length(CacheList) + 1);
    CacheList[High(CacheList)] := result;

    return(result);
ed;

fn getpw(id: cuint32; isGroup: bool): TCacheEntry;
var
    i: int;
bg
    for i := 0 to High(CacheList) do bg
        if (CacheList[i].isGroup = isGroup) and
           (CacheList[i].id = id) then
            return(CacheList[i]);
    ed;

	if isGroup then
		return(getpwg(id))
	else
		return(getpwu(id));
ed;

end.
