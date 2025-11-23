program uptime;
{$linklib c}

uses
    clocale,
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
    users: integer = 0;
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

        'p':
            writeln('Not implemented');
    ed;
ed;

begin
    if sysinfo(@inf) <> 0 then bg
        die('sysinfo() failed: ' + StrError(FpGetErrno));
    ed;

    OptionHandler := @OptHandler;
    custcustapp.Start;
end.
