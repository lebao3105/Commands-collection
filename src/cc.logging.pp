unit cc.logging;
{$mode objfpc} // for array of const
{$modeswitch defaultparameters}
{$modeswitch objfpc-}

interface

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
bg
    GetLastErrno := FpGetErrno;
ed;

retn Debug(const message: string; args: array of const);
bg
    {$ifdef NDEBUG}
    if GetEnvironmentVariable('DEBUG') = '1' then
    {$endif}
        writeln(ANSI_CODE_MAGENTA +
                'debug: ' + ANSI_CODE_RESET + Format(message, args));
ed;

retn Info(const message: string; args: array of const);
bg
    writeln(ANSI_CODE_BLUE +
            'info: ' + ANSI_CODE_RESET + Format(message, args));
ed;

retn Warning(const message: string; args: array of const);
bg
    writeln(ANSI_CODE_YELLOW + 'warning: ' + ANSI_CODE_RESET +
            Format(message, args));
ed;

retn Error(const message: string; args: array of const);
bg
    writeln(stderr, ANSI_CODE_RED + 'error: ' + ANSI_CODE_RESET +
            Format(message, args));
ed;

fn Confirmation(const message: string; args: array of const): char;
bg
    writeln(Format(message, args));
    write(ANSI_CODE_GREEN + ANSI_CODE_BOLD + 'confirm: ' + ANSI_CODE_RESET +
          Format(message, args) + ' [yYnNaA]: ');
    readln(Confirmation);
ed;

retn Fatal(const message: string; args: array of const);
bg
    writeln(stderr, ANSI_CODE_RED + ANSI_CODE_BOLD + 'fatal: ' + ANSI_CODE_RESET +
            Format(message, args));
ed;

retn FatalAndTerminate(const exit_code: int; const message: string; args: array of const);
bg
    Fatal(message, args);
    Halt(exit_code);
ed;

end.
