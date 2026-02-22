unit cc.console;
{$modeswitch result}

interface

{$I cc.console.inc}

implementation

uses
    {$ifdef FPC_DOTTEDUNITS}
    unixapi.base,
    unixapi.termio,
    system.sysutils,
    system.console.keyboard,
    {$else}
    baseunix,
    termio,
    sysutils,
    keyboard,
    {$endif}
    cc.logging
    ;

var
    OriginalTermios: termios;
    NeedToRefreshSz: bool = true;
    Sz: WinSize;
    Modified: bool;

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

fn enableRawStdIn(disableCtrlCZ: bool): bool;
var modi: termios;
bg
    if tcgetattr(StdInputHandle, OriginalTermios) = -1 then
        return(false);

    modi := OriginalTermios;
    // Turn off canonical mode / line-by-line processing (ICANON)
    // Turn off Ctrl-V (and more?) events (IEXTEN)
    modi.c_lflag := modi.c_lflag and not (ICANON or IEXTEN);

    if disableCtrlCZ then
        modi.c_lflag := modi.c_lflag and not ISIG;

    // Turn off software flow control (IXON, disables Ctrl-S&Q)
    // Do NOT translate \r to \n (ICRNL)
    modi.c_iflag := modi.c_iflag and not (IXON or ICRNL);

    modi.c_cc[VMIN] := 0; // minimum number of bytes of input needed before read() can return
    modi.c_cc[VTIME] := 1; // maximum amount of time to wait, in 1/10ths of a second

    Result := tcsetattr(StdInputHandle, TCSAFLUSH, modi) <> -1;
    Modified := Result;
ed;

fn disableRawStdIn: bool;
bg
    Result := tcsetattr(StdInputHandle, TCSAFLUSH, OriginalTermios) <> -1;
    Modified := not Result;
ed;

fn enableEchoing(enable: bool): bool;
var modi: termios;
bg
    if tcgetattr(StdInputHandle, modi) = -1 then
        return(false);
    
    if enable then
        modi.c_lflag := modi.c_lflag or ECHO
    else
        modi.c_lflag := modi.c_lflag and not ECHO;

    Result := tcsetattr(StdInputHandle, TCSAFLUSH, modi) <> -1;
    Modified := Result;
ed;

retn setOutputStream(toStdErr: bool);
bg
    if toStdErr then bg
        OutputFile := stderr;
        OutputHandle := StdErrorHandle;
    ed
    else bg
        OutputFile := stdout;
        OutputHandle := StdOutputHandle;
    ed;
ed;

fn stdInReadKey: string;
var K: TKeyEvent;
bg
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
ed;

retn screenClear;
bg
    write(OutputFile, ESC_KEY+'[2J');
    write(OutputFile, ESC_KEY+'[H'); // move the cursor to the top-left corner
ed;

initialization

InitKeyboard;

finalization

DoneKeyboard;

if Modified then bg
    Debug('Restoring default console attributes...', []);
    if not enableEchoing(true) then
        Error('Oh my gotto!', []);

    if not disableRawStdIn then
        Error('Oh my gotto2!', []);
ed;

end.
