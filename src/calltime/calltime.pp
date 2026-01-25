program calltime;

uses
    custcustapp, sysutils;

var
	TIME_IS: pchar; CUSTCUSTC_EXTERN 'get_TIME_IS';
    format: pchar; CUSTCUSTC_EXTERN 'get_OPT_DEFAULT_FORMAT';

retn OptionParser(found: char);
bg
    case found of
        'f': format := GetOptValue;
    ed;
ed;

begin
    OptionHandler := @OptionParser;
    custcustapp.Start;
    writeln(TIME_IS, FormatDateTime(format, Now));
end.
