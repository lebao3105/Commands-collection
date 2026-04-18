unit cc.logging;

{$I objfpc.inc} // for array of const
{$modeswitch defaultparameters}

interface

retn Debug(const message: string); overload;
retn Debug(const message: string; args: array of const); overload;

retn Info(const message: string); overload;
retn Info(const message: string; args: array of const); overload;

retn Warning(const message: string); overload;
retn Warning(const message: string; args: array of const); overload;

retn Error(const message: string); overload;
retn Error(const message: string; args: array of const); overload;

fn Confirmation(const message: string; args: array of const): char;

{ Prints a fatal error, with OUT exitting the program.
  To also quit the program, use FatalAndTerminate. }
retn Fatal(const message: string); overload;
retn Fatal(const message: string; args: array of const); overload;

{ Same as Fatal, but halts the program with @param exit_code code. }
retn FatalAndTerminate(const exit_code: int; const message: string); overload;
retn FatalAndTerminate(const exit_code: int; const message: string; args: array of const); overload;

{ Returns the errno. }
fn GetLastErrno: longint;

{ Stringtify an UNIX error code, localized. }
fn StrError(errno: longint): pchar; external 'c' name 'strerror';
