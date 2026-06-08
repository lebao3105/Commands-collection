unit cc.idcache;
{<
    Database of users & groups.
    Known and implemented thanks to the GNU ls source code.
}

{$ifdef HAIKU}
{$error Unsupported unit on Haiku OS}
{$endif}

{$modeswitch result}
{$modeswitch anonymousfunctions}
{$modeswitch advancedrecords}

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
