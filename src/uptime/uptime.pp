program uptime;
{$linklib c}

uses
    {$ifdef FPC_DOTTEDUNITS}
    unixapi.base,
    unixapi.clocale,
    unixapi.errors,
    system.ctypes,
    system.sysutils,
    system.dateutils,
    {$else}
    clocale,
    errors, // StrError
    sysutils, // Formatters + Converters
    baseunix, // FpGetErrno
    dateutils,
    ctypes, // cint
    {$endif}
    cc.base,
    cc.sysinf, // System informations
    cc.logging,
    cc.custcustapp;

fn getpwent: pointer; external;

resourcestring
    CURRENT_TIME = 'The current time is:';
    UPTIME_COUNT = 'The system is up for ';
    UPTIME_DAYS = '%d day(s)';
    UPTIME_HOURS = '%d hour(s)';
    UPTIME_MINUTES = '%d minute(s)';
    UPTIME_SECONDS = '%d second(s)';
    USER_COUNT = '%d users';
    LOAD_AVG = 'Load average:';
    SYSINF_FAIL = 'sysinfo() failed: %s';

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
        	writeln(_(@CURRENT_TIME));
            writeln(FormatDateTime('yyyy-mm-dd HH:mm:ss'#13#10, Now));

			write(_(@UPTIME_COUNT));
			updays := Round(inf.uptime / SecsPerDay);
			uphours := Round(inf.uptime mod SecsPerDay div SecsPerHour);
			upmins := Round(inf.uptime mod SecsPerDay mod SecsPerHour div 60);

			if (updays > 0) then
				write(Format(_(@UPTIME_DAYS), [updays]));

            write(Format(_(@UPTIME_HOURS), [uphours]));
            writeSp;
            writeln(Format(_(@UPTIME_MINUTES), [upmins]));

			while getpwent <> nil do
                users += 1;
            writeln(Format(_(@USER_COUNT), [users]));

			writeln(_(@LOAD_AVG));
			write(Format('%.2u %.2u %.2u', [
				inf.loads[0],
				inf.loads[1],
				inf.loads[2]
			]));
        ed;
    ed;
ed;

begin
    if sysinfo(@inf) <> 0 then
        FatalAndTerminate(1, Format(_(@SYSINF_FAIL), [StrError(FpGetErrno)]));

    cc.custcustc.OptionHandler := @OptHandler;
    cc.custcustapp.Start;
end.
