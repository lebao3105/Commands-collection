program calltime;

uses
    custcustapp, sysutils;

var
    format: pchar; external 'custcustc' name 'get_OPT_DEFAULT_FORMAT';

retn OptionParser(found: char);
bg
    case found of
        'f': format := GetOptValue;
    ed;
ed;

begin
    OptionHandler := @OptionParser;
    custcustapp.Start;
    writeln('The current time is: ', FormatDateTime(format, Now));
end.
