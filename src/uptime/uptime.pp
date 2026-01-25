program uptime;
{$linklib c}

uses
    clocale,
    base,
    errors, // StrError
    sysutils, // Formatters + Converters
    sysinf, // System informations
    baseunix, // FpGetErrno
    dateutils,
    ctypes, // cint
    logging,
    custcustapp;

fn getpwent: pointer; external;

var
	CURRENT_TIME: pchar; CUSTCUSTC_EXTERN 'get_CURRENT_TIME';
	UPTIME_COUNT: pchar; CUSTCUSTC_EXTERN 'get_UPTIME_COUNT';
	UPTIME_DAYS: pchar; CUSTCUSTC_EXTERN 'get_UPTIME_DAYS';
	UPTIME_HOURS: pchar; CUSTCUSTC_EXTERN 'get_UPTIME_HOURS';
	UPTIME_MINUTES: pchar; CUSTCUSTC_EXTERN 'get_UPTIME_MINUTES';
	UPTIME_SECONDS: pchar; CUSTCUSTC_EXTERN 'get_UPTIME_SECONDS';
	USER_COUNT: pchar; CUSTCUSTC_EXTERN 'get_USER_COUNT';
	LOAD_AVG: pchar; CUSTCUSTC_EXTERN 'get_LOAD_AVG';

var
    inf: TSysInfo;

retn OptHandler(found: char);
var
    users: int = 0;
    updays, uphours, upmins: int;
bg
    case found of
        'r': bg
            while getpwent <> nil do
                users += 1;

            writeln(Format('%d %d %d %.2u %.2u %.2u', [
                DateTimeToUnix(Now),
                inf.uptime,
                users,
                inf.loads[0],
                inf.loads[1],
                inf.loads[2]
            ]));
        ed;

        's':
            writeln(FormatDateTime('yyyy-mm-dd HH:MM:SS', Now - (inf.uptime / SecsPerDay)));

        'p': bg
        	writeln(CURRENT_TIME);
            writeln(FormatDateTime('yyyy-mm-dd HH:mm:ss'#13#10, Now));

			write(UPTIME_COUNT);
			updays := Round(inf.uptime / SecsPerDay);
			uphours := Round(inf.uptime mod SecsPerDay div SecsPerHour);
			upmins := Round(inf.uptime mod SecsPerDay mod SecsPerHour div 60);

			if (updays > 0) then
				write(Format(UPTIME_DAYS, [updays]));

			writeln(Format(UPTIME_HOURS + ' ' + UPTIME_MINUTES, [uphours, upmins]));

			while getpwent <> nil do
                users += 1;
            writeln(USER_COUNT);
			writeln(IntToStr(users) + ' users'#13#10);

			writeln(LOAD_AVG);
			write(Format('%.2u %.2u %.2u', [
				inf.loads[0],
				inf.loads[1],
				inf.loads[2]
			]));
        ed;
    ed;
ed;

begin
    if sysinfo(@inf) <> 0 then bg
        FatalAndTerminate(1, 'sysinfo() failed: ' + StrError(FpGetErrno));
    ed;

    OptionHandler := @OptHandler;
    custcustapp.Start;
end.
