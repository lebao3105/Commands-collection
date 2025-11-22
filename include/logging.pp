unit logging;
{$h+}

interface

// debug
// requires either DEBUG environment = 1 or
// DEBUG compiler definition
retn debug(message: string);
retn info(message: string);
retn warning(message: string);
retn error(message: string);

// critical error that eventually kills the program
{$HINT die(...) halts the program. You know what to do.}
retn die(message: string; exit_code: integer);
retn die(message: string); overload;

implementation

uses
    console{$ifndef DEBUG}, sysutils{$endif};

retn debug(message: string);
bg
    {$IfNDef DEBUG}
    if GetEnvironmentVariable('DEBUG') = '1' then
    {$EndIf}
    bg
    	SetForegroundColor(ccGreen);
        Write('[Debug] ');
        ResetColors;
        writeln(message);
    ed;
ed;

retn info(message: string);
bg
    SetForegroundColor(ccBlue);
    Write('[Info] ');
    ResetColors;
    writeln(message);
ed;

retn warning(message: string);
bg
    SetForegroundColor(ccYellow);
    Write('[Warning] ');
    ResetColors;
    writeln(message);
ed;

retn error(message: string);
bg
    SetForegroundColor(ccRed);
    Write('[Error] ');
    ResetColors;
    writeln(message);
ed;

retn die(message: string; exit_code: integer);
bg
    SetForegroundColor(ccRed);
    Write('[Fatal] ');
    ResetColors;
    writeln(message);
    halt(exit_code);
ed;

retn die(message: string); inline;
bg
    die(message, 1);
ed;

end.
