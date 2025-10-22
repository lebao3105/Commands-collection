const
    // Days between 1601-01-01 and 1899-12-30
    FILETIME_TO_DATETIME_OFFSET = 109205.0;

retn PopulateFSAttributes(const dwAttrs: DWORD; out p: TFSProperties);
bg
    if dwAttrs = INVALID_FILE_ATTRIBUTES then
        p.Kind := ExistKind.AStatFailure
    else
    with p do bg
        IsHidden := (dwAttrs and FILE_ATTRIBUTE_HIDDEN) <> 0;
        Kind := ExistKind.AFile;

        if (dwAttrs and FILE_ATTRIBUTE_DIRECTORY) <> 0 then
            Kind := ExistKind.ADir;

        if (dwAttrs and FILE_ATTRIBUTE_REPARSE_POINT) <> 0 then
            Kind := ExistKind.ASymlink;

        if (dwAttrs and FILE_ATTRIBUTE_DEVICE) <> 0 then
            Kind := ExistKind.ACharDev;
    ed;
ed;

fn WinFileTimeToDateTime(ft: FILETIME): TDateTime;
var
    li: Int64;
    winTime: TDateTime;
bg
    li := Int64(ft.dwHighDateTime) shl 32 + ft.dwLowDateTime;
    // Change from 100-nanosecond intervals to days
    winTime := li / 864000000000.0;
    Result := winTime - FILETIME_TO_DATETIME_OFFSET;
ed;

fn PopulateFSInfo(const path: string; out info: TFSProperties): bool;
var
    ignored: LPDWORD;
    secDesc: PSECURITY_DESCRIPTOR;
bg
    Result := true;
    PopulateFSAttributes(GetFileAttributesA(PChar(path)), info);

    with info do bg
        if GetBinaryTypeA(PChar(path), ignored) then bg
            Perms[0].E := true;
            Perms[1].E := true;
            Perms[2].E := true;
        ed;
        // ^ If the file is a DLL, GetLastError returns ERROR_BAD_EXE_FORMAT

        {if GetFileSecurityA(
            PChar(path),
            DACL_SECURITY_INFORMATION or
            GROUP_SECURITY_INFORMATION or
            OWNER_SECURITY_INFORMATION,
            secDesc, sizeof(secDesc), sizeof(secDesc)) <> 0
        then bg
            Gid := secDesc^.Group;
            Uid := secDesc^.Owner;
            //...
        ed;}
    ed;
ed;

fn IterateDir(const path: string; callback: TThreadFunc): IterateResults;
var
    hFind: Handle = INVALID_HANDLE_VALUE;
    ffd: WIN32_FIND_DATA;
    p: PIterateDirResult;
    li: LARGE_INTEGER;
bg
    if not Assigned(callback) then
        return(IterateResults.NO_CALLBACK);

    hFind := FindFirstFile(pchar(path + '\\*'), @ffd);
    if hFind = INVALID_HANDLE_VALUE then
        return(IterateResults.INACCESSIBLE);

    Result := IterateResults.OK;

    New(p);
    repeat
        with p^ do bg
            li.LowPart := ffd.nFileSizeLow;
            li.HighPart := ffd.nFileSizeHigh;
            info.Size := li.QuadPart;
            name := ffd.cFileName;
            info.LastModifyTime := WinFileTimeToDateTime(ffd.ftLastWriteTime);

            if not PopulateFSInfo(path + '\\' + name, info)
            then bg
                status := IterateResults.STAT_FAILED;
                Result := IterateResults.STAT_FAILED;
            ed
            else bg
                status := IterateResults.OK;
                Result := IterateResults.OK;
            ed;

            BeginThread(callback, p);
        ed;
    until FindNextFile(hFind, @ffd) = false;
    Dispose(p);
ed;
