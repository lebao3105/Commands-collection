unit cc.registry;
{<A wrapper of Windows's registry system.
  FCL-Registry exists, but is object-oriented (which CC does not use)
  and does more than what CC needs right now.}

{$modeswitch defaultparameters}

interface

uses Windows;

const
    HKEY_CLASSES_ROOT      = Windows.HKEY_CLASSES_ROOT;
    HKEY_CURRENT_USER      = Windows.HKEY_CURRENT_USER;
    HKEY_LOCAL_MACHINE     = Windows.HKEY_LOCAL_MACHINE;
    HKEY_USERS             = Windows.HKEY_USERS;
    HKEY_PERFORMANCE_DATA  = Windows.HKEY_PERFORMANCE_DATA;
    HKEY_CURRENT_CONFIG    = Windows.HKEY_CURRENT_CONFIG;
    HKEY_DYN_DATA          = Windows.HKEY_DYN_DATA;

    KEY_ALL_ACCESS         = Windows.KEY_ALL_ACCESS;
    KEY_CREATE_LINK        = Windows.KEY_CREATE_LINK;
    KEY_CREATE_SUB_KEY     = Windows.KEY_CREATE_SUB_KEY;
    KEY_ENUMERATE_SUB_KEYS = Windows.KEY_ENUMERATE_SUB_KEYS;
    KEY_EXECUTE            = Windows.KEY_EXECUTE;
    KEY_NOTIFY             = Windows.KEY_NOTIFY;
    KEY_QUERY_VALUE        = Windows.KEY_QUERY_VALUE;
    KEY_READ               = Windows.KEY_READ;
    KEY_SET_VALUE          = Windows.KEY_SET_VALUE;
    KEY_WRITE              = Windows.KEY_WRITE;

    {$ifndef WinCE}
    KEY_WOW64_64KEY        = Windows.KEY_WOW64_64KEY;
    KEY_WOW64_32KEY        = Windows.KEY_WOW64_32KEY;
    {$endif WinCE}

    REG_NONE                       : DWORD = Windows.REG_NONE;
    REG_SZ                         : DWORD = Windows.REG_SZ;
    REG_EXPAND_SZ                  : DWORD = Windows.REG_EXPAND_SZ;
    REG_BINARY                     : DWORD = Windows.REG_BINARY;
    REG_DWORD                      : DWORD = Windows.REG_DWORD;
    REG_DWORD_BIG_ENDIAN           : DWORD = Windows.REG_DWORD_BIG_ENDIAN;
    REG_LINK                       : DWORD = Windows.REG_LINK;
    REG_MULTI_SZ                   : DWORD = Windows.REG_MULTI_SZ;
    REG_RESOURCE_LIST              : DWORD = Windows.REG_RESOURCE_LIST;
    REG_FULL_RESOURCE_DESCRIPTOR   : DWORD = Windows.REG_FULL_RESOURCE_DESCRIPTOR;
    REG_RESOURCE_REQUIREMENTS_LIST : DWORD = Windows.REG_RESOURCE_REQUIREMENTS_LIST;
    REG_QWORD                      : DWORD = Windows.REG_QWORD;

fn RegOpenKey(const key: HKEY; const path: pwidechar;
              const permissions: REGSAM; target: PHKEY): bool;
retn RegCloseKey(target: HKEY);

// Returns a widestring value of key\value registry object.
// If the retrieval fails, the last OS error will be reset.
fn RegGetString(const key: HKEY; const value: LPCWSTR): widestring;

// Assigns re the DWORD value of key\value registry object and
// returns whether the retrieval is successful.
// If the retrieval fails, the last OS error will be reset.
fn RegGetDWORD(const key: HKEY; const value: LPCWSTR; var re: DWORD): bool;
