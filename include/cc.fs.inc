unit cc.fs;
{<
    File system-related tasks:
    * (Recursively or not) iterate directories
    * stat() an entity (a file / folder / etc)
}

{$modeswitch out}

interface

type
	{ Enum of file system entity types. }
	EFSEntityKind = (
	    AFile = 0, ADir, ASymlink,
	    ASocket, ABlock, APipe, ACharDev,
	    AStatFailure
	);

	{ Record of file system entity permissions. }
	TFSPermissions = record
	    E: bool; //< Executable permission
		R: bool; //< Read permission
		W: bool; //< Write permission
	    S: bool; //< Sticky (only owner and root can rename/delete)
	    SU:bool; //< set-uid: run with the owner's UID
	    SG:bool; //< set-gid: run with the owner's GID
	end;

	{ File system entity properties. }
	TFSProperties = record
	    { Entity's permissions.
		  0st index: Owner
		  1st index: Groups
		  2nd index: Others }
	    Perms: array[0..2] of TFSPermissions;

	    Kind: EFSEntityKind;
	    Size: qword;

	    LastAccessTime: cardinal;
	    LastModifyTime: double;

	    HardLinkCount: cardinal;
	    Gid, Uid: cardinal;
	end;

	EIterateResults = (
	    OK, INACCESSIBLE
	);

	TIterateDirResult = record
	    name: ansistring;
	    info: TFSProperties;
	end;

	PIterateDirResult = ^TIterateDirResult;

	TIterateDirCallback = retn(const p: PIterateDirResult; toBeIterated: bool);

    TIterateDirRequest = record
        path: ansistring;
        callback: TIterateDirCallback;
        recursively: bool;
        printPath: bool;
    end;

{ Reads path, and write its attributes into info.
  Returns a boolean indicating whether the operation succeed or not. }
fn PopulateFSInfo(const path: string; out info: TFSProperties): bool;

{ Iterates p, and run cb on each entry. Print the directory name if pr is true.
  Iterates recursively when r is true.
  If an element / p itself is unreadable (fpOpenDir / fpReadDir / fpStat),
  the provided TIterateDirResult will have its info.Kind set to EFSEntityKind.AStatFailure. }
retn IterateDir(const p: string; cb: TIterateDirCallback; r: bool; pr: bool);
