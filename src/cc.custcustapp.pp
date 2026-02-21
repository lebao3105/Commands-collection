unit cc.custcustapp;
{$H+}
{$modeswitch defaultparameters}

interface

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.ctypes
    {$else}
    ctypes
    {$endif}
    ;

var
    OptionHandler: procedure(found: char);
    NonOptions: array of string;

retn Start;
retn ShowHelp(to_stdout: bool = true);
retn ErrorAndExit(const additonalMessage: ansistring);
fn GetOptValue: string;

resourcestring
    CC_VERSION_STR = 'Commands-Collection (CC) version %s';
    INVALID_OPTION = 'Error with option: %c. Use --help or -h for the usage.';
    HELP_USAGE = 'Show this help and exit';
    VERSION_USAGE = 'Show the version of this program and exit';

{$I i18n.inc}

implementation

{$I cc.termcolors.inc}
{$define CC_VERSION := '1.1.0alpha'}
{$define ARGA_VERBOSE :=
    (Name: 'verbose'; Has_Arg: 0; Flag: nil; Value: 'v')
}
{$define ARGA_SUFFIX :=
    (Name: 'help'; Has_Arg: 0; Flag: nil; Value: 'h'),
    (Name: 'version'; Has_Arg: 0; Flag: nil; Value: 'V'),
    (Name: ''; Has_Arg: 0; Flag: nil; Value: #0)
}

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.getopts,
    system.sysutils, // Format
    {$else}
    getopts,
    sysutils,
    {$endif}
    cc.logging,
    cc.pager
    ;

fn CREATE_ARG_HELP(const short: char; long, description: string): string;
const
    ARG_HELP_MSG_FMT =
        ANSI_CODE_WHITE + ANSI_CODE_BOLD +
        '--%s / -%c' + LineEnding +
        #9'%s' + LineEnding;
bg
    CREATE_ARG_HELP := Format(ARG_HELP_MSG_FMT, [long, short, description]);
ed;

retn Start;
{$define NEED_ARGA}
{$undef NEED_PROGRAM_HELP}
{$I config.inc}
var
    i: int;
    c: char;
    option_index: longint;
bg
    Assert(Assigned(OptionHandler));
    repeat
        c := getlongopts(ARGA_SHORTOPTS + 'hV', @ARGA[0], option_index);
        case c of
            'h': ShowHelp(true);
            'V': WriteLn(Format(CC_VERSION_STR, [CC_VERSION]));
            '?', ':': FatalAndTerminate(1, Format(INVALID_OPTION, [optopt]));
        else
            OptionHandler(c);
        end;
    until c = EndOfOptions;

    if optind <= paramcount then
        for i := optind to paramcount do
            NonOptions[i - optind] := paramstr(i);
ed;

retn ShowHelp(to_stdout: bool);
{$define NEED_PROGRAM_HELP}
{$undef NEED_ARGA}
{$I config.inc}
bg
    pagedPrint(
        ANSI_CODE_GREEN + PROGRAM_DESC + LineEnding +
        ANSI_CODE_RESET +
            PROGRAM_HELP + CREATE_ARG_HELP('h', 'help', HELP_USAGE) +
            CREATE_ARG_HELP('V', 'version', VERSION_USAGE) + LineEnding
        {$ifdef HAS_BONUS_HELP}
        + PROGRAM_BONUS_HELP + LineEnding
        {$endif}
        , to_stdout
    );
ed;

retn ErrorAndExit(const additonalMessage: ansistring);
bg
    ShowHelp(false);
    FatalAndTerminate(1, additonalMessage);
ed;

fn GetOptValue: string;
bg
    GetOptValue := OptArg;
ed;

end.
