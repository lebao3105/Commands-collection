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

uses dateutils;

{const
    DT_UNKNOWN = 0;
    DT_FIFO = 1;
    DT_CHR = 2;
    DT_DIR = 4;
    DT_BLK = 6;
    DT_REG = 8;
    DT_LNK = 10;
    DT_SOCK = 12;
    DT_WHT = 14;}

fn PopulateFSInfo(const path: string; out info: TFSProperties): bool;
var
    st: stat;
bg
    if FpStat(path, st) <> 0 then bg
        Result := false;
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

    Result := true;
ed;

fn IterateDir(const path: string; callback: TIterateDirCallback): IterateResults;
var
    dir: pDIR;
    entry: pDirent;
    p: TFSProperties;

bg
    if not Assigned(callback) then
        return(IterateResults.NO_CALLBACK);

    dir := FpOpendir(path);
    if dir = nil then
        return(IterateResults.INACCESSIBLE);

    Result := IterateResults.OK;

    repeat
        entry := fpReadDir(dir^);
        if entry <> nil then bg
            with entry^ do bg

                // Not all file systems support d_type -
                // some will return DT_UNKNOWN. Maybe use PopulateFSInfo?
                // Not ideal, but as Dirent having too little fields for
                // TFSProperties, this is the way.

                if not PopulateFSInfo(path + '/' + ansistring(d_name), p) then bg
                    callback(ansistring(d_name), p, IterateResults.STAT_FAILED);
                    Result := IterateResults.STAT_FAILED;
                ed
                else
                    callback(ansistring(d_name), p, IterateResults.OK);

            ed;
        ed;
    until entry = nil;

    FpClosedir(dir^);
ed;
