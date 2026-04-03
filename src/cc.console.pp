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
    originalOuts: array[0..1] of termios;
    // 0st index: stdout
    // 1st index: stderr
    originalStdIn: termios;
    NeedToRefreshSz: bool = true;
    Sz: WinSize;
    modifiedStdIn: bool;

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

retn modifyOutputHandle_Internal(for_stderr: bool);
var
    indx: int;
    h: cint;
    modi: termios;
{$push} {$warn 5057 off} // Local variable seems to be not initialized
begin
    if for_stderr then begin
        indx := 1;
        h := StdErrorHandle;
    end
    else begin
        indx := 0;
        h := StdOutputHandle;
    end;

    if not isATerminal(h) then
        return;

    if tcgetattr(h, originalOuts[indx]) = -1 then
        return; // TODO: Do something

    modi := originalOuts[indx];
    modi.c_oflag := modi.c_oflag or ONLCR; // (XSI) Map NL to CRNL
    modi.c_oflag := modi.c_oflag or ONOCR; // Don't output CR at column 0
    modi.c_oflag := modi.c_oflag and not OCRNL; // Don't map CR to NL

    if tcsetattr(h, TCSANOW, modi) = -1 then
        return; // TODO: Do something
end;
{$pop}

retn restoreStdOut_Internal(for_stderr: bool);
var
    indx: int;
    h: cint;
begin
    if for_stderr then begin
        indx := 1;
        h := StdErrorHandle;
    end
    else begin
        indx := 0;
        h := StdOutputHandle;
    end;

    if not isATerminal(h) then
        return;
    
    if tcsetattr(h, TCSANOW, originalOuts[indx]) = -1 then
        return; // TODO: Do something
end;

retn screenClear;
begin
    if not isATerminal(OutputHandle) then
        return;

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
    modifiedStdIn := Result;
end;

fn disableRawStdIn: bool;
var modi: termios;
begin
    if tcgetattr(StdInputHandle, modi) = -1 then
        return(false);
    
    modi.c_lflag := modi.c_lflag or (ICANON or IEXTEN or ISIG);
    modi.c_iflag := modi.c_iflag or (IXON or ICRNL);
    modi.c_cc[VMIN] := originalStdin.c_cc[VMIN]; // FIXME: What if originalStdIn is empty?
    modi.c_cc[VTIME] := originalStdin.c_cc[VTIME];

    Result := tcsetattr(StdInputHandle, TCSANOW, originalStdIn) <> -1;
    modifiedStdIn := not Result;
end;

fn enableStdInEchoing(enable: bool): bool;
var modi: termios;
begin
    if tcgetattr(StdInputHandle, modi) = -1 then
        return(false);
    
    if enable then
        modi.c_lflag := modi.c_lflag or ECHO
    else
        modi.c_lflag := modi.c_lflag and not ECHO;

    Result := tcsetattr(StdInputHandle, TCSANOW, modi) <> -1;
    modifiedStdIn := Result;
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

initialization

Debug('Initializing console module...', []);

modifyOutputHandle_Internal({ for stderr }true);
modifyOutputHandle_Internal(false);

// This one modifies console attributes. Took a good amount of time
// just to figure it out (I just stumbled upon putting this on
// a reproduction).
// As a result, this call lies here. Also it's to make sure that calls of
// stdin modification functions use modified attributes.
// Wait. We must back it up first!
if tcgetattr(StdInputHandle, originalStdIn) = -1 then
    Error('Unable to backup standard input attributes. Expect weird behavior.', []);
InitKeyboard;

SetTextLineEnding(stderr, #13#10);
SetTextLineEnding(stdout, #13#10);

finalization

Debug('Restoring default console attributes...', []);

DoneKeyboard;

if modifiedStdIn and (tcsetattr(StdInputHandle, TCSANOW, originalStdIn) = -1) then
    Error('Failed to restore standard input attributes.', []);

restoreStdOut_Internal({ for stderr }true);
restoreStdOut_Internal(false);

end.
