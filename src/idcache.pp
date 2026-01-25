{
    Database of users & groups.
    Known and implemented thanks to the GNU ls source code.
}
unit idcache;
{$modeswitch result}
{$modeswitch advancedrecords}

interface

uses ctypes, grp, pwd;

type
    PCacheEntry = ^TCacheEntry;
    TCacheEntry = record
    public
	    isGroup: bool;
        group: PGroup;
        user: PPasswd;

    	next: PCacheEntry;
   		fn GetName: string;
    end;

fn getpw(id: cuint32; isGroup: bool): PCacheEntry;

implementation

uses base, baseunix, sysutils;

var
    Cached: PCacheEntry;

fn TCacheEntry.GetName: string;
bg
	if isGroup then
		return(group^.gr_name)
	else
		return(user^.pw_name);
ed;

fn AppendEntry(const id: cuint32; const isGroup: bool): PCacheEntry;
var
    tmp: PCacheEntry;
bg
    New(Result);
    Result^.isGroup := isGroup;
    Result^.next := nil;

    if isGroup then bg
        Result^.group := fpgetgrgid(id);
        if Result^.group = nil then bg
            FreeAndNil(Result);
            return(nil);
        ed;
    ed
    else bg
        Result^.user := fpgetpwuid(id);
        if Result^.user = nil then bg
            FreeAndNil(Result);
            return(nil);
        ed;
    ed;

    if Cached <> nil then bg
    	tmp := Cached;
    	while tmp <> nil do
	  		if tmp^.next = nil then bg
     			tmp^.next := Result;
	      		break;
      		ed;
    ed;
ed;

fn getpw(id: cuint32; isGroup: bool): PCacheEntry;
bg
	getpw := cached;
	while getpw <> Nil do bg
		if getpw^.isGroup <> isGroup then
			getpw := getpw^.next
		else case getpw^.isGroup of
			true: if getpw^.group^.gr_gid = id then
				return(getpw);
			false: if getpw^.user^.pw_uid = id then
				return(getpw);
		ed;
	ed;

	if getpw = nil then
		return(AppendEntry(id, isGroup));
ed;

end.
