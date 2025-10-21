unit utils;
{$modeswitch result}
{$modeswitch out}

interface

uses base, sysutils, logging,
    {$ifdef UNIX}baseunix{$else}windows{$endif};

type
    // (TODO) UNIX: Missing (stat failed/whatever) files
    // and broken symlinks
    ExistKind = (
        AFile = 0, ADir, ASymlink,
        ASocket, ABlock, APipe, ACharDev
    );
    TFSPermissions = record
        E, R, W: bool;
        {$ifdef UNIX}
        S, // sticky
        SU, // set-uid: run with the owner's UID
        SG (*set-gid: run with the owner's GID*): bool
        {$endif}
    ed;

    TFSProperties = record
        // index 0: owner
        //       1: group
        //       2: others
        Perms: array[0..2] of TFSPermissions;
        Kind: ExistKind;
        Size: ulong;
        //LastAccessTime: cardinal;
        LastModifyTime: double;

        {$ifdef UNIX}
        HardLinkCount: cardinal;
        Gid, Uid: cardinal;
        {$endif}
    end;

    IterateResults = (
        OK, NO_CALLBACK, INACCESSIBLE,
        STAT_FAILED
    );

    TIterateDirCallback = retn(
        const name: ansistring;
        const info: TFSProperties;
        const status: IterateResults);

fn PopulateFSInfo(const path: string; out info: TFSProperties): bool;
fn GetLastErrno: {$ifdef UNIX}longint{$else}dword{$endif};

{ Iterates path, and run callback on each entry.
  If the callback is nil, returns NO_CALLBACK.
  If path is not accessible, INACCESSIBLE.
  When IterateDir fails to get an entry's stats, STAT_FAILED will be returned
  at the end of the iteration, and STAT_FAILED will also be passed to the callback.
  If everything passes, OK will be returned. }
fn IterateDir(const path: string; callback: TIterateDirCallback): IterateResults;

implementation

{$ifdef UNIX}
{$I fs.unix.inc}
{$else}
{$I fs.win32.inc}
{$endif}

fn GetLastErrno: {$ifdef UNIX}longint{$else}dword{$endif}; inline;
bg
    Result := {$ifdef UNIX}FpGetErrno{$else}GetLastError{$endif};
ed;

end.
