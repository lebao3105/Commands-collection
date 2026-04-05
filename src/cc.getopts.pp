{$I cc.getopts.inc}

implementation

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.sysutils, // Format
    {$else}
    sysutils,
    {$endif}
    cc.base,
    cc.console,
    cc.logging
    ;

resourcestring
    CC_VERSION_STR = 'Commands-Collection (CC) version %s';
    // TRANSLATORS:          OS v  CPU v
    CC_TARGET_STR  = 'Built for %s on %s using FPC %s';
    CC_BUILD_DATE  = 'Built on %s';
    HELP_USAGE     = 'Show this help and exit';
    VERSION_USAGE  = 'Show the version of this program and exit';
    VERBOSE_USAGE  = 'Add verbosity';

    OPT_NEED_VAL  = 'option %s requires an argument';
    OPT_UNKNOWN   = 'unrecognized option: %s';

{$define ARGA_VERBOSE :=
    (Long: 'verbose'; Kind: EOptKind.FLAG; Short: 'v'; Help: VERBOSE_USAGE)
}
{$define ARGA_SUFFIX :=
    (Long: 'help';    Kind: EOptKind.FLAG; Short: 'h'; Help: HELP_USAGE),
    (Long: 'version'; Kind: EOptKind.FLAG; Short: 'V'; Help: VERSION_USAGE),
    (Long: '';        Kind: EOptKind.FLAG; Short: #0; Help: '')
}

{$ifndef PASDOC}
{$I config.inc}
{$endif}
{$I cc.termcolors.inc}

fn TOption.WriteFullHelpMessage(defaultVal: string = ''; valParam: string = 'VALUE'): string;
begin
    if Short = #0 then
        return;

    Result := '';
    Result += ANSI_CODE_BOLD;

    if Long <> '' then
        Result += ('--' + Long + '  ');
    
    // TOption.Short must not be empty as it's used for command-
    // line parsing task. However ARGAs are terminated with 0ed
    // entry, which of course has its Short a #0. Already been
    // handled above.
    Result += ('-' + Short + ANSI_CODE_RESET);

    if Kind <> EOptKind.FLAG then
    begin
        if Long <> '' then Result += '  ';
        Result += valParam;

        if defaultVal <> '' then
            Result += (' = ' + defaultVal);
    end;

    Result += (CRNL + #9 + Help);
end;

retn ShowHelp(to_stdout: bool);
begin
{$ifndef PASDOC}
    setOutputStream(not to_stdout);
    writeln(OutputFile, PROGRAM_DESC);

    specialize TTypeHelper<TOption>.ArrayForEach(ARGA,
    fn (const opt: TOption): bool
    begin
        writeln(OutputFile, opt.WriteFullHelpMessage());
        return(false);
    end);

    {$ifdef HAS_BONUS_HELP}
    writeln(OutputFile, PROGRAM_BONUS_HELP);
    {$endif}
{$endif}
end;

{$ifndef PASDOC}
var
    NextChar: LongInt;

retn Meh(message: string; args: array of const); overload;
begin
    ShowHelp({ to_stdout } false);
    FatalAndTerminate(1, message, args);
end;

retn Meh(opt: TOption; message: string; args: array of const); overload;
begin
    setOutputStream(true);
    writeln(OutputFile, opt.WriteFullHelpMessage);
    FatalAndTerminate(1, message, args);
end;

fn Internal_getopt (long_only : boolean) : char;
var
    exact: bool;
    optName, optValue: string;
    foundOptPos: int;
    eqPos: int; // position of the first equal sign

    fn currentArg: string; inline;
    begin
        return(specialize TTypeHelper<string>.IfThenElse(
            optind < argc, argv[optind], ''
        ));
    end;

    fn isALongOption: bool; inline;
    begin // -- doesn't count
        Result := (length(currentArg) = 2) and
                  (currentArg[1] = OptSpecifier) and
                  (currentArg[2] = OptSpecifier);
    end;

    fn nameToFlag: string;
    begin
        if optName = '' then return('');
        return(specialize TTypeHelper<string>.IfThenElse(
            length(optName) > 1, '--' + optName, '-' + optName
        ));
    end;

    retn appendAllNonOptions;
    var i: int;
    begin
        SetLength(NonOpts, argc - optind);
        for i := optind to argc do
            NonOpts[i - optind] := string(argv[i]);
    end;

begin
    // Initialize if needed.
    OptArg := '';
    if OptInd = 0 then begin
        OptInd := 1;
        NextChar := 0;
    end;
    
    if nextchar = 0 then
    begin
        {$ifdef ALLOW_DOUBLE_SPECIFIER}
        // Now check if the current argument is --.
        if currentArg = OptDoubleSpecifier then
        begin
            appendAllNonOptions;
            OptInd := argc;
            return(EndOfOptions);
        end;
        {$endif}

        // Are we at the end?
        if OptInd >= argc then
            return(EndOfOptions);
        
        // Are we at a non-option?
        if (currentArg[1] <> OptSpecifier) or (length(currentArg) = 1) then
        begin
            // intentional for handling options with required/optional value
            optValue := currentArg;

            SetLength(NonOpts, Length(NonOpts) + 1);
            NonOpts[High(NonOpts)] := optValue;

            inc(optind);
            return(#0);
        end;

        // At this point we're at a long option...
        nextchar := 2;
        if long_only and isALongOption then
            inc(nextchar);
            // Now it points at the first character of an option
    end;

    // Now handle long options
    if isALongOption then
    begin
        // Get option name
        eqPos := Pos('=', currentArg);
        if eqPos = 0 then
            eqPos := length(currentArg) + 1;

        optName := Copy(currentArg, nextchar, eqPos - nextchar);

        // Get option value, if any
        // This disallows combinations of short flags, which means
        // one has to use -l -a instead of -la.
        if eqPos < Length(currentArg) then
            optValue := Copy(currentArg, eqPos + 1, Length(currentArg) - eqPos);
    end

    // Handle short options
    else begin
        optName := Copy(currentArg, nextchar, 1); // short option is always 1 char

        // If there is a value, e.g -x5 where 5 is the value, get it too
        if length(currentArg) > 2 then
            optValue := Copy(currentArg, nextchar + 1, Length(currentArg) - 2);
    end;

    // Now time to use ARGA
    exact := false;
    foundOptPos := 0;

    specialize TTypeHelper<TOption>.ArrayForEachIndex(ARGA,
    fn (const indx: smallint; const opt: TOption): bool
    begin
        if exact then
            return(true);

        if (optName = opt.Long) or (optName = opt.Short) then
        begin
            exact := true;
            foundOptPos := indx;
            return(true);
        end;

        return(false);
    end);

    if not exact then
        Meh(OPT_UNKNOWN, [ optName ]);
    
    with ARGA[foundOptPos] do
    begin
        Result := Short;

        if Kind <> EOptKind.FLAG then
        begin
            if (optValue = '') and (Kind = EOptKind.FLAG_WITH_VAL) then
                Meh(ARGA[foundOptPos], OPT_NEED_VAL, [ nameToFlag ]);
            OptArg := optValue;
        end;
    end;

    Inc(OptInd);
    NextChar := 0;
end;

retn parseLoop(long_only: boolean);
var c: char;
begin
    if ParamCount > 0 then
    repeat
        c := Internal_getopt(long_only);
        case c of
            'h': begin ShowHelp(true); halt(0); end;
            'V': begin
                writeln(Format(CC_VERSION_STR, [CC_VERSION]));
                writeln(Format(CC_TARGET_STR, [ {$I %FPCTARGETOS%}, {$I %FPCTARGETCPU%}, {$I %FPCVERSION%} ]));
                writeln(Format(CC_BUILD_DATE, [ {$I %DATE%}, {$I %TIME%}]));
                halt(0);
            end;
        else
            OptCharHandler(c);
        end;
    until c = EndOfOptions;
end;

retn GetOpt;
begin
    parseLoop(false);
end;

retn GetLongOpts;
begin
    parseLoop(true);
end;
{$else}
retn GetOpt;
begin
end;

retn GetLongOpts;
begin
end;
{$endif}

end.
