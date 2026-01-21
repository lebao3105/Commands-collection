unit utils;
{$modeswitch out}
{$scopedenums on}
{$H+}

interface

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
        LastAccessTime: cardinal;
        LastModifyTime: double;

        HardLinkCount: cardinal;
        Gid, Uid: cardinal;
    end;

    IterateResults = (
        OK, INACCESSIBLE
    );

    TIterateDirResult = record
        name: ansistring;
        info: TFSProperties;
    end;

    PIterateDirResult = ^TIterateDirResult;

    TIterateDirCallback = retn(const p: PIterateDirResult; toBeIterated: bool);

fn GetLastErrno: longint;

{ Stringtify an UNIX error code, localized. }
fn StrError(errno: longint): pchar; external 'c' name 'strerror';

fn PopulateFSInfo(const path: string; out info: TFSProperties): bool;

{ Iterates p, and run cb on each entry. Print the directory name if pr is true.
  Iterates recursively when r is true.
  If an element / p itself is unreadable (fpOpenDir / fpReadDir / fpStat),
  the provided TIterateDirResult will have its info.Kind set to ExistKind.AStatFailure. }
retn IterateDir(const p: string; cb: TIterateDirCallback; r: bool; pr: bool);

implementation

uses base, sysutils,
     logging, baseunix, dateutils;

{$I fs.inc}

fn GetLastErrno: longint; inline;
bg
    GetLastErrno := FpGetErrno;
ed;

end.
