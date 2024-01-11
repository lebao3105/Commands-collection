unit logging;

interface
uses
    crt, dos;

// print colored text
// default text color probably is LightGray,
// these already have you covered.
procedure writetextcolor(color: byte; message: string);
procedure writetextcolorln(color: byte; message: string);

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
procedure die(message: string; exit_code: integer);
procedure die(message: string); overload;

implementation

procedure writetextcolor(color: byte; message: string);
begin
    TextColor(color);
    write(message);
    TextColor(LightGray);
end;

procedure writetextcolorln(color: byte; message: string);
begin
    writetextcolor(color, message);
    writeln;
end;

procedure debug(message: string);
    procedure printout;
    begin
        writetextcolor(Green, '[Debug] ');
        writeln(message);
    end;

begin
    if GetEnv('DEBUG') = '1' then printout
    else
        {$IFDEF DEBUG}
        printout;
        {$ENDIF}
end;

procedure info(message: string);
begin
    writetextcolor(Magenta, '[Info] ');
    writeln(message);
end;

procedure warning(message: string);
begin
    writetextcolor(Yellow, '[Warning] ');
    writeln(message);
end;

procedure error(message: string);
begin
    writetextcolor(Red, '[Error] ');
    writeln(message);
end;

procedure die(message: string; exit_code: integer);
begin
    writetextcolor(Red, '[Error] ');
    writeln(message);
    delay(800);
    halt(exit_code);
end;

procedure die(message: string);
begin
    die(message, 1);
end;

end.
