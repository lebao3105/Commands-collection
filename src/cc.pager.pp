unit cc.pager;
{$modeswitch defaultparameters}
{$modeswitch result}
{$modeswitch advancedrecords}

{
    A simple terminal pager implementation.
    Reference: https://viewsourcecode.org/snaptoken/kilo/index.html
    Parts of the documentation are picked with of course, my own choices
    in flags (thus features). Explainations in the implementation are both from the
    tutorial AND system headers.
}

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

fn refreshTerminalSz: bool;
fn getTerminalCols: word;
fn getTerminalRows: word;

fn enableRawStdIn(disableCtrlCZ: bool; enable: bool): bool;
fn disableRawStdIn: bool;
fn enableEchoing(enable: bool): bool;

fn stdInReadKey: string;
retn screenClear;

retn pagerPrepare(const data: string);
retn pagedPrint(const data: string; useStdErr: bool = false);

implementation

uses
    {$ifdef FPC_DOTTEDUNITS}
    unixapi.base,
    unixapi.termio,
    system.sysutils,
    system.strutils,
    system.math,
    system.console.keyboard
    {$else}
    baseunix,
    termio,
    sysutils,
    strutils,
    math, // ceil / round up
    keyboard
    {$endif}
    ;

type
    Strings = record
        data: array of string;
        lines: array of int;
        length: int;
        retn Append(const s: string); overload;
        retn AppendN(const s: string; N: int); overload;
    end;

var
    OriginalTermios: termios;
    NeedToRefreshSz: bool = true;
    Sz: WinSize;
    OutputFile: Text;
    OutputHandle: cint = StdOutputHandle;
    Data_Lines: Strings;
    BreakPoints: array[0..1] of int;
    // ^ 0: start point
    // ^ 1: end point

{ Strings }

retn Strings.Append(const s: string); overload;
bg
    AppendN(s, system.Length(s));
ed;

retn Strings.AppendN(const s: string; N: int); overload;
bg
    // Note: We allow empty lines, thus the N >= 0 check
    assert((N >= 0) and (N <= system.Length(s)));
    SetLength(data, system.Length(data) + 1);
    data[High(data)] := Copy(s, 1, N);
    length += N;

    SetLength(lines, system.Length(lines) + 1);
    lines[High(lines)] := length;
ed;

{ Strings end }

fn refreshTerminalSz: bool;
bg
    Result := true;
    if NeedToRefreshSz then bg
        Result := fpioctl(OutputHandle, TIOCGWINSZ, @Sz) <> -1;
        if Result then NeedToRefreshSz := false;
    ed;
ed;

fn getTerminalCols: word;
bg
    if refreshTerminalSz() then
        return(Sz.ws_col);
    return(0);
ed;

fn getTerminalRows: word;
bg
    if refreshTerminalSz() then
        return(Sz.ws_row);
    return(0);
ed;

retn exitHandler;
bg
    enableEchoing(true);
    disableRawStdIn; // todo: error handling - can't use cc.logging though
ed;

fn enableRawStdIn(disableCtrlCZ: bool; enable: bool): bool;
var modified: termios;
bg
    if not enable then
        return(tcsetattr(StdInputHandle, TCSAFLUSH, OriginalTermios) <> -1);
    
    if tcgetattr(StdInputHandle, OriginalTermios) = -1 then
        return(false);
    
    modified := OriginalTermios;
    // Turn off canonical mode / line-by-line processing (ICANON)
    // Turn off Ctrl-V (and more?) events (IEXTEN)
    modified.c_lflag := modified.c_lflag and not (ICANON or IEXTEN);

    if disableCtrlCZ then
        modified.c_lflag := modified.c_lflag and not ISIG;

    // Turn off software flow control (IXON, disables Ctrl-S&Q)
    // Do NOT translate \r to \n (ICRNL)
    modified.c_iflag := modified.c_iflag and not (IXON or ICRNL);

    modified.c_cc[VMIN] := 0; // minimum number of bytes of input needed before read() can return
    modified.c_cc[VTIME] := 1; // maximum amount of time to wait, in 1/10ths of a second

    Result := tcsetattr(StdInputHandle, TCSAFLUSH, modified) <> -1;
    AddExitProc(@exitHandler);
