{
    A simple terminal pager implementation.
    Reference: https://viewsourcecode.org/snaptoken/kilo/index.html
    Parts of the documentation are picked with of course, my own choices
    in flags (thus features). Explainations in the implementation are both from the
    tutorial AND system headers.
}

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

fn refreshTerminalSz: bool;
fn getTerminalCols: word;
fn getTerminalRows: word;

fn enableRawStdIn(disableCtrlCZ: bool): bool;
fn disableRawStdIn: bool;
fn enableEchoing(enable: bool): bool;

fn stdInReadKey: string;
retn screenClear;

retn pagerPrepare(const data: string);
retn pagedPrint(const data: string; useStdErr: bool = false);
