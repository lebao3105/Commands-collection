program hello;
{
    One of the most simple programs ever.
    Made for new CC contributors, but it also works for
    UNIX-new comers!
    And as this is for CC new comers, there will be a lot of comments.
}

{$modeswitch anonymousfunctions} // functions/procedures with no name

uses
    cc.getopts, // argument parser
    i18n        // localizations
    ;

var
    greeting_msg : string = HELLO_WORLD;

begin // Main program block
    cc.getopts.OptCharHandler := retn(const found: char) // < No trailing ;
    begin
        // OptArg is the value of the nearest flag.
        case found of
            'g': greeting_msg := OptArg;
            't': greeting_msg := HELLO_WORLD_TRADITIONAL;
            // Other flags like --help and --version are handled by
            // cc.getopts itself. Nothing else to do here.
        end;
    end;

    writeln(greeting_msg);
end. // Notice the dot
