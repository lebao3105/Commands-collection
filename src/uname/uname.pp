program uname;
{$modeswitch anonymousfunctions}

uses
    sysutils,
    {$ifdef UNIX}baseunix,
    {$else}windows, small.registry,
    {$endif}
    small.base,
    small.getopts,
    small.logging,
    small.i18n
    ;

{$I i18n.inc}

type STR = {$ifdef WINDOWS}widestring{$else}string{$endif};

var
    {$ifdef UNIX}Inf: TUtsname;
    {$else}RKey: HKEY;{$endif}
    PrettyPrint: bool = false;

procedure PrintElement(what: STR {???}; name: string); inline;
begin
    write(
        specialize IfThenElse<STR>(
            PrettyPrint,
            name + ': ' + what + sLineBreak,
            what + ' '
        )
    );
end;

{$ifdef WINDOWS}
const
    UNAME_RKEY: pwidechar = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion';
    // Below are definitions in Windows SDK include dir\um\winnt.h
    // They are not included in FPC's RTL
    PROCESSOR_ARCHITECTURE_INTEL = 0; // x86
    // PROCESSOR_ARCHITECTURE_MIPS = 1;
    // PROCESSOR_ARCHITECTURE_ALPHA = 2;
    // PROCESSOR_ARCHITECTURE_PPC = 3;
    // PROCESSOR_ARCHITECTURE_SHX = 4;
    PROCESSOR_ARCHITECTURE_ARM = 5;
    // PROCESSOR_ARCHITECTURE_IA64 = 6;
    // PROCESSOR_ARCHITECTURE_ALPHA64 = 7;
    // PROCESSOR_ARCHITECTURE_MSIL = 8;
    PROCESSOR_ARCHITECTURE_AMD64 = 9; // x64 (AMD or Intel)
    PROCESSOR_ARCHITECTURE_IA32_ON_WIN64 = 10;
    // PROCESSOR_ARCHITECTURE_NEUTRAL = 11; // ???
    PROCESSOR_ARCHITECTURE_ARM64 = 12;
    PROCESSOR_ARCHITECTURE_ARM32_ON_WIN64 = 13;
    PROCESSOR_ARCHITECTURE_IA32_ON_ARM64 = 14;
    // PROCESSOR_ARCHITECTURE_UNKNOWN = $ffff;

procedure GetStrRegValue(const pValue: LPCWSTR; const name: string);
var str: widestring;
begin
    str := RegGetString(RKey, pValue);
    PrintElement(
        specialize IfThenElse<widestring>(
            Length(str) = 0,
            UNKNOWN,
            str
        ),
        name
    );
end;

procedure GetInfoFailed(name: string);
var pprintBackup: bool;
begin
    pprintBackup := PrettyPrint;
    if not PrettyPrint then begin
        writeln;
        PrettyPrint := true;
    end;

    PrintElement(Format(GET_INFO_FAIL, [ GetLastError, GetLastStrErrno ]), name);
    PrettyPrint := pprintBackup;
end;
{$endif}

procedure OptionHandler(const found: char);
begin
    case found of
        'a': begin // Follows GNU
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
        'n': procedure var buffer: widestring; sz: DWORD;
        begin
            sz := MAX_COMPUTERNAME_LENGTH + 1;
            SetLength(buffer, sz);
            if not GetComputerNameW(@buffer[1], @sz) then
                GetInfoFailed(NETWORK_NODENAME)
            else
                PrintElement(buffer, NETWORK_NODENAME);
        end ();
        'r': GetStrRegValue('CurrentBuild', KERNEL_RELEASE);
        'v': procedure var dwMajor, dwMinor: DWORD; begin
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
        'm': procedure var inf: SYSTEM_INFO; begin
            GetNativeSystemInfo(@inf); // ??????
            case inf.wProcessorArchitecture of
                PROCESSOR_ARCHITECTURE_AMD64:
                    PrintElement('x86_64', MACHINE_HWNAME);
                PROCESSOR_ARCHITECTURE_ARM64:
                    PrintElement('aarch64', MACHINE_HWNAME);
                PROCESSOR_ARCHITECTURE_INTEL:
                    PrintElement('x86', MACHINE_HWNAME);
                PROCESSOR_ARCHITECTURE_ARM:
                    PrintElement('arm', MACHINE_HWNAME);
                PROCESSOR_ARCHITECTURE_IA32_ON_WIN64:
                    PrintElement('ia32 on x64 (WOW64)', MACHINE_HWNAME);
                PROCESSOR_ARCHITECTURE_ARM32_ON_WIN64:
                    PrintElement('arm on x64', MACHINE_HWNAME);
                PROCESSOR_ARCHITECTURE_IA32_ON_ARM64:
                    PrintElement('ia32 on aarch64', MACHINE_HWNAME);
                
                // Unsupported + unknown go here
                else
                    PrintElement(UNKNOWN, MACHINE_HWNAME);
            end;
        end ();
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
    AddExitProc(procedure begin RegCloseKey(RKey); end);
    {$endif}

    if ParamCount = 0 then
    begin
        OptionHandler('s');
        exit;
    end;

    small.getopts.OptCharHandler := @OptionHandler;
    small.getopts.GetOpt;
end.
{$pop}
