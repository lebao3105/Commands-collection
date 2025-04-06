unit logging;
{$mode objfpc}

interface
uses
    console, sysutils, dos;

// debug
// requires either DEBUG environment = 1 or
// DEBUG compiler definition
procedure debug(message: string);

// info
procedure info(message: string);

// warning
procedure warning(message: string);

// error
procedure error(message: string);

// critical error that eventually kills the program
{$HINT die(...) halts the program. You know what to do.}
procedure die(message: string; exit_code: integer);
procedure die(message: string); overload;

implementation

procedure debug(message: string);
    procedure printout;
    begin
        TConsole.Write('[Debug] ', ccGreen);
        writeln(message);
    end;

begin
    if GetEnv('DEBUG') = '1' then printout
    {$IFDEF DEBUG}
    else
        printout;
    {$ENDIF}
end;

procedure info(message: string);
begin
    TConsole.Write('[Info] ', ccBlue);
    writeln(message);
end;

procedure warning(message: string);
begin
    TConsole.Write('[Warning] ', ccYellow);
    writeln(message);
end;

procedure error(message: string);
begin
    TConsole.Write('[Error] ', ccRed);
    writeln(message);
end;

procedure die(message: string; exit_code: integer);
begin
    error(message);
    sleep(800);
    halt(exit_code);
end;

procedure die(message: string); inline;
begin
    die(message, 1);
end;

end.