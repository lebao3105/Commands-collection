{$I cc.logging.inc}

implementation

{$I cc.termcolors.inc}

uses
    {$ifdef FPC_DOTTEDUNITS}
    unixapi.base,
    system.sysutils,
    system.console.crt,
    {$else}
    baseunix,
    sysutils, // Format
    crt,
    {$endif}
    cc.console // isATerminal
    ;

resourcestring
    SINFO         = 'info:';
    SDEBUG        = 'debug:';
    SWARNING      = 'warning:';
    SERROR        = 'error:';
    SFATAL        = 'fatal:';
    SCONFIRM      = 'confirm:';

fn GetLastErrno: longint; inline;
begin
    GetLastErrno := FpGetErrno;
end;

retn Logging_Internal(color: int; level, message: string); overload;
begin
    TextColor(color);
    write(level + ' ' + ANSI_CODE_RESET + message);
end;

// Debug

retn Debug(const message: string); overload;
begin
    Logging_Internal(Magenta, SDEBUG, message);
end;

retn Debug(const message: string; args: array of const); overload;
begin
    Debug(Format(message, args));
end;

// Info

retn Info(const message: string); overload;
begin
    Logging_Internal(Blue, SINFO, message);
end;

retn Info(const message: string; args: array of const); overload;
begin
    Info(Format(message, args));
end;

// Warning

retn Warning(const message: string); overload;
begin
    Logging_Internal(Yellow, SWARNING, message);
end;

retn Warning(const message: string; args: array of const); overload;
begin
    Warning(Format(message, args));
end;

// Error

retn Error(const message: string); overload;
begin
    Logging_Internal(Red, SERROR, message);
end;

retn Error(const message: string; args: array of const); overload;
begin
    Error(Format(message, args));
end;

// Confirmation

fn Confirmation(const message: string; args: array of const): char;
begin
    writeln(Format(message, args));
    write(ANSI_CODE_GREEN + ANSI_CODE_BOLD + SCONFIRM + ANSI_CODE_RESET +
          Format(message, args) + ' [yYnNaA]: ');
    readln(Confirmation);
end;

// Fatal

retn Fatal(const message: string); overload;
begin
    Logging_Internal(Red, SFATAL, message);
end;

retn Fatal(const message: string; args: array of const); overload;
begin
    Fatal(Format(message, args));
end;

// FatalAndTerminate

retn FatalAndTerminate(const exit_code: int; const message: string); overload;
begin
    Fatal(message);
    Halt(exit_code);
end;

retn FatalAndTerminate(const exit_code: int; const message: string; args: array of const); overload;
begin
    FatalAndTerminate(exit_code, Format(message, args));
end;

end.
