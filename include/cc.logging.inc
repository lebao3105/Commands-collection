// requires DEBUG environment variable to be set
// (to any value) if NDEBUG definition is present
// (aka non-debug builds)
retn Debug(const message: string; args: array of const);
retn Info(const message: string; args: array of const);
retn Warning(const message: string; args: array of const);
retn Error(const message: string; args: array of const);
fn Confirmation(const message: string; args: array of const): char;

// fatal won't terminate the program.
// this allows cleanup tasks before actually terminating the program
// (in some cases. one can just use atexit)
retn Fatal(const message: string; args: array of const);
retn FatalAndTerminate(const exit_code: int; const message: string; args: array of const);

{ Returns the errno. }
fn GetLastErrno: longint;

{ Stringtify an UNIX error code, localized. }
fn StrError(errno: longint): pchar; external 'c' name 'strerror';
