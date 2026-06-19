{$I cc.fs.inc}

implementation

uses
    {$ifdef UNIX}
    baseunix,
    {$endif}
    sysutils,
    dateutils
    ;

{$ifdef UNIX}
fn GetFSETypeInternal(st: pstat): EFSEntityKind;
begin
    case (st^.st_mode and S_IFMT) of
        S_IFBLK: Result := EFSEntityKind.Block;
        S_IFCHR: Result := EFSEntityKind.CharDev;
        S_IFDIR: Result := EFSEntityKind.Dir;
        S_IFIFO: Result := EFSEntityKind.Pipe;
        S_IFLNK: Result := EFSEntityKind.Symlink;
        S_IFREG: Result := EFSEntityKind.NormalFile;
        S_IFSOCK: Result := EFSEntityKind.Socket;
    end;
end;
{$endif}

fn PopulateFSInfo(const path: string; out info: TFSProperties): bool;
{$push}
    {$warn 5057 off}
{$ifdef UNIX}
var st: stat;
begin
    if FpLStat(path, st) <> 0 then
    begin
        PopulateFSInfo := false;
        info.Kind := EFSEntityKind.StatFailure;
        Exit;
    end;

    with info do begin
        Kind := GetFSETypeInternal(@st);
        if Kind = EFSEntityKind.Symlink then
            PointsTo := string(RealPath(PChar(path), Nil));

        Perms[0].E := (st.st_mode and S_IXUSR) <> 0;
        Perms[0].R := (st.st_mode and S_IRUSR) <> 0;
        Perms[0].W := (st.st_mode and S_IWUSR) <> 0;

        Perms[1].E := (st.st_mode and S_IXGRP) <> 0;
        Perms[1].R := (st.st_mode and S_IRGRP) <> 0;
        Perms[1].W := (st.st_mode and S_IWGRP) <> 0;

        Perms[2].E := (st.st_mode and S_IXOTH) <> 0;
        Perms[2].R := (st.st_mode and S_IROTH) <> 0;
        Perms[2].W := (st.st_mode and S_IWOTH) <> 0;

        SetUserID_OnExec := (st.st_mode and S_ISUID) <> 0;
        SetGroupID_OnExec := (st.st_mode and S_ISGID) <> 0;

        Size := st.st_size;
        LastAccessTime := UnixToDateTime(st.st_atime);
        LastModifyTime := UnixToDateTime(st.st_mtime);
        HardLinkCount := st.st_nlink;
        Gid := st.st_gid;
        Uid := st.st_uid;
    end;

    PopulateFSInfo := true;
end;
{$else}
begin end;
{$endif}
{$pop}

retn Iteratedir(const path: string; callback: TIteratedirCallback; recursively, printPath: bool);
{$ifdef UNIX}
var
    dir: pDIR;
    entry: pDirent;
    r: PIteratedirResult;

begin
    Assert(Assigned(callback));
    Assert(Length(path) > 0);
    New(r);

    if printPath then
        writeln(path, ':');

    dir := fpOpenDir(path);
    if dir = nil then begin
        r^.fullpath := path;
        r^.info.Kind := EFSEntityKind.StatFailure;
        callback(r);
        Dispose(r);
        exit;
    end;

    New(r);
    repeat
        entry := fpReadDir(dir^);
        if entry = nil then continue;
        with entry^ do begin
            // Not all file systems support d_type -
            // some will return DT_UNKNOWN. Maybe use PopulateFSInfo?
            // Not ideal, but as Dirent having too little fields for
            // TFSProperties, this is the way.

            r^.name := string(d_name);
            r^.fullpath := path + DirectorySeparator + r^.name;
            PopulateFSInfo(r^.fullpath, r^.info);

            callback(r);

            // I want to create new threads here, for deeper
            // iterations. That would break sorting (which isnot even exist yet)
            if (r^.info.Kind = EFSEntityKind.Dir) and recursively and
                (d_name <> '.') and (d_name <> '..') then
                Iteratedir(r^.fullpath, callback, true, true);
        end;
    until entry = nil;

    Dispose(r);
    FpClosedir(dir^);

    if printPath then
        writeln;
end;
{$else}
begin end;
{$endif}

fn GetFSEntityType(const p: string): EFSEntityKind;
{$push}
    {$warn 5057 off}
{$ifdef UNIX}
var st: stat;
begin
    if FpLStat(p, st) <> 0 then
        return(EFSEntityKind.StatFailure);
    return(GetFSETypeInternal(@st));
end;
{$else}
begin end;
{$endif}
{$pop}

fn IOResultToString: string;
begin
    case IOResult of
        0:   Result := '';

        // DOS Errors
        2:   Result := ERR_FILE_NOT_FOUND;
        3:   Result := ERR_PATH_NOT_FOUND;
        4:   Result := ERR_TOO_MANY_OPEN_FILES;
        5:   Result := ERR_ACCESS_DENIED;
        6:   Result := ERR_INVALID_FILE_HANDLE;
        12:  Result := ERR_INVALID_FILE_ACCESS;
        15:  Result := ERR_INVALID_DISK_NUMBER;
        16:  Result := ERR_CANNOT_REMOVE_DIR;
        17:  Result := ERR_CANNOT_RENAME_VOLUMES;

        // I/O Errors
        100: Result := ERR_DISK_READ;
        101: Result := ERR_DISK_WRITE;
        102: Result := ERR_FILE_NOT_ASSIGNED;
        103: Result := ERR_FILE_NOT_OPEN;
        104: Result := ERR_FILE_NOT_OPEN_INPUT;
        105: Result := ERR_FILE_NOT_OPEN_OUTPUT;
        106: Result := ERR_INVALID_NUMBER;

        // Fatal Errors
        150: Result := ERR_WRITE_PROTECTED;
        151: Result := ERR_UNKNOWN_DEVICE;
        152: Result := ERR_DRIVE_NOT_READY;
        153: Result := ERR_UNKNOWN_COMMAND;
        154: Result := ERR_CRC_CHECK_FAILED;
        155: Result := ERR_INVALID_DRIVE;
        156: Result := ERR_SEEK_ERROR;
        157: Result := ERR_INVALID_MEDIA_TYPE;
        158: Result := ERR_SECTOR_NOT_FOUND;
        159: Result := ERR_PRINTER_OUT_OF_PAPER;
        160: Result := ERR_DEVICE_WRITE;
        161: Result := ERR_DEVICE_READ;
        162: Result := ERR_HARDWARE_FAILURE;
    else
        Result := Format(ERR_UNKNOWN_IO_RESULT, [IOResult]);
    end;
end;

end.
