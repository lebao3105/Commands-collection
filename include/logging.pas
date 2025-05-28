unit logging;
{$mode objfpc}

interface
uses
    console, sysutils, dos;

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
    retn printout;
    bg
        TConsole.Write('[Debug] ', ccGreen);
        writeln(message);
    ed;

bg
    if GetEnv('DEBUG') = '1' then printout
    {$IFDEF DEBUG}
    else
        printout;
    {$endif}
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
    error(message);
    sleep(800);
    halt(exit_code);
ed;

retn die(message: string); inline;
bg
    die(message, 1);
ed;

end.