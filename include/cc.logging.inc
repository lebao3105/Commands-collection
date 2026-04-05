unit cc.logging;

{$mode objfpc} // for array of const
{$modeswitch defaultparameters}
//{$modeswitch objfpc-} // doesn't work

interface

{ For non-debugging builds (ones with out DEBUG definition),
  DEBUG environment variable will be used to decide whether
  this function should print messages or not. }
retn Debug(const message: string; args: array of const);
retn Info(const message: string; args: array of const);
retn Warning(const message: string; args: array of const);
retn Error(const message: string; args: array of const);
fn Confirmation(const message: string; args: array of const): char;

{ Prints a fatal error, with OUT exitting the program.
  To also quit the program, use FatalAndTerminate. }
retn Fatal(const message: string; args: array of const);

{ Same as Fatal, but halts the program with @param exit_code code. }
retn FatalAndTerminate(const exit_code: int; const message: string; args: array of const);

{ Returns the errno. }
fn GetLastErrno: longint;

{ Stringtify an UNIX error code, localized. }
fn StrError(errno: longint): pchar; external 'c' name 'strerror';
