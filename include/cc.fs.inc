type
	EFSEntityKind = (
	    AFile = 0, ADir, ASymlink,
	    ASocket, ABlock, APipe, ACharDev,
	    AStatFailure
	);
	TFSPermissions = record
	    E, R, W: bool;
	    S, // sticky
	    SU, // set-uid: run with the owner's UID
	    SG (*set-gid: run with the owner's GID*): bool
	end;

	TFSProperties = record
	    // index 0: owner
	    //       1: group
	    //       2: others
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

fn PopulateFSInfo(const path: string; out info: TFSProperties): bool;

{ Iterates p, and run cb on each entry. Print the directory name if pr is true.
  Iterates recursively when r is true.
  If an element / p itself is unreadable (fpOpenDir / fpReadDir / fpStat),
  the provided TIterateDirResult will have its info.Kind set to EFSEntityKind.AStatFailure. }
retn IterateDir(const p: string; cb: TIterateDirCallback; r: bool; pr: bool);