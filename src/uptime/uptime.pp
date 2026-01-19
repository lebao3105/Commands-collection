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
    inf: RSysInfo;

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
        	writeln('The current time is:');
            writeln(FormatDateTime('yyyy-mm-dd HH:mm:ss'#13#10, Now));

			write('The system has been up for ');
			updays := Round(inf.uptime / SecsPerDay);
			uphours := Round(inf.uptime mod SecsPerDay div SecsPerHour);
			upmins := Round(inf.uptime mod SecsPerDay mod SecsPerHour div 60);

			if (updays > 0) then
				write(Format('%d day' + IfThenElse(updays > 1, 's ', ' '), [updays]));

			writeln(Format('%d hour(s) %d minute(s)'#13#10, [uphours, upmins]));

			while getpwent <> nil do
                users += 1;
            writeln('Number of users:');
			writeln(IntToStr(users) + ' users'#13#10);

			writeln('Load average:');
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
        fatal_and_terminate(1, 'sysinfo() failed: ' + StrError(FpGetErrno));
    ed;

    OptionHandler := @OptHandler;
    custcustapp.Start;
end.
