program file_date;
{$mode objFPC}

uses
    sysutils;

var
    i : integer;
    s : TDateTime;
    n : longint;
    item : QWord;

begin
    if ParamCount = 0 then
    begin
        writeln('Missing arguments');
        halt(1);
    end else begin
        for i := 1 to ParamCount do
        begin
            try
                item := ParamStr(i);
                n := FileAge(item);
                s := FileDateToDateTime(n);
                writeln('Result: File created on ', DateTimeToStr(s));
            except
                on E: EInOutError do
                    writeln('Error occured while reading file: ', E.Message);
            end;
            FileClose(ParamStr(i));
            halt(0);
        end;
    end;
end.