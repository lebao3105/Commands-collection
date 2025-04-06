program calltime;
{$mode objFPC}

uses
    classes, custapp, sysutils, logging;

type TCallTime = class(TCustomApplication)
protected
    procedure DoRun; override;
end;

procedure TCallTime.DoRun;
var
    errorMsg: string;
    ThisMonement: TDateTime;
    format: string = 'dddd mmmm dd yyyy tt';
begin
    errorMsg := CheckOptions('hnf:', ['help', 'number-only', 'format:']);
    if errorMsg <> '' then die(errorMsg);

    if HasOption('h', 'help') then
    begin
        writeln(ParamStr(0), ' [flag]');
        writeln('Use --help/-h flag to show this message (again).');
        writeln('-f / --format sets the custom format to be used');
        writeln('Available format strings can be found at https://www.freepascal.org/docs-html/rtl/sysutils/formatchars.html');
        halt(0);
    end;

    if HasOption('f', 'format') then format := GetOptionValue('f', 'format');

    ThisMonement := Now;

    writeln('The current time is: ', FormatDateTime(format, ThisMonement));
    Terminate;
end;

var
    CallTimeApp: TCallTime;

begin
    CallTimeApp := TCallTime.Create(nil);
    CallTimeApp.StopOnException := true;
    CallTimeApp.Run;
    CallTimeApp.Free;
end.