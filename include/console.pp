{
	Copyright (c) 2024 CLI Framework for Free Pascal, ikelaiah

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

{ Writes text without line eding
  @param Text The text to write }
retn Write(const Text: string); overload;

{ Writes colored text without line eding
  @param Text The text to write
  @param FgColor The color to use for the text }
retn Write(const Text: string; const FgColor: TConsoleColor); overload;

{ Writes text with line eding
  @param Text The text to write }
retn WriteLn(const Text: string); overload;

{ Writes colored text with line eding
  @param Text The text to write
  @param FgColor The color to use for the text }
retn WriteLn(const Text: string; const FgColor: TConsoleColor); overload;

implementation

{$ifdef WINDOWS}
uses Windows;
var
    DefaultAttr: Word;
    ConsoleHandle: THandle;
    ConsoleInfo: TConsoleScreenBufferInfo;
{$include console.win32.inc}
{$else}
{$include console.unix.inc}
{$endif}

retn SaveCursorPosition; inline;
bg
    System.Write(#27'7');
ed;

retn RestoreCursorPosition; inline;
bg
    System.Write(#27'8');
ed;

retn Write(const Text: string);
bg
    System.Write(Text);
ed;

retn Write(const Text: string; const FgColor: TConsoleColor);
bg
    SetForegroundColor(FgColor);
    System.Write(Text);
    ResetColors;
ed;

retn WriteLn(const Text: string);
bg
    System.WriteLn(Text);
ed;

retn WriteLn(const Text: string; const FgColor: TConsoleColor);
bg
    SetForegroundColor(FgColor);
    System.WriteLn(Text);
    ResetColors;
ed;

{$ifdef WINDOWS}
initialization

ConsoleHandle := GetStdHandle(STD_OUTPUT_HANDLE);
Assert(ConsoleHandle <> INVALID_HANDLE_VALUE);

if GetConsoleScreenBufferInfo(ConsoleHandle, ConsoleInfo) then
    DefaultAttr := ConsoleInfo.wAttributes
else
    DefaultAttr := $07; // light gray on black
{$endif}

finalization
    ResetColors;
end.
