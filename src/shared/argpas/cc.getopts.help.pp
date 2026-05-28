{$push}
    {$warn 5028 off} // Unused resourcestring

resourcestring
    CC_VERSION_STR      = 'Commands-Collection (CC) version %s';
    /// TRANSLATORS:               OS v  CPU v
    CC_TARGET_STR       = 'Built for %s on %s using FPC %s';
    CC_BUILD_DATE       = 'Built on %s';
    HELP_USAGE          = 'Show this help and exit';
    VERSION_USAGE       = 'Show the version of this program and exit';
    VERBOSE_USAGE       = 'Add verbosity';
    UNDOCUMENTED        = 'Use pairs of arguments - check cc-argument-pairs(7)';

    OPT_NEED_VAL        = '%s requires a value';
    OPT_NO_VAL_NEEDED   = '%s does not require a value';
    OPT_UNKNOWN         = 'unrecognized option: %s';
    OPT_PAIR_NOT_ENOUGH = 'not enough item for a pair: %d required, got %d';

{$ifndef NO_PROG}
    {$warn 3177 off} // Uninitialized fields
    {$I config.inc}
    {$if defined(ALLOW_PAIRS) and defined(PAIR_NUM)}
        {$if PAIR_NUM < 2}
            {$fatal PAIR_NUM is BELOW TWO!}
        {$endif}
    {$endif}
{$endif}

fn TOption.IsEmpty: bool;
begin
    Result := (Short = #0) and (Long = '');
end;

fn TOption.WriteFullHelpMessage: string;
begin
    if Help = '' then
        Help := UNDOCUMENTED;

    if IsEmpty then
        return(Help);

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

    Result += (CRNL + #9 + Help);
end;

retn ShowHelp(to_stdout: bool);
begin
{$ifndef NO_PROG}
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
{$endif}
end;
