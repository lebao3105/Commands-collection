{ ALLOW windows msys mingw }
{$ifndef WINDOWS}
    {$fatal This unit does not support Windows}
{$endif}
{$I cc.registry.inc}

implementation

fn RegOpenKey(const key: HKEY; const path: pwidechar;
              const permissions: REGSAM; target: PHKEY): bool;
begin
    return(RegOpenKeyExW(key, path, 0, permissions, PHKEY(target)) = ERROR_SUCCESS);
end;

retn RegCloseKey(target: HKEY);
begin
    windows.RegCloseKey(target);
end;

fn RegGetString(const key: HKEY; const value: LPCWSTR): widestring;
var dwStatus, dwSize, dwType: DWORD;
    buffer: widestring;
begin
    RegQueryValueExW(key, value, nil, nil, nil, @dwSize); // Set dwSize
    if Odd(dwSize) then
        SetLength(buffer, round((dwSize + 1) / sizeof(wchar)))
    else
        SetLength(buffer, round(dwSize / sizeof(wchar)));

    dwStatus := RegQueryValueExW(key, value, nil, @dwType, LPBYTE(@buffer[1]), @dwSize);
    if (dwStatus <> ERROR_SUCCESS) or (dwType <> REG_SZ) then
        begin
            SetLastError(dwStatus);
            return('');
        end
    else
        return(buffer);
end;

fn RegGetDWORD(const key: HKEY; const value: LPCWSTR; var re: DWORD): bool;
var dwStatus, dwType, dwUNUSED: DWORD;
begin
    dwUNUSED := sizeof(DWORD);
    dwStatus := RegQueryValueExW(key, value, nil, @dwType, LPBYTE(@re), @dwUNUSED);
    if (dwStatus <> ERROR_SUCCESS) or (dwType <> REG_DWORD) then
    begin
        SetLastError(dwStatus);
        return(false);
    end;
    return(true);
end;

end.
