{$push}
    {$warn 5028 off} // Unused resourcestring

resourcestring
    CC_VERSION_STR      = 'Commands-Collection (CC) version %s';
    CC_TARGET_STR       = 'Built for %s on %s CPU using FPC %s';
    CC_BUILD_DATE       = 'Built on %s';
    HELP_USAGE          = 'Show this help and exit';
    VERSION_USAGE       = 'Show the version of this program and exit';
    VERBOSE_USAGE       = 'Add verbosity';
    ARGPAIRS_USAGE      = 'Use pairs of arguments - check cc-argument-pairs(7)';
    UNDOCUMENTED        = '[REDACTED]';

    OPT_NEED_VAL        = '%s requires a value';
    OPT_NO_VAL_NEEDED   = '%s does not require a value';
    OPT_UNKNOWN         = 'unrecognized option: %s';
    OPT_PAIR_NOT_ENOUGH = 'not enough item for a pair: %d required, got %d';

{$warn 3177 off} // Uninitialized fields
{$define ARGA_VERBOSE :=
    (Long: 'verbose'; Kind: FLAG; Short: 'v'; Help: VERBOSE_USAGE)
}
{$define ARGA_USE_PAIRS :=
    (Long: 'use-pairs'; Kind: FLAG; Short: #0; Help: ARGPAIRS_USAGE)
}
{$define ARGA_SUFFIX :=
    (Long: 'help';    Kind: FLAG; Short: 'h'; Help: HELP_USAGE),
    (Long: 'version'; Kind: FLAG; Short: 'V'; Help: VERSION_USAGE),
    (Long: '';        Kind: FLAG; Short: #0; Help: '')
}
{$I config.inc}
{$if defined(ALLOW_PAIRS) and defined(PAIR_NUM)}
    {$if PAIR_NUM < 2}
        {$fatal PAIR_NUM is BELOW TWO!}
    {$endif}
{$endif}

fn TOption.IsEmpty: bool;
begin
    Result := (Short = #0) and (Long = '') and (Help = '');
end;

fn TOption.WriteFullHelpMessage: string;
begin
    if IsEmpty then
        return('');

    if Help = '' then
        Help := UNDOCUMENTED;

    Result := ANSI_CODE_BOLD;

    if (Short <> '') or (Short <> #0) then
        Result += ('-' + Short + ' ');

    if Long <> '' then
        Result += ('--' + Long);

    Result += ANSI_CODE_RESET;

    if Kind <> FLAG then
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
