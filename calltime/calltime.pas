program calltime;
{$mode objFPC}

uses
    classes, custapp, dos;

type TCallTime = class(TCustomApplication)
protected
    procedure DoRun; override;
end;

var
    CallTimeApp: TCallTime;
    hr, min, sec, msec: word;

// if the time is < 10, add a 0 before it
// e.g 6 hours < 10 hours, so this function will return 06 (hours)
// function taken from freepascal wiki
function addzero(w:word):string;
var
    s:string;
begin
    Str(w, s);
    if w < 10 then
        addzero := '0' + s
    else
        addzero := s;
end;

procedure TCallTime.DoRun;
var
    errorMsg: string;
begin
    errorMsg := CheckOptions('h', ['help', 'no-msec']);
    if errorMsg <> '' then begin writeln(errorMsg); halt(1); end;

    if HasOption('h', 'help') then
    begin
        writeln(ParamStr(0), ' [flag]');
        writeln('Use --help/-h flag to show this message (again).');
        writeln('--no-msec to disable showing miliseconds.');
        halt(0);
    end;

    write('The current time is: ', addzero(hr) + ':' + addzero(min) + ':' + addzero(sec));
    if not HasOption('no-hsec') then
        writeln(addzero(msec));
end;

begin
    GetTime(hr, min, sec, msec);
    CallTimeApp := TCallTime.Create(nil);
    CallTimeApp.StopOnException := true;
    CallTimeApp.Run;
    CallTimeApp.Free;
end.