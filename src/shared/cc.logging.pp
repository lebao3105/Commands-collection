{$I cc.logging.inc}

implementation

{$I cc.termcolors.inc}

uses
    sysutils, // Format
    crt,
    cc.console // isATerminal
    ;

resourcestring
    SINFO         = 'info:';
    {$if defined(DEBUG) or defined(NO_PROG)}
    SDEBUG        = 'debug:';
    {$endif}
    SWARNING      = 'warning:';
    SERROR        = 'error:';
    SFATAL        = 'fatal:';
    SCONFIRM      = 'confirm:';

fn GetLastErrno: longint; inline;
begin
    GetLastErrno := GetLastOSError;
end;

fn GetLastStrErrno: string; inline;
begin
    GetLastStrErrno := SysErrorMessage(GetLastErrno);
end;

retn Logging_Internal(color: int; level, message: string); overload;
begin
    if doPrintHeader then begin
        TextColor(color);
        write(ANSI_CODE_BOLD + level + ' ' + ANSI_CODE_RESET{_FORE});
    end;
    write(message);
    if doNewLine then write(#13#10);
end;

// Debug

retn Debug(const message: string); overload;
begin
{$ifdef DEBUG}
    Logging_Internal(Magenta, SDEBUG, message);
{$endif}
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

fn Confirmation(const message: string; args: array of const): ConfirmationResult;
var c: char;
begin
    writeln(Format(message, args));
    TextColor(Green);
    write(SCONFIRM + ANSI_CODE_RESET_FORE +
          Format(message, args) + ' [yYnNaA]: ');
    readln(c);
    case c of
        'y', 'Y': return(ConfirmationResult.YES);
        'n', 'N': return(ConfirmationResult.NO);
        'a', 'A': return(ConfirmationResult.ALWAYS);
    end;
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
