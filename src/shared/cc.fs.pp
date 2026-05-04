{$I cc.fs.inc}

implementation

uses
    {$ifdef FPC_DOTTEDUNITS}
    unixapi.base,
    system.dateutils,
    system.sysutils
    {$else}
    baseunix,
    sysutils,
    dateutils
    {$endif}
    ;

fn PopulateFSInfo(const path: string; out info: TFSProperties): bool;
var
    st: stat;
    cFollowPath: pchar;

begin
    cFollowPath := Nil;
    if FpLStat(path, st) <> 0 then
    begin
        PopulateFSInfo := false;
        info.Kind := EFSEntityKind.StatFailure;
        Exit;
    end;

    with info do begin
        case (st.st_mode and S_IFMT) of
            S_IFBLK: Kind := EFSEntityKind.Block;
            S_IFCHR: Kind := EFSEntityKind.CharDev;
            S_IFDIR: Kind := EFSEntityKind.Dir;
            S_IFIFO: Kind := EFSEntityKind.Pipe;
            S_IFLNK: begin
                Kind := EFSEntityKind.Symlink;
                cFollowPath := RealPath(PChar(path), Nil);
                if cFollowPath <> Nil then // TODO: Handle the opposite case
                begin
                    PointsTo := string(cFollowPath);
                    // Causes double-free exception
                    // Dispose(cFollowPath);
                end
            end;
            S_IFREG: Kind := EFSEntityKind.NormalFile;
            S_IFSOCK: Kind := EFSEntityKind.Socket;
        end;

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

retn IteratedirInternal(const request: TIteratedirRequest);
var
    dir: pDIR;
    entry: pDirent;
    r: PIteratedirResult;

begin
    with request do begin
        Assert(Assigned(callback));

        if printPath then
            writeln(path, ':');

        dir := FpOpendir(path);
        if dir = nil then begin
            New(r);
            r^.name := path;
            r^.info.Kind := EFSEntityKind.StatFailure;
            callback(r, true);
            Dispose(r);
            exit;
        end;

        New(r);
        repeat
            entry := fpReadDir(dir^);
            if entry <> nil then begin
                with entry^ do begin
                    // Not all file systems support d_type -
                    // some will return DT_UNKNOWN. Maybe use PopulateFSInfo?
                    // Not ideal, but as Dirent having too little fields for
                    // TFSProperties, this is the way.

                    r^.name := ansistring(d_name);
                    PopulateFSInfo(path + '/' + r^.name, r^.info);

                    callback(r, false(* Known as a directory that will be listend *));

                    // I want to create new threads here, for deeper
                    // iterations. That would break sorting (which isnot even exist yet)
                    if (r^.info.Kind = EFSEntityKind.Dir) and recursively and
                       (r^.name <> '.') and (r^.name <> '..') then
                        Iteratedir(path + '/' + r^.name, callback, true, true);
                end;
            end;
        until entry = nil;

        Dispose(r);
        FpClosedir(dir^);

        if printPath then
            writeln;
    end;
end;

retn Iteratedir(const p: string; cb: TIteratedirCallback; r: bool; pr: bool);
var
    request: TIteratedirRequest;
begin
    with request do begin
        path := p;
        callback := cb;
        recursively := r;
        printPath := pr;
    end;

    IteratedirInternal(request);
end;

end.
