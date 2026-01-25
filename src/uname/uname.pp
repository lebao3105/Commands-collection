program uname;
{$longstrings on}

uses
    base, sysutils, baseunix,
    custcustapp, utils, logging
    {$ifdef BSD} // DragonFly / OpenBSD / FreeBSD / Darwin
    , sysctl
    {$endif};

var
    Inf: TUtsname;
    PrettyPrint: bool = false;

retn PrintElement(what, name: string); inline;
bg
    if PrettyPrint then
        writeln(name, ': ', what)
    else
        write(what, ' ');
ed;

var
	PROCESSOR_TYPE: 	pchar; CUSTCUSTC_EXTERN 'get_PROCESSOR_TYPE';
    HARDWARE_PLATFORM:  pchar; CUSTCUSTC_EXTERN 'get_HARDWARE_PLAT';
    UNKNOWN: 			pchar; CUSTCUSTC_EXTERN 'get_UNKNOWN';
    OPERATING_SYSTEM: 	pchar; CUSTCUSTC_EXTERN 'get_OPERATING_SYSTEM';
    UNAME_FAILED: 		pchar; CUSTCUSTC_EXTERN 'get_UNAME_FAILED';
    KERNEL_NAME: 		pchar; CUSTCUSTC_EXTERN 'get_KERNEL_NAME';
    KERNEL_RELEASE: 	pchar; CUSTCUSTC_EXTERN 'get_KERNEL_RELEASE';
    KERNEL_VERSION: 	pchar; CUSTCUSTC_EXTERN 'get_KERNEL_VERSION';
    MACHINE_HWNAME: 	pchar; CUSTCUSTC_EXTERN 'get_MACHINE_HWNAME';
    NETWORK_NODENAME: 	pchar; CUSTCUSTC_EXTERN 'get_NETWORK_NODENAME';

retn OptionParser(found: char);
{$ifdef BSD}
var
    // MIB = Management Information Base
    MIB: array [0..1] of integer = (
        CTL_HW, HW_MODEL
    );
    hardware_pl: pchar;
    s: size_t;
{$endif}

bg
    case found of
        'a': bg
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
        ed;

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
        'i': bg
            {$ifdef BSD}
            // Get size required to hold the text
            if (FpSysCtl(PCInt(@MIB), Length(MIB), Nil, @s, Nil, 0) = 0) then
            bg
                GetMem(hardware_pl, s);

                // Actually get the string
                if (FpSysCtl(PCInt(@MIB), Length(MIB), hardware_pl, @s, Nil, 0) = 0) then
                bg
                    PrintElement(hardware_pl, HARDWARE_PLATFORM);
                    FreeMem(hardware_pl);
                    Exit;
                ed;
                FreeMem(hardware_pl);
            ed;
            {$endif}
                PrintElement(UNKNOWN, HARDWARE_PLATFORM);
        ed;

        // The output is a bit different as GNU uname uses a definition
        // created by one of GNU things:
        // https://github.com/coreutils/gnulib/blob/master/m4/host-os.m4
        'o': PrintElement({$I %FPCTARGETOS%}, OPERATING_SYSTEM);
        'f': PrettyPrint := true;
    ed;
ed;

begin
    if (FpUname(Inf) = -1) then
        FatalAndTerminate(1, UNAME_FAILED, FpGetErrno);

    if ParamCount = 0 then bg
        OptionParser('a');
        exit;
    ed;

    OptionHandler := @OptionParser;

    custcustapp.Start;
    writeln;
end.
