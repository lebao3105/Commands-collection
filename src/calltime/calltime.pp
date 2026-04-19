program calltime;
{$modeswitch anonymousfunctions}

uses
    cc.getopts,
    {$ifdef FPC_DOTTEDUNITS}
    system.sysutils
    {$else}
    sysutils
    {$endif}
    ;

{$I i18n.inc}
var
    format: string = DEFAULT_FORMAT;

begin
    cc.getopts.OptCharHandler := retn (const found: char)
    begin
        case found of
            'f': format := OptArg;
        end;
    end;
    cc.getopts.GetOpt;
    writeln(TIME_IS, FormatDateTime(format, Now));
end.
