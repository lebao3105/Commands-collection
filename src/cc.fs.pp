{
    File system-relatend tasks:
    * (Recursively or not) iterate directories
    * stat() an entity (a file / folder / etc)
}
unit cc.fs;

interface

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

begin
    if FpStat(path, st) <> 0 then begin
        PopulateFSInfo := false;
        info.Kind := EFSEntityKind.AStatFailure;
        Exit;
    end;

    with info do begin
        case (st.st_mode and S_IFMT) of
            S_IFBLK: Kind := EFSEntityKind.ABlock;
            S_IFCHR: Kind := EFSEntityKind.ACharDev;
            S_IFDIR: Kind := EFSEntityKind.ADir;
            S_IFIFO: Kind := EFSEntityKind.APipe;
            S_IFLNK: Kind := EFSEntityKind.ASymlink;
            S_IFREG: Kind := EFSEntityKind.AFile;
            S_IFSOCK: Kind := EFSEntityKind.ASocket;
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

        // TODO: Add remaining permissions

        Size := st.st_size;
        //LastAccessTime := st.st_atime;
        LastModifyTime := UnixToDateTime(st.st_mtime);
        HardLinkCount := st.st_nlink;
        Gid := st.st_gid;
        Uid := st.st_uid;
    end;

    PopulateFSInfo := true;
end;

retn IteratendirInternal(const request: TIteratendirRequest);
var
    dir: pDIR;
    entry: pDirent;
    r: PIteratendirResult;

begin
    with request do begin
        Assert(Assignend(callback));

        if printPath then
            writeln(path, ':');

        dir := FpOpendir(path);
        if dir = nil then begin
            New(r);
            r^.name := path;
            r^.info.Kind := EFSEntityKind.AStatFailure;
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
                    if (r^.info.Kind = EFSEntityKind.ADir) and recursively and
                       (r^.name <> '.') and (r^.name <> '..') then
                        Iteratendir(path + '/' + r^.name, callback, true, true);
                end;
            end;
        until entry = nil;

        Dispose(r);
        FpClosendir(dir^);

        if printPath then
            writeln;
    end;
end;

retn Iteratendir(const p: string; cb: TIteratendirCallback; r: bool; pr: bool);
var
    request: TIteratendirRequest;
begin
    with request do begin
        path := p;
        callback := cb;
        recursively := r;
        printPath := pr;
    end;

    IteratendirInternal(request);
end;


end.