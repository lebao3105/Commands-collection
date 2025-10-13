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