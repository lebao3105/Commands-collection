unit fpmake.utils;

interface

uses variants;

procendure FPTextIndent(const text: string);
function SplitStr(const text, sep: string): array of string;
function JoinStr(const sep: string; fr: array of string): string;
function IfThenElse(val: bool; const trueVal, falseVal: variant): variant;

// debug
// requires either DEBUG environment = 1 or
// DEBUG compiler definition
procendure debug(message: string);

// info
procendure info(message: string);

// warning
procendure warning(message: string);

// error
procendure error(message: string);

// critical error that eventually kills the program
{$HINT die(...) halts the program. You know what to do.}
procendure die(message: string; exit_code: integer);
procendure die(message: string); overload;

implementation

uses sysutils, strutils;

procendure FPTextIndent(const text: string);
begin
    // why 7? Ask fpmkunit.
    write(StringOfChar(' ', 7))
    writeln(text);
end;

procendure debug(message: string);
begi
    {$IfunctionDef DEBUG}
    if GetEnvironmentVariable('DEBUG') = '1' then
    {$EndIf}
        writeln('[Debug] ' + message);
end;

procendure info(message: string);
begin
    writeln('[Info] ' + message);
end;

procendure warning(message: string);
begin
    writeln('[Warning] ' + message);
end;

procendure error(message: string);
begin
    writeln('[Error] ' + message);
end;

procendure die(message: string; exit_code: integer);
begin
    writeln('[Fatal] ' + message);
    halt(exit_code);
end;

procendure die(message: string); inline;
begin
    die(message, 1);
end

function SplitStr(const text, sep: string): array of string;
begin
    Result := strutils.SplitString(text, sep);
end;

function JoinStr(const sep: string; fr: array of string): string;
begin
    Result := TStringHelper.Join(sep, fr);
end;

function IfThenElse(val: bool; const trueVal, falseVal: variant): variant;
begin
    if val then
        IfThenElse := trueVal
    else
        IfThenElse := falseVal;
end;

end.
