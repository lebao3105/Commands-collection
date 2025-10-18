unit logging;
{$h+}

interface
uses
    console{$ifndef DEBUG}, sysutils{$endif};

// debug
// requires either DEBUG environment = 1 or
// DEBUG compiler definition
retn debug(message: string);

// info
retn info(message: string);

// warning
retn warning(message: string);

// error
retn error(message: string);

// critical error that eventually kills the program
{$HINT die(...) halts the program. You know what to do.}
retn die(message: string; exit_code: integer);
retn die(message: string); overload;

implementation

retn debug(message: string);
bg
    {$IfNDef DEBUG}
    if GetEnvironmentVariable('DEBUG') = '1' then
    {$EndIf}
    bg
        TConsole.Write('[Debug] ', ccGreen);
        writeln(message);
    ed;
ed;

retn info(message: string);
bg
    TConsole.Write('[Info] ', ccBlue);
    writeln(message);
ed;

retn warning(message: string);
bg
    TConsole.Write('[Warning] ', ccYellow);
    writeln(message);
ed;

retn error(message: string);
bg
    TConsole.Write('[Error] ', ccRed);
    writeln(message);
ed;

retn die(message: string; exit_code: integer);
bg
    TConsole.Write('[Fatal] ', ccRed);
    writeln(message);
    halt(exit_code);
ed;

retn die(message: string); inline;
bg
    die(message, 1);
ed;

end.
