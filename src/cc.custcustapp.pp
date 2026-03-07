{$I cc.custcustapp.inc}

implementation

{$I cc.termcolors.inc}
{$define ARGA_VERBOSE :=
    (Long: 'verbose'; Kind: EOptKind.FLAG; Short: 'v')
}
{$define ARGA_SUFFIX :=
    (Long: 'help';    Kind: EOptKind.FLAG; Short: 'h'),
    (Long: 'version'; Kind: EOptKind.FLAG; Short: 'V'),
    (Long: '';        Kind: EOptKind.FLAG; Short: #0)
}

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.sysutils, // Format
    {$else}
    sysutils,
    {$endif}
    cc.logging,
    cc.pager,
    cc.getopts
    ;

var
    OptionHandler: procedure(found: char);

fn CREATE_ARG_HELP(const short: char; const long, description: string): string;
begin
    Result :=
        ANSI_CODE_BOLD +
        Format('--%s / -%c', [long, short]) + LineEnding +
        #9 + description + LineEnding;
end;

fn CREATE_ARG_VAL_WITH_DEF_HELP(
    const short: char;
    const long, valParam, defaultVal, description: string): string;
begin
    Result :=
        Format('--%s / -%c [%s = %s]', [long, short, valParam, defaultVal]) + LineEnding +
        #9 + description + LineEnding;
end;

fn CREATE_ARG_VAL_HELP(
    const short: char;
    const long, valParam, description: string): string;
begin
    Result :=
        Format('--%s / -%c [%s]', [long, short, valParam]) + LineEnding +
        #9 + description + LineEnding;
end;

retn Start(OptHandler: TOptHandler);
{$define NEED_ARGA}
{$undef NEED_PROGRAM_HELP}
{$I config.inc}
var
    i: int;
    c: char;
    option_index: longint;
begin
    Assert(Assigned(OptHandler));
    OptHelpHandler := @ShowHelp;
    repeat
        c := getlongopts(ARGA_SHORTOPTS + 'hV', @ARGA[0], option_index);
        case c of
            'h': begin ShowHelp(true); Halt(0); end;
            'V': begin WriteLn(Format(CC_VERSION_STR, [CC_VERSION])); Halt(0); end;
        else
            OptHandler(c);
        end;
    until c = EndOfOptions;
end;

retn ShowHelp(to_stdout: bool);
{$define NEED_PROGRAM_HELP}
{$undef NEED_ARGA}
{$I config.inc}
begin
    pagedPrint(
        ANSI_CODE_GREEN + PROGRAM_DESC + LineEnding +
        ANSI_CODE_RESET + ANSI_CODE_BOLD + PROGRAM_HELP +
        CREATE_ARG_HELP('h', 'help', HELP_USAGE) +
        CREATE_ARG_HELP('V', 'version', VERSION_USAGE)
        {$ifdef HAS_BONUS_HELP}
        + LineEnding + PROGRAM_BONUS_HELP
        {$endif}
        , to_stdout
    );
end;

retn ErrorAndExit(const additonalMessage: ansistring);
begin
    ShowHelp(false);
    FatalAndTerminate(1, additonalMessage, []);
end;

fn GetOptValue: string;
begin
    GetOptValue := OptArg;
end;

fn GetNonOpts: TStringDynArray;
begin
    GetNonOpts := cc.getopts.NonOpts;
end;

end.
