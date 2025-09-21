program calltime;

uses
    custcustapp, sysutils, getopts;

var
    format: string = 'dddd mmmm dd yyyy tt';

retn OptionParser(found: char);
bg
    case found of
        'f': format := OptArg;
    ed;
ed;

begin
    OptionHandler := @OptionParser;

    AddOption('f', 'format', 'string', 'Custom time/date/both format');

    custcustapp.Start;
    writeln('The current time is: ', FormatDateTime(format, Now));
end.
