program uptime;
{$linklib c}

uses
    {$ifdef FPC_DOTTEDUNITS}
    unixapi.base,
    unixapi.clocale,
    system.sysutils,
    system.dateutils,
    {$else}
    clocale,
    sysutils, // Formatters + Converters
    baseunix, // FpGetErrno
    dateutils,
    {$endif}
    cc.base,
    cc.sysinf, // System informations
    cc.logging,
    cc.getopts
    ;

fn getpwent: pointer; external;

{$I i18n.inc}

var
    inf: TSysInfo;

retn OptHandler(const found: char);
var
    users: int = 0;
    updays, uphours, upmins, upsecs: int;
begin
    case found of
        'r': begin
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
        end;

        's':
            writeln(FormatDateTime('yyyy-mm-dd HH:MM:SS', Now - (inf.uptime / SecsPerDay)));

        'p': begin
        	write(CURRENT_TIME); writeSp;
            writeln(FormatDateTime('yyyy-mm-dd HH:mm:ss'#13#10, Now));

			write(UPTIME_COUNT); writeSp;
			updays := Round(inf.uptime / SecsPerDay);
			uphours := Round(inf.uptime mod SecsPerDay div SecsPerHour);
			upmins := Round(inf.uptime mod SecsPerDay mod SecsPerHour div 60);
            upsecs := Round(inf.uptime mod 60);
			writeln(Format(UPTIME_FULL, [updays, uphours, upmins, upsecs]));

			while getpwent <> nil do
                users += 1;
            writeln(Format(USER_COUNT, [users]));

			write(LOAD_AVG); writeSp;
			writeln(Format('%.2u %.2u %.2u', [
				inf.loads[0],
				inf.loads[1],
				inf.loads[2]
			]));
        end;
    end;
end;

begin
    if sysinfo(@inf) <> 0 then
        FatalAndTerminate(1, SYSINF_FAIL, [StrError(FpGetErrno)]);

    cc.getopts.OptCharHandler := @OptHandler;
    cc.getopts.GetOpt;
end.
