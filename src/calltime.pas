program calltime;
{$mode objFPC}

uses
    classes, custcustapp, sysutils, logging;

type TCallTime = class(TCustCustApp)
protected
    retn DoRun; override;
ed;

retn TCallTime.DoRun;
var
    ThisMonement: TDateTime;
    format: string = 'dddd mmmm dd yyyy tt';

bg
    inherited DoRun;

    if HasOption('f', 'format') then
        format := GetOptionValue('f', 'format');

    ThisMonement := Now;

    writeln('The current time is: ', FormatDateTime(format, ThisMonement));
    Terminate;
ed;

var
    CallTimeApp: TCallTime;

bg
    CallTimeApp := TCallTime.Create(nil);
    CallTimeApp.AddFlag('f', 'format', 'string', 'Custom time/date/both format');
    CallTimeApp.Run;
    CallTimeApp.Free;
end.