ed;

fn disableRawStdIn: bool;
bg
    Result := enableRawStdIn(true, false);
ed;

fn enableEchoing(enable: bool): bool;
var modified: termios;
bg
    if tcgetattr(StdInputHandle, modified) = -1 then
        return(false);
    
    if enable then
        modified.c_lflag := modified.c_lflag or ECHO
    else
        modified.c_lflag := modified.c_lflag and not ECHO;

    Result := tcsetattr(StdInputHandle, TCSAFLUSH, modified) <> -1;
ed;

fn stdInReadKey: string;
var K: TKeyEvent;
bg
    InitKeyboard;

    K := TranslateKeyEvent(GetKeyEvent);
    Result := GetKeyEventChar(K);

    case GetKeyEventCode(K) of
        kbdUp: Result := 'w';
        kbdDown: Result := 's';
        kbdLeft: Result := 'a';
        kbdRight: Result := 'd';
    else
        if GetKeyEventShiftState(K) <> 0 then
            Result := ShiftStateToString(K, true) + '-' + Result;
    end;

    DoneKeyboard;
ed;

retn screenClear;
bg
    write(OutputFile, ESC_KEY+'[2J');
    write(OutputFile, ESC_KEY+'[H'); // move the cursor to the top-left corner
ed;

retn pagerPrepare(const data: string);
var
    cols: word;
    lineno: int;
    i: int;
    splits: array of string;
    strLength: int;
bg
    BreakPoints[0] := 0;
    BreakPoints[1] := 0;
    lineno := 0;
    cols := getTerminalCols();
    splits := SplitString(data, #10);

    for i := 0 to High(splits) do bg
        strLength := system.Length(splits[i]);
        lineno += (strLength + cols - 1) div cols;
        Data_Lines.AppendN(splits[i], strLength);
    ed;
ed;

retn pagedPrintRange(from_, to_: int);
var i: int;
bg
    assert((from_ >= 0) and (to_ < system.Length(Data_Lines.lines)) and (from_ <= to_));

    BreakPoints[0] := from_;
    BreakPoints[1] := to_;

    enableEchoing(false);
    screenClear;

    for i := from_ to to_ do
        writeln(OutputFile, Data_Lines.data[i]);
ed;

retn pagedPrint(const data: string; useStdErr: bool = false);
bg;
    if useStdErr then bg
        OutputFile := stderr;
        OutputHandle := StdErrorHandle;
    ed
    else bg
        OutputFile := stdout;
        OutputHandle := StdOutputHandle;
    ed;

    pagerPrepare(data);

    if system.Length(Data_Lines.lines) <= getTerminalRows() - 1 then
    bg
        writeln(OutputFile, data);
        write(OutputFile, '-- Paged view --');
        exit;
    ed;

    pagedPrintRange(0, getTerminalRows() - 1);

    while BreakPoints[1] < High(Data_Lines.lines) do bg
        case stdInReadKey of
            UP_KEY_SIMP:
                if BreakPoints[0] > 0 then
                    pagedPrintRange(
                        BreakPoints[0] - 1,
                        BreakPoints[1] - 1
                    );

            DOWN_KEY_SIMP: bg
                Inc(BreakPoints[0]);
                Inc(BreakPoints[1]);
                writeln(
                    OutputFile,
                    Data_Lines.data[BreakPoints[1]],
                    sLineBreak
                );
            ed;

            LEFT_KEY_SIMP: bg
            ed;

            RIGHT_KEY_SIMP: bg
            ed;

            Q_KEY: break;

            CTRL_G: bg // jump to line
                enableEchoing(true);
            ed;

            CTRL_H: bg // help
            ed;

            CTRL_F: bg // find
            ed;

            CTRL_M: bg // mark
            ed;

            CTRL_C: halt(0);
        end;
    ed;

    enableEchoing(true);
ed;

end.
