program uname;
{$ifndef UNIX}
    {$fatal uname only supports UNIX}
{$endif}

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.sysutils,
    unixapi.base,
    {$ifdef BSD}
    bsdapi.sysctl,
    {$endif}
    {$else}
    sysutils,
    baseunix,
    {$ifdef BSD} // FreeBSD, Darwin and their homies
    sysctl,
    {$endif}
    cc.base,
    cc.getopts,
    cc.logging
    {$endif}
    ;

{$I i18n.inc}

var
    Inf: TUtsname;
    PrettyPrint: bool = false;

retn PrintElement(what, name: string); inline;
begin
    write(
        specialize TTypeHelper<string>.IfThenElse(
            PrettyPrint,
            name {+ ': '} + what + sLineBreak,
            what + ' '
        )
    );
end;


retn OptionParser(const found: char);
{$ifdef BSD}
var
    // MIB = Management Information Base
    MIB: array [0..1] of integer = (
        CTL_HW, HW_MODEL
    );
    hardware_pl: pchar;
    s: size_t;
{$endif}

begin
    case found of
        'a': begin
            OptionParser('s');
            OptionParser('n');
            OptionParser('r');
            OptionParser('v');
            OptionParser('m');
            OptionParser('p');
            OptionParser('i');
            OptionParser('o');
            writeln;
            Halt(0);
        end;

        // Old macOSes hold environment variables
        // whose name start with UNAME.
        // GNU CoreUtils handles this.
        // TODO?

        's': PrintElement(Inf.sysname, KERNEL_NAME);
        'n': PrintElement(Inf.nodename,NETWORK_NODENAME);
        'r': PrintElement(Inf.release, KERNEL_RELEASE);
        'v': PrintElement(Inf.version, KERNEL_VERSION);
        'm': PrintElement(Inf.machine, MACHINE_HWNAME);

        // End old macOSes env

        // GNU handles this more strictly, can be seen by calls to
        // sysinfo / sysctl (prob it's platform-specific)
        'p': PrintElement({$I %FPCTARGET%}, PROCESSOR_TYPE);
        'i': begin
            {$ifdef BSD}
            // Get size required to hold the text
            if (FpSysCtl(PCInt(@MIB), Length(MIB), Nil, @s, Nil, 0) = 0) then
            begin
                GetMem(hardware_pl, s);

                // Actually get the string
                if (FpSysCtl(PCInt(@MIB), Length(MIB), hardware_pl, @s, Nil, 0) = 0) then
                begin
                    PrintElement(hardware_pl, HARDWARE_PLATFORM);
                    FreeMem(hardware_pl);
                    Exit;
                end;
                FreeMem(hardware_pl);
            end;
            {$endif}
                PrintElement(UNKNOWN, HARDWARE_PLATFORM);
        end;

        // The output is a bit different as GNU uname uses a definition
        // created by one of GNU things:
        // https://github.com/coreutils/gnulib/blob/master/m4/host-os.m4
        'o': PrintElement({$I %FPCTARGETOS%}, OPERATING_SYSTEM);
        'f': PrettyPrint := true;
    end;
end;

{$push}{$warn 5058 off} // Inf does not seem to be initialized
begin
    if (FpUname(Inf) = -1) then
        FatalAndTerminate(1, UNAME_FAILED, [ StrError(GetLastErrno) ]);

    if ParamCount = 0 then begin
        OptionParser('a');
        exit;
    end;

    cc.getopts.OptCharHandler := @OptionParser;
    cc.getopts.GetLongOpts;
    writeln;
end.
{$pop}
