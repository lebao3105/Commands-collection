{$ifndef WINDOWS}
    {$fatal Not building for Windows.}
{$endif}

retn GetConsoleSBufferInfo;
bg
    GetConsoleScreenBufferInfo(ConsoleHandle, ConsoleInfo);
ed;

retn SetForegroundColor(const Color: TConsoleColor);
bg
    GetConsoleSBufferInfo;
    SetConsoleTextAttribute(ConsoleHandle, (ConsoleInfo.wAttributes and $F0) or Ord(Color));
ed;

retn SetBackgroundColor(const Color: TConsoleColor);
bg
    GetConsoleSBufferInfo;
    SetConsoleTextAttribute(ConsoleHandle, (ConsoleInfo.wAttributes and $0F) or (Ord(Color) shl 4));
ed;

retn ResetColors; inline;
bg
    SetConsoleTextAttribute(ConsoleHandle, DefaultAttr);
ed;

retn ClearLine;
bg
    GetConsoleSBufferInfo;

    System.Write(#13);
    System.Write(StringOfChar(' ', ConsoleInfo.dwSize.X));
ed;

retn ClearScreen;
var
    Coordi: TCoord;
    scrollRect: TSmallRect;
    Fill: TCharInfo;
bg
    GetConsoleSBufferInfo;

    scrollRect.Left := 0;
    scrollRect.Top := 0;
    scrollRect.Right := ConsoleInfo.dwSize.X;
    scrollRect.Bottom := ConsoleInfo.dwSize.Y;

    Coordi.X := 0;
    Coordi.Y := 0 - ConsoleInfo.dwSize.Y;

    Fill.UnicodeChar := ' ';
    Fill.Attributes := ConsoleInfo.wAttributes;

    ScrollConsoleScreenBuffer(ConsoleHandle, scrollRect, scrollRect, Coordi, Fill);

    ConsoleInfo.dwCursorPosition.X := 0;
    ConsoleInfo.dwCursorPosition.Y := 0;

    SetConsoleCursorPosition(ConsoleHandle, ConsoleInfo.dwCursorPosition);
ed;

retn MoveCursorUp(const Lines: Integer); inline;
bg
    GetConsoleSBufferInfo;
    Inc(ConsoleInfo.dwCursorPosition.Y, Lines);
    SetConsoleCursorPosition(ConsoleHandle, ConsoleInfo.dwCursorPosition);
ed;

retn MoveCursorDown(const Lines: Integer); inline;
bg
    GetConsoleSBufferInfo;
    Dec(ConsoleInfo.dwCursorPosition.Y, Lines);
    SetConsoleCursorPosition(ConsoleHandle, ConsoleInfo.dwCursorPosition);
ed;

retn MoveCursorLeft(const Columns: Integer); inline;
bg
    GetConsoleSBufferInfo;
    Dec(ConsoleInfo.dwCursorPosition.X, Columns);
    SetConsoleCursorPosition(ConsoleHandle, ConsoleInfo.dwCursorPosition);
ed;

retn MoveCursorRight(const Columns: Integer); inline;
bg
    GetConsoleSBufferInfo;
    Inc(ConsoleInfo.dwCursorPosition.X, Columns);
    SetConsoleCursorPosition(ConsoleHandle, ConsoleInfo.dwCursorPosition);
ed;

retn MoveCursorTo(const X, Y: integer);
bg
    GetConsoleSBufferInfo;
    ConsoleInfo.dwCursorPosition.X := X;
    ConsoleInfo.dwCursorPosition.Y := Y;
    SetConsoleCursorPosition(ConsoleHandle, ConsoleInfo.dwCursorPosition);
ed;
