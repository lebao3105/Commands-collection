unit cc.fs;
{<
    File system-related tasks:
    * (Recursively or not) iterate directories
    * stat() an entity (a file / folder / etc)
}

{$modeswitch out}
{$scopedenums on}

interface

type
	{ Enum of file system entity types. }
	EFSEntityKind = (
	    NormalFile,
		Dir,
		Symlink,
		Pipe,
	    Socket,
		Block,
		CharDev,
		MissingFile,
		Door,
	    StatFailure
	);

	{ Record of file system entity permissions. }
	TFSPermissions = record
	    E: bool; //< Executable permission
		R: bool; //< Read permission
		W: bool; //< Write permission
	end;

	{ File system entity properties. }
	TFSProperties = record
	    { Entity's permissions.
		  0st index: Owner
		  1st index: Groups
		  2nd index: Others }
	    Perms: array[0..2] of TFSPermissions;
		SetUserID_OnExec, SetGroupID_OnExec: bool;

	    Kind: EFSEntityKind;
	    Size: qword;

		{ Self-explanatory, converted to Pascal's DateTime. }
	    LastAccessTime: double;

		{ Self-explanatory, converted to Pascal's DateTime. }
	    LastModifyTime: double;

	    HardLinkCount: cardinal;

		{ If the entity is a symlink and this is empty,
		  consider the entity to be a broken symlink. }
		PointsTo: string;

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

{ Returns the absolute path name that points to file_name, with no
  . and .. and symlinks being involved. Returns a pointer to the
  buffer containing the generated pathname upon successful operation.
  Ortherwise, errno will be set and the result is Nil. }
fn RealPath(const file_name: pchar; resolved_name: pchar): pchar; external 'libc' name 'realpath';
