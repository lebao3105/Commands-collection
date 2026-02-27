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

{$define LineEnding := #13#10} // crlf
{$I i18n.inc}
