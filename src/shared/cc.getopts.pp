{$I cc.getopts.inc}

implementation

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.sysutils, // Format
    {$else}
    sysutils,
    {$endif}

    {$ifndef NO_PROG}
    i18n,
    {$endif}
    cc.console,
    cc.logging
    ;

{$define ARGA_VERBOSE :=
    (Long: 'verbose'; Kind: EOptKind.FLAG; Short: 'v'; Help: VERBOSE_USAGE)
}
{$define ARGA_SUFFIX :=
    (Long: 'help';    Kind: EOptKind.FLAG; Short: 'h'; Help: HELP_USAGE),
    (Long: 'version'; Kind: EOptKind.FLAG; Short: 'V'; Help: VERSION_USAGE),
    (Long: '';        Kind: EOptKind.FLAG; Short: #0; Help: '')
}
{$define ARGA_USE_PAIRS :=
    (Long: 'use-pairs'; Kind: EOptKind.FLAG; Short: #0; Help: '')}

{$push}
    {$warn 5028 off} // Unused resourcestring
resourcestring
    CC_VERSION_STR      = 'Commands-Collection (CC) version %s';
    // TRANSLATORS:               OS v  CPU v
    CC_TARGET_STR       = 'Built for %s on %s using FPC %s';
    CC_BUILD_DATE       = 'Built on %s';
    HELP_USAGE          = 'Show this help and exit';
    VERSION_USAGE       = 'Show the version of this program and exit';
    VERBOSE_USAGE       = 'Add verbosity';
    UNDOCUMENTED        = 'Use pairs of arguments - check cc-argument-pairs(7)';

    OPT_NEED_VAL        = 'option %s requires an argument';
    OPT_UNKNOWN         = 'unrecognized option: %s';
    OPT_PAIR_NOT_ENOUGH = 'not enough item for a pair: %d required, got %d';

{$ifndef NO_PROG}
    {$push}
        {$warn 3177 off} // Uninitialized fields
    {$I config.inc}
    {$if defined(ALLOW_PAIRS) and defined(PAIR_NUM)}
        {$if PAIR_NUM < 2}
            {$fatal PAIR_NUM is BELOW TWO!}
        {$endif}
    {$endif}
{$endif}
{$I cc.termcolors.inc}

fn TOption.WriteFullHelpMessage: string;
begin
    if IsEmpty then
        return('');

    Result := ANSI_CODE_BOLD;

    if (Short <> '') or (Short <> #0) then
        Result += ('-' + Short + ANSI_CODE_RESET + ' ');

    if Long <> '' then
        Result += ('--' + Long);

    if Kind <> EOptKind.FLAG then
    begin
        if Long <> '' then
            Result += '  ';

        if ValParam = '' then
            ValParam := 'VALUE';

        Result += ValParam;

        if defaultVal <> '' then
            Result += (' = ' + defaultVal);
    end;

    if Help = '' then
        Help := UNDOCUMENTED;
    Result += (CRNL + #9 + Help);
end;

fn TOption.IsEmpty: bool;
begin
    Result := (Short = #0) and (Long = '');
end;

{$ifndef NO_PROG}
retn ShowHelp(to_stdout: bool);
begin
    setOutputStream(not to_stdout);
    writeln(OutputFile, PROGRAM_DESC);

    ArrayForEach(ARGA,
    fn (opt: TOption): bool
    begin
        writeln(OutputFile, opt.WriteFullHelpMessage);
        return(false);
    end);

    {$ifdef HAS_BONUS_HELP}
    writeln(OutputFile, PROGRAM_BONUS_HELP);
    {$endif}
end;

var foundOptPos: uint8; // index in ARGA where the option was found
    lastArgNeedsAValue: bool = false;

retn needAValue(optName: string);
begin
    setOutputStream(true);
    writeln(OutputFile, ARGA[foundOptPos].WriteFullHelpMessage);
    FatalAndTerminate(1, OPT_NEED_VAL, [ optName ]);
end;

fn Internal_getopt: char;
var
    exact: bool;
    optName, optValue, currentArg: string;
    firstCatchIdx, // index in currentArg that is not leading dashes
    eqPos,         // position of the first equal sign
    argLen,        // length of currentArg
    nextChar       // the first index after leading dashes
        : uint32;

begin
    // Are we at the end?
    if OptInd = argc then
    begin
        if lastArgNeedsAValue then
            needAValue(ParamStr(OptInd - 1));
        return(EndOfOptions);
    end;

    nextChar := 0;
    currentArg := ParamStr(optInd);
    Assert(currentArg <> '');
    argLen := Length(currentArg);

    // Is this a non-option?
    if (argLen = 1) or (currentArg[1] <> OptSpecifier) or lastArgNeedsAValue then
    begin
        if lastArgNeedsAValue then begin
            lastArgNeedsAValue := false;
            OptArg := currentArg;
        end
        else begin
            SetLength(NonOpts, Length(NonOpts) + 1);
            NonOpts[High(NonOpts)] := currentArg;
        end;

        inc(optind);
        return(#0);
    end;

    {$ifdef ALLOW_DOUBLE_SPECIFIER}
    // Now check if the current argument is --.
    if currentArg = OptDoubleSpecifier then
    begin
        retn(); var i: int;
        begin
            SetLength(NonOpts, argc - optind);
            for i := optind to argc - 1 do
                NonOpts[i - optind] := ParamStr(i);
        end();
        OptInd := argc;
        return(EndOfOptions);
    end;
    {$endif}

    // At this point we're at the start of an option...
    // nextchar now points to the first character of that option
    // (skipping the dashes of course)
    nextChar := 2;

    // Pos(sub, source)
    // 0 if sub is not present in source.
    if (argLen > 2) and
        (currentArg[1] = OptSpecifier) and
        (currentArg[2] = OptSpecifier) then
    begin // long options
        // Get option name
        eqPos := Pos('=', currentArg);
        if eqPos = 0 then
            optName := Copy(currentArg, nextChar)
        else begin
            optName := Copy(currentArg, nextchar, eqPos - nextchar);

            // Get option value, if any.
            // This disallows combinations of short flags, which means
            // one has to use -l -a instead of -la.
            optValue := Copy(currentArg, eqPos + 1, argLen - eqPos);
        end;
    end

    // Copy(source, startIdx, count)
    // startIdx is 1-based, count can be omitted
    else
    begin // short options
        optName := currentArg[nextChar];

        // If there is a value, e.g -x5 where 5 is the value, get it too
        if argLen > 2 then
            optValue := Copy(currentArg, nextchar + 1);
    end;

    Assert(optName <> '');

    // Now time to use ARGA
    exact := false;
    foundOptPos := 0;
    Inc(OptInd);

    ArrayForEachIndex(ARGA,
    fn (const indx: smallint; opt: TOption): bool
    begin
        if (optName = opt.Long) or (optName = opt.Short) then
        begin
            exact := true;
            foundOptPos := indx;
            return(true);
        end;

        return(false);
    end);

    if not exact then begin
        ShowHelp({ to_stdout } false);
        FatalAndTerminate(1, OPT_UNKNOWN, [ optName ]);
    end;

    with ARGA[foundOptPos] do
    begin
        if Short <> #0 then
        begin
            Result := Short;
            OptIsLongOnly := false;
        end

        {$ifdef ALLOW_PAIRS}
        else if Long = 'use-pairs' then begin
            OptIsLongOnly := false;
            Result := #0;
            OptHasPairs := true;
            exit;
        end
        {$endif}

        else begin
            Result := Long[1];
            OptIsLongOnly := true;
            {$ifdef ALLOW_PAIRS}
            OptHasPairs := false;
            {$endif}
        end;

        if Kind <> EOptKind.FLAG then
        begin
            lastArgNeedsAValue := optValue = '';
            if not lastArgNeedsAValue then
                OptArg := optValue;
        end;
    end;
end;

retn GetOpt;
var c: ansichar;
begin
    if ParamCount > 0 then
    repeat
        c := Internal_getopt;
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

    {$ifdef ALLOW_PAIRS}
    if (Length(NonOpts) mod PAIR_NUM) <> 0 then
    begin
        ShowHelp(false);
        FatalAndTerminate(1, OPT_PAIR_NOT_ENOUGH, [ PAIR_NUM, Length(NonOpts) div PAIR_NUM ]);
    end;
    {$endif}
end;
{$else}

retn ShowHelp(to_stdout: bool); begin end;
retn GetOpt; begin end;

{$endif NO_PROG}

fn GetArgPairs: TArrayOfStringDynArray;
{$if defined(ALLOW_PAIRS)}
{$push}{$warn 5093 off}{$warn 5091 off}
var
    i, j: smallint;
    resp: TArrayOfStringDynArray; // FPC won't let us use Result directly, at least in 3.3.1
begin
    if not OptHasPairs then return;

    // TODO: Throw errors
    SetLength(resp, Length(NonOpts) div PAIR_NUM);

    i := 0;
    j := 0;

    ArrayForEachIndex(NonOpts,
        fn (const indx: smallint; opt: string): bool
        begin
            if indx mod 2 = 0 then
            begin
                SetLength(resp[i], PAIR_NUM);
                j := 0;
                resp[i, j] := opt;
                inc(i);
                inc(j);
                return(false);
            end;

            resp[i - 1, j] := opt;
            inc(j);
            return(false);
        end);

    return(resp);
end;
{$pop}
{$else}
    begin
    end;
{$endif}

end.
{$pop}
