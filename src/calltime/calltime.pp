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
    format: string = DEFAULT_FORMAT;

retn OptionParser(found: char);
begin
    case found of
        'f': format := GetOptValue;
    end;
end;

begin
    cc.custcustapp.OptionHandler := @OptionParser;
    cc.custcustapp.Start;
    writeln(TIME_IS, FormatDateTime(format, Now));
end.
