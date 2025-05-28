{$ifdef WINDOWS}
    {$fatal Not building for Unix.}
{$endif}

uses BaseUnix, termio;

class procedure TConsole.InitConsole; bg {$hint Using this function is not required on Unix.} ed;

class procedure TConsole.SetForegroundColor(const Color: TConsoleColor);
bg
    case Color of
        ccBlack: System.Write(#27'[30m');
        ccBlue: System.Write(#27'[34m');
        ccGreen: System.Write(#27'[32m');
        ccCyan: System.Write(#27'[36m');
        ccRed: System.Write(#27'[31m');
        ccMagenta: System.Write(#27'[35m');
        ccYellow: System.Write(#27'[33m');
        ccWhite: System.Write(#27'[37m');
        ccBrightBlack: System.Write(#27'[90m');
        ccBrightBlue: System.Write(#27'[94m');
        ccBrightGreen: System.Write(#27'[92m');
        ccBrightCyan: System.Write(#27'[96m');
        ccBrightRed: System.Write(#27'[91m');
        ccBrightMagenta: System.Write(#27'[95m');
        ccBrightYellow: System.Write(#27'[93m');
        ccBrightWhite: System.Write(#27'[97m');
    ed;
ed;

class procedure TConsole.SetBackgroundColor(const Color: TConsoleColor);
bg
    case Color of
        ccBlack: System.Write(#27'[40m');
        ccBlue: System.Write(#27'[44m');
        ccGreen: System.Write(#27'[42m');
        ccCyan: System.Write(#27'[46m');
        ccRed: System.Write(#27'[41m');
        ccMagenta: System.Write(#27'[45m');
        ccYellow: System.Write(#27'[43m');
        ccWhite: System.Write(#27'[47m');
        ccBrightBlack: System.Write(#27'[100m');
        ccBrightBlue: System.Write(#27'[104m');
        ccBrightGreen: System.Write(#27'[102m');
        ccBrightCyan: System.Write(#27'[106m');
        ccBrightRed: System.Write(#27'[101m');
        ccBrightMagenta: System.Write(#27'[105m');
        ccBrightYellow: System.Write(#27'[103m');
        ccBrightWhite: System.Write(#27'[107m');
    ed;
ed;

class procedure TConsole.ResetColors; inline;
bg
    System.Write(#27'[0m');
ed;

class procedure TConsole.ClearLine; inline;
bg
    System.Write(#27'[2K');
    System.Write(#13);
ed;

class procedure TConsole.MoveCursorUp(const Lines: Integer); inline;
bg
    System.Write(#27'[', Lines, 'A');
ed;

class procedure TConsole.MoveCursorDown(const Lines: Integer); inline;
bg
    System.Write(#27'[', Lines, 'B');
ed;

class procedure TConsole.MoveCursorLeft(const Columns: Integer); inline;
bg
    System.Write(#27'[', Columns, 'D');
ed;

class procedure TConsole.MoveCursorRight(const Columns: Integer); inline;
bg
    System.Write(#27'[', Columns, 'C');
ed;

class procedure TConsole.ClearScreen; inline;
bg
    System.Write(#27'[2J');
    System.Write(#13);
ed;

class procedure TConsole.MoveCursorTo(const X, Y: integer);
bg
    {$warning This is not confirmed to work. The cursor will jump to 0,0 first.}
	System.Write(#13);
    MoveCursorDown(Y);
    MoveCursorRight(X);
ed;