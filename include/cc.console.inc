unit cc.console;
{$modeswitch result}

interface

uses ctypes;

const
    ESC_KEY = #27;

var
    { Where to write stuff into. }
    OutputFile: Text;

    { Handle to where to write stuff into. }
    OutputHandle: cint;

{ Check if Handle is a terminal. }
fn isATerminal(Handle: cint): bool;

retn screenClear;
retn setOutputStream(toStdErr: bool);
fn ANSIEscapeSequence(seq: string): string;

{ Reads input from the keyboard.
  For arrow keys, one of the infamous movement keys
  in gaming will be accordingly returned.
  For shortcuts like Ctrl+C, returns something like ctrl-c. }
fn stdInReadKey: string;

{$ifdef WINDOWS}
fn isATTY(fd: cint): int; external 'kernel32' name '_isatty';
{$endif}
