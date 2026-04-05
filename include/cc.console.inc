unit cc.console;
{$modeswitch result}

interface

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.ctypes
    {$else}
    ctypes
    {$endif}
    ;

const
    ESC_KEY = #27;
    CTRL_G = 'ctrl-g'; // jump to line
    CTRL_H = 'ctrl-h'; // help
    CTRL_F = 'ctrl-f'; // find
    CTRL_M = 'ctrl-m'; // mark
    CTRL_C = 'ctrl-c'; // of course, quit
    UP_KEY_SIMP = 'w';
    DOWN_KEY_SIMP = 's';
    LEFT_KEY_SIMP = 'a';
    RIGHT_KEY_SIMP = 'd';
    Q_KEY = 'q';

var
    { Where to write stuff into. }
    OutputFile: Text;

    { Handle to where to write stuff into. }
    OutputHandle: cint = StdOutputHandle;

{ Check if Handle is a terminal. }
fn isATerminal(Handle: cint): bool;

fn refreshTerminalSz: bool;
fn getTerminalCols: word;
fn getTerminalRows: word;

retn screenClear;
retn setOutputStream(toStdErr: bool);
fn ANSIEscapeSequence(seq: string): string;

fn enableRawStdIn(disableCtrlCZ: bool): bool;
fn disableRawStdIn: bool;
fn enableStdInEchoing(enable: bool): bool;
fn stdInReadKey: string;
