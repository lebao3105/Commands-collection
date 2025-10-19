unit fpmake.utils;
{$h+}

interface

uses variants, types;

procedure FPTextIndent(const text: string);
function SplitStr(const text, sep: string): TStringDynArray;
function JoinStr(const sep: string; fr: TStringDynArray): string;
function IfThenElse(val: boolean; const trueVal, falseVal: variant): variant;

// debug
// requires either DEBUG environment = 1 or
// DEBUG compiler definition
procedure debug(message: string);

// info
procedure info(message: string);

// warning
procedure warning(message: string);

// error
procedure error(message: string);

// critical error that eventually kills the program
{$HINT die(...) halts the program. You know what to do.}
procedure die(message: string; exit_code: integer);
procedure die(message: string); overload;

implementation

uses sysutils, strutils;

procedure FPTextIndent(const text: string);
begin
    // why 7? Ask fpmkunit.
    write(StringOfChar(' ', 7));
    writeln(text);
end;

procedure debug(message: string);
begin
    {$IfnDef DEBUG}
    if GetEnvironmentVariable('DEBUG') = '1' then
    {$EndIf}
        writeln('[Debug] ' + message);
end;

procedure info(message: string);
begin
    writeln('[Info] ' + message);
end;

procedure warning(message: string);
begin
    writeln('[Warning] ' + message);
end;

procedure error(message: string);
begin
    writeln('[Error] ' + message);
end;

procedure die(message: string; exit_code: integer);
begin
    writeln('[Fatal] ' + message);
    halt(exit_code);
end;

procedure die(message: string); inline;
begin
    die(message, 1);
end;

function SplitStr(const text, sep: string): TStringDynArray;
begin
    SplitStr := strutils.SplitString(text, sep);
end;

function JoinStr(const sep: string; fr: TStringDynArray): string;
begin
    JoinStr := string.Join(sep, fr);
end;

function IfThenElse(val: boolean; const trueVal, falseVal: variant): variant;
begin
    if val then
        IfThenElse := trueVal
    else
        IfThenElse := falseVal;
end;

end.
