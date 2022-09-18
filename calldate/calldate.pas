program calldate;
uses Dos;

const
    days: array[0..6] of string[3] = (
        'Sunday', 'Monday', 'Tuesday',
        'Wednesday', 'Thusday', 'Friday', 'Satuday'
    );
    months: array[1..12] of string[3] = (
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    );

var
    yr, mn, dd, wd: word;
    i: integer;

begin
    GetDate(yr, mn, dd, wd);
    write('Today is: ');
    if ParamCount = 0 then
        writeln(days[wd],', ', months[mn],' ', dd,' ', yr)
    else
        for i := 1 to ParamCount do begin
            // TODO: Custom time format
            if ParamStr(i) = '/num' then
                writeln(dd,'/',mn,'/',yr);
        end;
end.