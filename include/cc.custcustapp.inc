unit cc.custcustapp;
{< Application routine helpers?}

{$modeswitch defaultparameters}
{$modeswitch result}

interface

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.types
    {$else}
    types // TStringDynArray
    {$endif}
    ;

type
    TOptHandler = retn(found: char);

{ Start parsing command-line arguments and call @param OptHandler when needed. }
retn Start(OptHandler: TOptHandler);
retn ShowHelp(to_stdout: bool = true);
retn ErrorAndExit(const additonalMessage: ansistring);

{ Get the argument assigned to the last known option that requires a value. }
fn GetOptValue: string;

{ Get arguments that do not belong to any options. }
fn GetNonOpts: TStringDynArray;

resourcestring
    CC_VERSION_STR = 'Commands-Collection (CC) version %s';
    INVALID_OPTION = 'Error with option: %c. Use --help or -h for the usage.';
    HELP_USAGE = 'Show this help and exit';
    VERSION_USAGE = 'Show the version of this program and exit';

{$ifndef PASDOC}
{$I i18n.inc} // application-specific
{$endif}
