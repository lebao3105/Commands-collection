program calltime;

uses
    cc.custcustapp,
    {$ifdef FPC_DOTTEDUNITS}
    system.sysutils
    {$else}
    sysutils
    {$endif}
    ;

var
	TIME_IS:        pchar; CUSTCUSTC_EXTERN 'get_TIME_IS';
    DEFAULT_FORMAT: pchar; CUSTCUSTC_EXTERN 'get_OPT_DEFAULT_FORMAT';

    format: string;

retn OptionParser(found: char);
bg
    case found of
        'f': format := GetOptValue;
    ed;
ed;

begin
    format := string(DEFAULT_FORMAT);
    cc.custcustapp.OptionHandler := @OptionParser;
    cc.custcustapp.Start;
    writeln(TIME_IS, FormatDateTime(format, Now));
end.
