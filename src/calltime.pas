program calltime;
{$mode objFPC}

uses
    classes, custcustapp, sysutils, logging;

type TCallTime = class(TCustCustApp)
protected
    procedure DoRun; override;
end;

procedure TCallTime.DoRun;
var
    ThisMonement: TDateTime;
    format: string = 'dddd mmmm dd yyyy tt';

begin
    inherited DoRun;

    if HasOption('f', 'format') then
        format := GetOptionValue('f', 'format');

    ThisMonement := Now;

    writeln('The current time is: ', FormatDateTime(format, ThisMonement));
    Terminate;
end;

var
    CallTimeApp: TCallTime;

begin
    CallTimeApp := TCallTime.Create(nil);
    CallTimeApp.AddFlag('f', 'format', 'string', 'Custom time/date/both format');
    CallTimeApp.Run;
    CallTimeApp.Free;
end.