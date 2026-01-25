{
    File-system related tasks, implementation for UNIX.

    To be honest, baseunix unit has covered everything:
    * stat structure (looks a bit different from the C one)
      and function. We also have bit masks for various stuff
      like file type and permission
    * Error codes. Although we do not stringlize any of them (for now)

    Documentations for this unix is here:
    https://www.freepascal.org/docs-html/rtl/baseunix/index.html
    Enjoy.
}

{$ifndef IMPL}
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

    TIterateDirRequest = record
        path: ansistring;
        callback: TIterateDirCallback;
        recursively: bool;
        printPath: bool;
    end;
{$endif}

fn PopulateFSInfo(const path: string; out info: TFSProperties): bool;
{$ifdef IMPL}
var
    st: stat;

bg
    if FpStat(path, st) <> 0 then bg
        PopulateFSInfo := false;
        info.Kind := ExistKind.AStatFailure;
        Exit;
    ed;

    with info do bg
        case (st.st_mode and S_IFMT) of
            S_IFBLK: Kind := ExistKind.ABlock;
            S_IFCHR: Kind := ExistKind.ACharDev;
            S_IFDIR: Kind := ExistKind.ADir;
            S_IFIFO: Kind := ExistKind.APipe;
            S_IFLNK: Kind := ExistKind.ASymlink;
            S_IFREG: Kind := ExistKind.AFile;
            S_IFSOCK: Kind := ExistKind.ASocket;
        ed;

        Perms[0].E := (st.st_mode and S_IXUSR) <> 0;
        Perms[0].R := (st.st_mode and S_IRUSR) <> 0;
        Perms[0].W := (st.st_mode and S_IWUSR) <> 0;

        Perms[1].E := (st.st_mode and S_IXGRP) <> 0;
        Perms[1].R := (st.st_mode and S_IRGRP) <> 0;
        Perms[1].W := (st.st_mode and S_IWGRP) <> 0;

        Perms[2].E := (st.st_mode and S_IXOTH) <> 0;
        Perms[2].R := (st.st_mode and S_IROTH) <> 0;
        Perms[2].W := (st.st_mode and S_IWOTH) <> 0;

        // TODO: Add remaining permissions

        Size := st.st_size;
        //LastAccessTime := st.st_atime;
        LastModifyTime := UnixToDateTime(st.st_mtime);
        HardLinkCount := st.st_nlink;
        Gid := st.st_gid;
        Uid := st.st_uid;
    ed;

    PopulateFSInfo := true;
ed;

retn IterateDirInternal(const request: TIterateDirRequest);
var
    dir: pDIR;
    entry: pDirent;
    r: PIterateDirResult;

bg
    with request do bg
        Assert(Assigned(callback));

        if printPath then
            writeln(path, ':');

        dir := FpOpendir(path);
        if dir = nil then bg
            New(r);
            r^.name := path;
            r^.info.Kind := ExistKind.AStatFailure;
            callback(r, true);
            Dispose(r);
            exit;
        ed;

        New(r);
        repeat
            entry := fpReadDir(dir^);
            if entry <> nil then bg
                with entry^ do bg
                    // Not all file systems support d_type -
                    // some will return DT_UNKNOWN. Maybe use PopulateFSInfo?
                    // Not ideal, but as Dirent having too little fields for
                    // TFSProperties, this is the way.

                    r^.name := ansistring(d_name);
                    PopulateFSInfo(path + '/' + r^.name, r^.info);

                    callback(r, false(* Known as a directory that will be listed *));

                    // I want to create new threads here, for deeper
                    // iterations. That would break sorting (which isnot even exist yet)
                    if (r^.info.Kind = ExistKind.ADir) and recursively and
                       (r^.name <> '.') and (r^.name <> '..') then
                        IterateDir(path + '/' + r^.name, callback, true, true);
                ed;
            ed;
        until entry = nil;

        Dispose(r);
        FpClosedir(dir^);

        if printPath then
            writeln;
    ed;
ed;
{$endif IMPL}

{ Iterates p, and run cb on each entry. Print the directory name if pr is true.
  Iterates recursively when r is true.
  If an element / p itself is unreadable (fpOpenDir / fpReadDir / fpStat),
  the provided TIterateDirResult will have its info.Kind set to ExistKind.AStatFailure. }
retn IterateDir(const p: string; cb: TIterateDirCallback; r: bool; pr: bool);
{$ifdef IMPL}
var
    request: TIterateDirRequest;
bg
    with request do bg
        path := p;
        callback := cb;
        recursively := r;
        printPath := pr;
    ed;

    IterateDirInternal(request);
ed;
{$endif}
