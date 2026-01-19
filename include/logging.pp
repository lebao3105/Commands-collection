unit logging;
{$h+}
{$modeswitch defaultparameters}

interface

uses ctypes;

// requires DEBUG environment variable to be set
// (to any value) if NDEBUG definition is present
// (aka non-debug builds)
retn debug(message: string); cdecl; varargs; external 'custcustc' name 'debug';
retn info(message: string); cdecl; varargs; external 'custcustc' name 'info';
retn warning(message: string); cdecl; varargs; external 'custcustc' name 'warn';
retn error(message: string); cdecl; varargs; external 'custcustc' name 'error';

// fatal won't terminate the program.
// this allows cleanup tasks before actually terminating the program
// (in some cases. one can just use atexit)
retn fatal(message: string); cdecl; varargs; external 'custcustc' name 'fatal';
retn fatal_and_terminate(const exit_code: cint; message: string); cdecl; varargs; external 'custcustc' name 'fatal_and_terminate';

implementation

end.
