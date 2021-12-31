program date;
(* This may be hard to make. I should done this before new year. 
   Listening to ABBA music this time is so special :) *)
uses sysutils; // load this library first, anyway
var 
    YY,MM,DD : Word;
    n : integer;
label help;
begin
    if ParamCount = 0 then begin
        writeln('The current time and date is: ', DateTimeToStr(Now));
        // use DateTimeToStr(Now) to print the current date & time in one time,
        // TimeToStr() just to print the time.
        help: begin
        writeln('--------------------------------------------------'); 
        writeln('date verison 1.0 - show the time and date');
        writeln('Some flags you can use:');
        writeln('--show-year :                 Show the current year. Which OS are you just installed?');
        writeln('--show-time :                 Show the time only;');
        writeln('--show-date :                 Show the current date;');
        writeln('--show-short-pls:             Use the short format (Only allow to --show-date)');
        writeln('--help :                      Show this help and exit. You may use date only which is much faster');
        writeln('                              then write this flag. Give it a chance please.');
        writeln('Note that this program will work with the following time foramt:');
        writeln(' ----  Day/Month/Year (DD/MM/YY) ---- ');
        exit; end;
    end
    else for n := 1 to ParamCount do begin // I've found a new way to detect argument
        if ParamStr(n) = '--show-year' then begin 
            DecodeDate(Date,YY,MM,DD);
            writeln('The current year is: %d',[YY]);
            exit;
        end;
        if ParamStr(n) = '--show-time' then begin
            writeln('The current time is (not include *seconds, date): ', TimeToStr(Now));
            exit;
        end;
        if ParamStr(n) = '--show-date' then begin
            if ParamStr(n) = '--show-short-pls' then begin
                writeln('Today is: ', LongDayNames[DayOfWeek(Date)]);
                exit; end
            else 
                DecodeDate(Date,YY,MM,DD);
                writeln('Today is: ', LongDayNames[DayOfWeek(Date)]
                            ,' ',[DD],' ',[MM],' ',[YY]);
                exit;
        end;
        if ParamStr(n) = '--help' then goto help;
    end;
end.
