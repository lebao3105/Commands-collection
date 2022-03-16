program file_date;
{$mode objFPC}

uses
    sysutils;

var
    i : integer;
    n : longint;

begin
    if ParamCount = 0 then
    begin
        writeln('Missing arguments');
        halt(1);
    end else begin
        for i := 1 to ParamCount do
        begin
            try
                n := FileAge(ParamStr(i));
                writeln('Result: File created on ', DateTimeToStr(FileDateToDateTime(n)));
            except
                on E: EInOutError do
                    writeln('Error occured while reading file: ', E.Message);
            end;
            FileClose(ParamStr(i));
            halt(0);
        end;
    end;
end.