unit cc.idcache;
{<
    Database of users & groups.
    Known and implemented thanks to the GNU ls source code.
}

{$ifdef HAIKU}
{$error Unsupported unit on Haiku OS}
{$endif}

{$modeswitch result}
{$modeswitch advancedrecords}

interface

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.ctypes,
    unixapi.grp,
    unixapi.pwd
    {$else}
    ctypes,
    grp,
    pwd
    {$endif}
    ;

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
