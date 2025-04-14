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

{$mode objfpc}
{$H+} // use ansistring
{$J-} // disallow constant reassignments
{$assertions on}

interface

type
	{
		Console colors.
		Supports both standard and bright colors
		Note: Not all terminals support bright colors
	}
	TConsoleColor = (
		ccBlack, ccBlue, ccGreen, ccCyan, 
		ccRed, ccMagenta, ccYellow, ccWhite,
		ccBrightBlack, ccBrightBlue, ccBrightGreen, ccBrightCyan,
		ccBrightRed, ccBrightMagenta, ccBrightYellow, ccBrightWhite
	);

	{
		TConsole - Static class for console operations
		Provides:
		- Color text output
		- Cursor movement
		- Line clearing
		- Position saving/restoring
		
		This is platform specific: on Windows, console attributes are used,
		while on UNIX just use escape sequences and you're done.

		A fine replacement for the CRT unit.
	}
	TConsole = class
	private
		{ Initial console attributes }
		class var FDefaultAttr: Word;

		{ Initializes console settings
		  Called automatically in initialization section
		  Stores initial attributes on Windows, does nothing on Unix }
		class procedure InitConsole;

        {$ifdef WINDOWS}
        class function GetConsoleHandle: THandle;
        {$endif}

	public
		{ Sets text foreground color
		  @param Color The color to set for subsequent text output }
		class procedure SetForegroundColor(const Color: TConsoleColor);

		{ Sets text background color
		  @param Color The color to set for text background }
		class procedure SetBackgroundColor(const Color: TConsoleColor);

		{ Resets colors to console defaults. }
		class procedure ResetColors;

		{ Clears the current line and of course, move the cursor to the start of the line. }
		class procedure ClearLine;

        { Clears the screen. }
        class procedure ClearScreen;

        {$REGION Cursor movement}
		{ Moves cursor up specified number of lines
		  @param Lines Number of lines to move up (default 1) }
		class procedure MoveCursorUp(const Lines: Integer = 1);

		{ Moves cursor down specified number of lines
		  @param Lines Number of lines to move down (default 1) }
		class procedure MoveCursorDown(const Lines: Integer = 1);

		{ Moves cursor left specified number of columns
		  @param Columns Number of columns to move left (default 1) }
		class procedure MoveCursorLeft(const Columns: Integer = 1);

		{ Moves cursor right specified number of columns
		  @param Columns Number of columns to move right (default 1) }
		class procedure MoveCursorRight(const Columns: Integer = 1);

		{ Moves cursor to a specific position }
		class procedure MoveCursorTo(const X, Y: integer);
        {$ENDREGION}

        {$REGION Cursor position - save & restore}
		{ Saves current cursor position
		  Note: Can be restored with RestoreCursorPosition }
		class procedure SaveCursorPosition;

		{ Restores previously saved cursor position
		  Note: Must be preceded by SaveCursorPosition }
		class procedure RestoreCursorPosition;
        {$ENDREGION}

		{ Writes text without line ending
		  @param Text The text to write }
		class procedure Write(const Text: string); overload;

		{ Writes colored text without line ending
		  @param Text The text to write
		  @param FgColor The color to use for the text }
		class procedure Write(const Text: string; const FgColor: TConsoleColor); overload;

		{ Writes text with line ending
		  @param Text The text to write }
		class procedure WriteLn(const Text: string); overload;

		{ Writes colored text with line ending
		  @param Text The text to write
		  @param FgColor The color to use for the text }
		class procedure WriteLn(const Text: string; const FgColor: TConsoleColor); overload;
	end;

implementation

{$ifdef WINDOWS}
    {$include console.win32.inc}
{$else}
    {$include console.unix.inc}
{$endif}

class procedure TConsole.SaveCursorPosition;
begin
    System.Write(#27'7');
end;

class procedure TConsole.RestoreCursorPosition;
begin
    System.Write(#27'8');
end;

class procedure TConsole.Write(const Text: string); inline;
begin
    System.Write(Text);
end;

class procedure TConsole.Write(const Text: string; const FgColor: TConsoleColor);
begin
    SetForegroundColor(FgColor);
    System.Write(Text);
    ResetColors;
end;

class procedure TConsole.WriteLn(const Text: string); inline;
begin
    System.WriteLn(Text);
end;

class procedure TConsole.WriteLn(const Text: string; const FgColor: TConsoleColor);
begin
    SetForegroundColor(FgColor);
    System.WriteLn(Text);
    ResetColors;
end;

{$ifdef WINDOWS}
initialization
    TConsole.InitConsole;
{$endif}
end.