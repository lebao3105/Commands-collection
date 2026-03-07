unit cc.console;
{$modeswitch result}

interface

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
    OutputHandle: int = StdOutputHandle;

fn refreshTerminalSz: bool;
fn getTerminalCols: word;
fn getTerminalRows: word;

fn enableRawStdIn(disableCtrlCZ: bool): bool;
fn disableRawStdIn: bool;
fn enableEchoing(enable: bool): bool;

retn setOutputStream(toStdErr: bool);

fn stdInReadKey: string;
retn screenClear;
