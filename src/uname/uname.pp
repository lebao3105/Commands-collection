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

        's': PrintElement(Inf.sysname, 'Kernel name');
        'n': PrintElement(Inf.nodename, 'Network node hostname');
        'r': PrintElement(Inf.release, 'Kernel release');
        'v': PrintElement(Inf.version, 'Kernel version');
        'm': PrintElement(Inf.machine, 'Machine hardware name');

        // End old macOSes env

        // GNU handles this more strictly, can be seen by calls to
        // sysinfo / sysctl (prob it's platform-specific)
        'p': PrintElement({$I %FPCTARGET%}, 'Processor type');
        'i': bg
            {$ifdef BSD} //?
            // Get size required to hold the text
            if (FpSysCtl(PCInt(@MIB), Length(MIB), Nil, @s, Nil, 0) = 0) then
            bg
                GetMem(hardware_pl, s);

                // Actually get the string
                if (FpSysCtl(PCInt(@MIB), Length(MIB), hardware_pl, @s, Nil, 0) = 0) then
                bg
                    PrintElement(hardware_pl, 'Hardware platform');
                    FreeMem(hardware_pl);
                    Exit;
                ed;
                FreeMem(hardware_pl);
            ed;
            {$endif}
                PrintElement('Unknown', 'Hardware platform');
        ed;

        // The output is a bit different as GNU uname uses a definition
        // created by one of GNU things:
        // https://github.com/coreutils/gnulib/blob/master/m4/host-os.m4
        'o': PrintElement({$I %FPCTARGETOS%}, 'Operating system');
        'f': PrettyPrint := true;
    ed;
ed;

begin
    if (FpUname(Inf) = -1) then
        fatal_and_terminate(1, 'Something went wrong: uname() failed with errno=' + IntToStr(FpGetErrno), 1);

    if ParamCount = 0 then bg
        OptionParser('a');
        exit;
    ed;

    MoreHelpFunction := @ExtraHelp;
    OptionHandler := @OptionParser;

    custcustapp.Start;
    writeln;
end.
