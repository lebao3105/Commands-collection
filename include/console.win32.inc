{$ifndef WINDOWS}
    {$fatal Not building for Windows.}
{$endif}

uses Windows;

class function TConsole.GetConsoleHandle: THandle;
bg
    Result := GetStdHandle(STD_OUTPUT_HANDLE);
    Assert(Result <> INVALID_HANDLE_VALUE);
ed;

class procedure TConsole.InitConsole;
var Handle: THandle;
    Info: TConsoleScreenBufferInfo;
bg
    Handle := GetStdHandle(STD_OUTPUT_HANDLE);

    if GetConsoleScreenBufferInfo(Handle, Info) then
        FDefaultAttr := Info.wAttributes
    else
        FDefaultAttr := $07; // light gray on black
ed;

class procedure TConsole.SetForegroundColor(const Color: TConsoleColor);
var Handle: THandle;
    Info: TConsoleScreenBufferInfo;
bg
    Handle := GetStdHandle(STD_OUTPUT_HANDLE);
    GetConsoleScreenBufferInfo(Handle, Info);
    SetConsoleTextAttribute(Handle, (Info.wAttributes and $F0) or Ord(Color));
ed;

class procedure TConsole.SetBackgroundColor(const Color: TConsoleColor);
var
    Handle: THandle;
    Info: TConsoleScreenBufferInfo;
bg
    Handle := GetConsoleHandle;
    GetConsoleScreenBufferInfo(Handle, Info);
    SetConsoleTextAttribute(Handle, (Info.wAttributes and $0F) or (Ord(Color) shl 4));
ed;

class procedure TConsole.ResetColors; inline;
bg
    SetConsoleTextAttribute(GetConsoleHandle, FDefaultAttr);
ed;

class procedure TConsole.ClearLine;
var
    Info: TConsoleScreenBufferInfo;

bg
    GetConsoleScreenBufferInfo(GetConsoleHandle, Info);

    System.Write(#13);
    System.Write(StringOfChar(' ', Info.dwSize.X));
ed;

class procedure TConsole.ClearScreen;
var
    Info: TConsoleScreenBufferInfo;
    Coord: TCoord;
    scrollRect: TSmallRect;
    Handle: THandle;
    Fill: TCharInfo;
bg
    Handle := GetConsoleHandle;
    GetConsoleScreenBufferInfo(Handle, Info);

    scrollRect.Left := 0;
    scrollRect.Top := 0;
    scrollRect.Right := Info.dwSize.X;
    scrollRect.Bottom := Info.dwSize.Y;

    Coord.X := 0;
    Coord.Y := 0 - Info.dwSize.Y;

    Fill.UnicodeChar := ' ';
    Fill.Attributes := Info.wAttributes;

    ScrollConsoleScreenBuffer(Handle, scrollRect, scrollRect, Coord, Fill);

    Info.dwCursorPosition.X := 0;
    Info.dwCursorPosition.Y := 0;

    SetConsoleCursorPosition(Handle, Info.dwCursorPosition);
ed;

class procedure TConsole.MoveCursorUp(const Lines: Integer); inline;
var Handle: THandle;
    Info: TConsoleScreenBufferInfo;
bg
	Handle := GetConsoleHandle;
    GetConsoleScreenBufferInfo(Handle, Info);
    Inc(Info.dwCursorPosition.Y, Lines);
    SetConsoleCursorPosition(Handle, Info.dwCursorPosition);
ed;

class procedure TConsole.MoveCursorDown(const Lines: Integer); inline;
var Handle: THandle;
    Info: TConsoleScreenBufferInfo;
bg
	Handle := GetConsoleHandle;
    GetConsoleScreenBufferInfo(Handle, Info);
    Dec(Info.dwCursorPosition.Y, Lines);
    SetConsoleCursorPosition(Handle, Info.dwCursorPosition);
ed;

class procedure TConsole.MoveCursorLeft(const Columns: Integer); inline;
var Handle: THandle;
    Info: TConsoleScreenBufferInfo;
bg
	Handle := GetConsoleHandle;
    GetConsoleScreenBufferInfo(Handle, Info);
    Dec(Info.dwCursorPosition.X, Columns);
    SetConsoleCursorPosition(Handle, Info.dwCursorPosition);
ed;

class procedure TConsole.MoveCursorRight(const Columns: Integer); inline;
var Handle: THandle;
    Info: TConsoleScreenBufferInfo;
bg
	Handle := GetConsoleHandle;
    GetConsoleScreenBufferInfo(Handle, Info);
    Inc(Info.dwCursorPosition.X, Columns);
    SetConsoleCursorPosition(Handle, Info.dwCursorPosition);
ed;

class procedure TConsole.MoveCursorTo(const X, Y: integer);
var Handle: THandle;
    Info: TConsoleScreenBufferInfo;
bg
	Handle := GetConsoleHandle;
    GetConsoleScreenBufferInfo(Handle, Info);
    Info.dwCursorPosition.X := X;
    Info.dwCursorPosition.Y := Y;
    SetConsoleCursorPosition(Handle, Info.dwCursorPosition);
ed;