unit utils;
{$modeswitch result}
{$modeswitch out}
{$H+}

interface

uses base, sysutils, logging, baseunix;

type
    ExistKind = (
        AFile = 0, ADir, ASymlink,
        ASocket, ABlock, APipe, ACharDev,
        AStatFailure
    );
    TFSPermissions = record
        E, R, W: bool;
        S, // sticky
        SU, // set-uid: run with the owner's UID
        SG (*set-gid: run with the owner's GID*): bool
    ed;

    TFSProperties = record
        // index 0: owner
        //       1: group
        //       2: others
        Perms: array[0..2] of TFSPermissions;
        Kind: ExistKind;
        Size: qword;
        //LastAccessTime: cardinal;
        LastModifyTime: double;

        HardLinkCount: cardinal;
        Gid, Uid: cardinal;
    end;

    IterateResults = (
        OK, NO_CALLBACK, INACCESSIBLE,
        STAT_FAILED
    );

    TIterateDirResult = record
        name: ansistring;
        info: TFSProperties;
        status: IterateResults
    end;

    PIterateDirResult = ^TIterateDirResult;

fn PopulateFSInfo(const path: string; out info: TFSProperties): bool;
fn GetLastErrno: {$ifdef UNIX}longint{$else}dword{$endif};

{ Iterates path, and run callback on each entry.
  If the callback is nil, returns NO_CALLBACK.
  If path is not accessible, INACCESSIBLE.
  When IterateDir fails to get an entry's stats, STAT_FAILED will be returned
  at the end of the iteration, and STAT_FAILED will also be passed to the callback.
  If everything passes, OK will be returned. }
fn IterateDir(const path: string; callback: TThreadFunc): IterateResults;

implementation

{$I fs.inc}

fn GetLastErrno: longint; inline;
bg
    Result := FpGetErrno;
ed;

end.
