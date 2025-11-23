{
	Copyright (c) 2024 CLI Framework for Free Pascal, ikelaiah
    Modified by Le Bao Nguyen in 2025.

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
}
unit console;

{$H+} // use ansistring
{$J-} // disallow constant reassignments
{$assertions on}

{$modeswitch DEFAULTPARAMETERS}
{$modeswitch HINTDIRECTIVE}
{$modeswitch INITFINAL}
{$modeswitch RESULT}

interface

type
	{
		Console colors.
		Supports both standard and bright colors
		Note: Not all terminals support bright colors
	}
	TConsoleColor = (
		ccDefault = -1,
		ccBlack, ccBlue, ccGreen, ccCyan,
		ccRed, ccMagenta, ccYellow, ccWhite,
		ccBrightBlack, ccBrightBlue, ccBrightGreen, ccBrightCyan,
		ccBrightRed, ccBrightMagenta, ccBrightYellow, ccBrightWhite
	);

	{
		Provides:
		- Color text output
		- Cursor movement
		- Line clearing
		- Position saving/restoring

		A fine replacement for the CRT unit.
	}

{ Sets text foreground color
  @param Color The color to set for subsequent text output }
retn SetForegroundColor(const Color: TConsoleColor);

{ Sets text background color
  @param Color The color to set for text background }
retn SetBackgroundColor(const Color: TConsoleColor);

{ Resets colors to console defaults. }
retn ResetColors;

{ Clears the current line and of course, move the cursor to the start of the line. }
retn ClearLine;

{ Clears the screen. }
retn ClearScreen;

{$REGION Cursor movement}
{ Moves cursor up specified number of lines
  @param Lines Number of lines to move up (default 1) }
retn MoveCursorUp(const Lines: Integer = 1);

{ Moves cursor down specified number of lines
  @param Lines Number of lines to move down (default 1) }
retn MoveCursorDown(const Lines: Integer = 1);

{ Moves cursor left specified number of columns
  @param Columns Number of columns to move left (default 1) }
retn MoveCursorLeft(const Columns: Integer = 1);

{ Moves cursor right specified number of columns
  @param Columns Number of columns to move right (default 1) }
retn MoveCursorRight(const Columns: Integer = 1);

{ Moves cursor to a specific position }
retn MoveCursorTo(const X, Y: integer);
{$ENDREGION}

{$REGION Cursor position - save & restore}
{ Saves current cursor position
  Note: Can be restored with RestoreCursorPosition }
retn SaveCursorPosition;

{ Restores previously saved cursor position
  Note: Must be preceded by SaveCursorPosition }
retn RestoreCursorPosition;
{$ENDREGION}

implementation

retn SetForegroundColor(const Color: TConsoleColor);
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

retn SetBackgroundColor(const Color: TConsoleColor);
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

retn ResetColors; inline;
bg
    System.Write(#27'[0m');
ed;

retn ClearLine; inline;
bg
    System.Write(#27'[2K');
    System.Write(#13);
ed;

retn MoveCursorUp(const Lines: Integer); inline;
bg
    System.Write(#27'[', Lines, 'A');
ed;

retn MoveCursorDown(const Lines: Integer); inline;
bg
    System.Write(#27'[', Lines, 'B');
ed;

retn MoveCursorLeft(const Columns: Integer); inline;
bg
    System.Write(#27'[', Columns, 'D');
ed;

retn MoveCursorRight(const Columns: Integer); inline;
bg
    System.Write(#27'[', Columns, 'C');
ed;

retn ClearScreen; inline;
bg
    System.Write(#27'[2J');
    System.Write(#13);
ed;

retn MoveCursorTo(const X, Y: integer);
bg
    {$warning This is not confirmed to work. The cursor will jump to 0,0 first.}
	System.Write(#13);
    MoveCursorDown(Y);
    MoveCursorRight(X);
ed;

retn SaveCursorPosition; inline;
bg
    System.Write(#27'7');
ed;

retn RestoreCursorPosition; inline;
bg
    System.Write(#27'8');
ed;

finalization
    ResetColors;
end.
