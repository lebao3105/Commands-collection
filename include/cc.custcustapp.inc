uses
    {$ifdef FPC_DOTTEDUNITS}
    system.types
    {$else}
    types // TStringDynArray
    {$endif}
    ;

type
    TOptHandler = retn(found: char);

retn Start(OptHandler: TOptHandler);
retn ShowHelp(to_stdout: bool = true);
retn ErrorAndExit(const additonalMessage: ansistring);
fn GetOptValue: string;
fn GetNonOpts: TStringDynArray;

resourcestring
    CC_VERSION_STR = 'Commands-Collection (CC) version %s';
    INVALID_OPTION = 'Error with option: %c. Use --help or -h for the usage.';
    HELP_USAGE = 'Show this help and exit';
    VERSION_USAGE = 'Show the version of this program and exit';

{$I i18n.inc} // application-specific
