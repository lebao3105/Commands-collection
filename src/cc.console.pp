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
begin
    Result := true;
    if NeedToRefreshSz then begin
        Result := fpioctl(OutputHandle, TIOCGWINSZ, @Sz) <> -1;
        if Result then NeedToRefreshSz := false;
    end;
end;

fn getTerminalCols: word;
begin
    if refreshTerminalSz() then
        return(Sz.ws_col);
    return(0);
end;

fn getTerminalRows: word;
begin
    if refreshTerminalSz() then
        return(Sz.ws_row);
    return(0);
end;

fn enableRawStdIn(disableCtrlCZ: bool): bool;
var modi: termios;
begin
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
end;

fn disableRawStdIn: bool;
begin
    Result := tcsetattr(StdInputHandle, TCSAFLUSH, OriginalTermios) <> -1;
    Modified := not Result;
end;

fn enableEchoing(enable: bool): bool;
var modi: termios;
begin
    if tcgetattr(StdInputHandle, modi) = -1 then
        return(false);
    
    if enable then
        modi.c_lflag := modi.c_lflag or ECHO
    else
        modi.c_lflag := modi.c_lflag and not ECHO;

    Result := tcsetattr(StdInputHandle, TCSAFLUSH, modi) <> -1;
    Modified := Result;
end;

retn setOutputStream(toStdErr: bool);
begin
    if toStdErr then begin
        OutputFile := stderr;
        OutputHandle := StdErrorHandle;
    end
    else begin
        OutputFile := stdout;
        OutputHandle := StdOutputHandle;
    end;
end;

fn stdInReadKey: string;
var K: TKeyEvent;
begin
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
end;

retn screenClear;
begin
    write(OutputFile, ESC_KEY+'[2J');
    write(OutputFile, ESC_KEY+'[H'); // move the cursor to the top-left corner
end;

initialization

InitKeyboard;

finalization

DoneKeyboard;

if Modified then begin
    Debug('Restoring default console attributes...', []);
    if not enableEchoing(true) then
        Error('Oh my gotto!', []);

    if not disableRawStdIn then
        Error('Oh my gotto2!', []);
end;

end.
