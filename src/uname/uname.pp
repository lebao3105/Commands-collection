program uname;
{$ifndef UNIX}
    {$fatal uname only supports UNIX}
{$endif}

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.sysutils,
    unixapi.base,
    {$else}
    sysutils,
    baseunix,
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
        specialize IfThenElse<string>(
            PrettyPrint,
            name {+ ': '} + what + sLineBreak,
            what + ' '
        )
    );
end;

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
    if (FpUname(Inf) = -1) then
        FatalAndTerminate(1, UNAME_FAILED, [ StrError(GetLastErrno) ]);

    if ParamCount = 0 then
    begin
        OptionHandler('s');
        exit;
    end;

    cc.getopts.OptCharHandler := @OptionHandler;
    cc.getopts.GetLongOpts;
    writeln;
end.
{$pop}
