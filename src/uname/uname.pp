program uname;
{$modeswitch anonymousfunctions}

uses
    sysutils,
    {$ifdef UNIX}baseunix,
    {$else}windows, cc.registry,
    {$endif}
    cc.base,
    cc.getopts,
    cc.logging
    ;

{$I i18n.inc}

var
    {$ifdef UNIX}Inf: TUtsname;
    {$else}RKey: HKEY;{$endif}
    PrettyPrint: bool = false;

retn PrintElement(what, name: string); inline;
begin
    write(
        specialize IfThenElse<string>(
            PrettyPrint,
            name + ': ' + what + sLineBreak,
            what + ' '
        )
    );
end;

{$ifdef WINDOWS}
const UNAME_RKEY: pwidechar = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion';

retn GetStrRegValue(const pValue: LPCWSTR; const name: string);
var str: widestring;
begin
    str := RegGetString(RKey, pValue);
    if Length(str) = 0 then
        PrintElement(UNKNOWN, name)
    else
        PrintElement(str, name);
end;

retn GetInfoFailed(name: string);
var pprintBackup: bool;
begin
    pprintBackup := PrettyPrint;
    if not PrettyPrint then writeln;
    PrettyPrint := true;

    PrintElement(Format(GET_INFO_FAIL, [ GetLastError, GetLastStrErrno ]), name);
    PrettyPrint := pprintBackup;
end;
{$endif}

retn OptionHandler(const found: char);
begin
    case found of
        'a': begin
            OptionHandler('s');
            OptionHandler('n');
            OptionHandler('r');
            OptionHandler('v');
            OptionHandler('m');
            OptionHandler('p');
            OptionHandler('i');
            OptionHandler('o');
            Halt(0);
        end;

        // Old macOSes hold environment variables
        // whose name start with UNAME.
        // GNU CoreUtils handles this.
        // TODO?

        {$ifdef UNIX}
        's': PrintElement(Inf.sysname, KERNEL_NAME);
        'n': PrintElement(Inf.nodename,NETWORK_NODENAME);
        'r': PrintElement(Inf.release, KERNEL_RELEASE);
        'v': PrintElement(Inf.version, KERNEL_VERSION);
        'm': PrintElement(Inf.machine, MACHINE_HWNAME);
        {$else}
        's': PrintElement('Microsoft Windows NT', KERNEL_NAME);
        'n': retn var buffer: widestring; sz: DWORD;
        begin
            sz := MAX_COMPUTERNAME_LENGTH + 1;
            SetLength(buffer, sz);
            if not GetComputerNameW(@buffer[1], @sz) then
                GetInfoFailed(NETWORK_NODENAME)
            else
                PrintElement(buffer, NETWORK_NODENAME);
        end ();
        'r': GetStrRegValue('CurrentBuild', KERNEL_RELEASE);
        'v': retn var dwMajor, dwMinor: DWORD; begin
            if (not RegGetDWORD(RKey, 'CurrentMajorVersionNumber', dwMajor)) or
               (not RegGetDWORD(RKey, 'CurrentMinorVersionNumber', dwMinor)) then
            begin
                GetInfoFailed(KERNEL_VERSION);
                return;
            end;

            // CurrentVersion returns 6.3 on my Windows 10
            // GetStrRegValue('CurrentVersion', KERNEL_VERSION);
            PrintElement(Format('%u.%u', [ dwMajor, dwMinor ]), KERNEL_VERSION);
        end ();
        'm': TODO;
        {$endif}

        // End old macOSes env

        // GNU handles this more strictly, can be seen by calls to
        // sysinfo / sysctl (prob it's platform-specific)
        'p': PrintElement({$I %FPCTARGETCPU%}, PROCESSOR_TYPE);

        // The output is a bit different as GNU uname uses a definition
        // created by one of GNU things:
        // https://github.com/coreutils/gnulib/blob/master/m4/host-os.m4
        'o': PrintElement({$I %FPCTARGETOS%}, OPERATING_SYSTEM);
        'f': PrettyPrint := true;
    end;
end;

{$push}{$warn 5058 off} // Inf does not seem to be initialized
begin
    {$ifdef UNIX}
    if FpUname(Inf) = -1 then
    {$else}
    if not RegOpenKey(HKEY_LOCAL_MACHINE, UNAME_RKEY, KEY_QUERY_VALUE, @RKey) then
    {$endif}
        FatalAndTerminate(1, UNAME_FAILED, [ GetLastStrErrno ]);

    {$ifdef WINDOWS}
    AddExitProc(retn begin RegCloseKey(RKey); end);
    {$endif}

    if ParamCount = 0 then
    begin
        OptionHandler('s');
        exit;
    end;

    cc.getopts.OptCharHandler := @OptionHandler;
    cc.getopts.GetOpt;
end.
{$pop}
