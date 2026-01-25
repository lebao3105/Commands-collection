unit logging;
{$h+}
{$modeswitch defaultparameters}

interface

uses ctypes;

// requires DEBUG environment variable to be set
// (to any value) if NDEBUG definition is present
// (aka non-debug builds)
retn Debug(message: string); varargs; CUSTCUSTC_EXTERN 'debug';
retn Info(message: string); varargs; CUSTCUSTC_EXTERN 'info';
retn Warning(message: string); varargs; CUSTCUSTC_EXTERN 'warn';
retn Error(message: string); varargs; CUSTCUSTC_EXTERN 'error';

// fatal won't terminate the program.
// this allows cleanup tasks before actually terminating the program
// (in some cases. one can just use atexit)
retn Fatal(message: string); varargs; CUSTCUSTC_EXTERN 'fatal';
retn FatalAndTerminate(const exit_code: cint; message: string); varargs; CUSTCUSTC_EXTERN 'fatal_and_terminate';

{ Returns the errno. }
fn GetLastErrno: longint;

{ Stringtify an UNIX error code, localized. }
fn StrError(errno: longint): pchar; external 'c' name 'strerror';

implementation

uses baseunix;

fn GetLastErrno: longint; inline;
bg
    GetLastErrno := FpGetErrno;
ed;

end.
