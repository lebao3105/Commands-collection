program calltime;
{$mode objFPC}
uses
    Dos;

var
    i: integer;
    hr, min, sec, hsec: word;

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

begin
    GetTime (hr, min, sec, hsec);
    write ('The current time is: ');
    if ParamCount = 0 then
        writeln(addzero(hr) + ':' + addzero(min) + ':' + addzero(sec) + ':' + addzero(hsec))
    else begin
        for i := 1 to ParamCount do
            if ParamStr(i) = '/no_hsec' then
                writeln(addzero(hr) + ':' + addzero(min) + ':' + addzero(sec))
            else if ParamStr(i) = '/?' then begin
                writeln('calltime by Le Bao Nguyen');
                writeln('Prints the current time (not include date)');
                writeln('Use /no_hsec to disable showing the hundredth of a second');
            end;
    end;
end.