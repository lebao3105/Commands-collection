{$I cc.console.inc}

implementation

uses
    {$ifdef FPC_DOTTEDUNITS}
    unixapi.base,
    unixapi.termio,
    system.sysutils,
    system.console.crt,
    system.console.keyboard
    {$else}
    baseunix,
    termio,
    sysutils,
    crt,
    keyboard
    {$endif}
    ;

var
    NeedToRefreshSz: bool = true;
    Sz: WinSize;

fn isATerminal(Handle: cint): bool;
begin
    return(isATTY(Handle) = 1);
end;

fn refreshTerminalSz: bool;
begin
    Result := true;
    if NeedToRefreshSz and isATerminal(OutputHandle) then
    begin
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

retn screenClear;
begin
    if not isATerminal(OutputHandle) then
        return;

    // The thing is that not all OSes support this, e.g Windows older than 1607.
    // UNIXes normally should cover this themselves. RTL's crt has a function
    // that does a *bit* more than just printing these ASCII keys, but this is
    // enough for us, I think.
    write(OutputFile, ESC_KEY+'[2J');
    write(OutputFile, ESC_KEY+'[H'); // move the cursor to the top-left corner
end;

fn ANSIEscapeSequence(seq: string): string; inline;
begin
    if isATerminal(OutputHandle) then
        return(seq);
    return('');
end;

fn enableRawStdIn(disableCtrlCZ: bool): bool;
var modi: termios;
{$push} {$warn 5036 off} // Local variable seems to be not initialized
begin
    if tcgetattr(StdInputHandle, modi) = -1 then
        return(false);

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
end;
{$pop}

fn disableRawStdIn: bool;
var modi: termios;
{$push} {$warn 5036 off} // Local variable seems to be not initialized
begin
    if tcgetattr(StdInputHandle, modi) = -1 then
        return(false);

    modi.c_lflag := modi.c_lflag or (ICANON or IEXTEN or ISIG);
    modi.c_iflag := modi.c_iflag or (IXON or ICRNL);

    Result := tcsetattr(StdInputHandle, TCSAFLUSH, modi) <> -1;
end;
{$pop}

fn enableStdInEchoing(enable: bool): bool;
var modi: termios;
{$push} {$warn 5036 off} // Local variable seems to be not initialized
begin
    if tcgetattr(StdInputHandle, modi) = -1 then
        return(false);

    if enable then
        modi.c_lflag := modi.c_lflag or ECHO
    else
        modi.c_lflag := modi.c_lflag and not ECHO;

    Result := tcsetattr(StdInputHandle, TCSAFLUSH, modi) <> -1;
end;
{$pop}

fn stdInReadKey: string;
{$push}{$warn 4104 off} // implicit ansi -> unicode type conversion
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
{$pop}

initialization

{ Avoid funny outputs
  Like this
             simple
                    example}
SetTextLineEnding(stderr, #13#10);
SetTextLineEnding(stdout, #13#10);

InitKeyboard;

{ Modify unit CRT's settings }
{ Unused? }
{
    CheckBreak := true;
    CheckEOF   := true;
}

end.
