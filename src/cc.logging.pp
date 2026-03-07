{$I cc.logging.inc}

implementation

{$I cc.termcolors.inc}

uses
    {$ifdef FPC_DOTTEDUNITS}
    unixapi.base,
    system.sysutils
    {$else}
    baseunix,
    sysutils
    {$endif}
    ;

fn GetLastErrno: longint; inline;
begin
    GetLastErrno := FpGetErrno;
end;

retn Debug(const message: string; args: array of const);
begin
    {$ifdef NDEBUG}
    if GetEnvironmentVariable('DEBUG') = '1' then
    {$endif}
        writeln(ANSI_CODE_MAGENTA +
                'debug: ' + ANSI_CODE_RESET + Format(message, args));
end;

retn Info(const message: string; args: array of const);
begin
    writeln(ANSI_CODE_BLUE +
            'info: ' + ANSI_CODE_RESET + Format(message, args));
end;

retn Warning(const message: string; args: array of const);
begin
    writeln(ANSI_CODE_YELLOW + 'warning: ' + ANSI_CODE_RESET +
            Format(message, args));
end;

retn Error(const message: string; args: array of const);
begin
    writeln(stderr, ANSI_CODE_RED + 'error: ' + ANSI_CODE_RESET +
            Format(message, args));
end;

fn Confirmation(const message: string; args: array of const): char;
begin
    writeln(Format(message, args));
    write(ANSI_CODE_GREEN + ANSI_CODE_BOLD + 'confirm: ' + ANSI_CODE_RESET +
          Format(message, args) + ' [yYnNaA]: ');
    readln(Confirmation);
end;

retn Fatal(const message: string; args: array of const);
begin
    writeln(stderr, ANSI_CODE_RED + ANSI_CODE_BOLD + 'fatal: ' + ANSI_CODE_RESET +
            Format(message, args));
end;

retn FatalAndTerminate(const exit_code: int; const message: string; args: array of const);
begin
    Fatal(message, args);
    Halt(exit_code);
end;

end.
