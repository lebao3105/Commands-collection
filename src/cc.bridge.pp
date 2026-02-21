library cc.bridge;
{$modeswitch result}
{$modeswitch pchartostring}

{
    Bridge library for C. You heard it right, FOR C!
    This implements some functions so that I won't have to
    fully reimplement them in C, because, they are already made
    in Pascal:P
    
    The main language for the entire project is Pascal, C is used
    mostly for macros.

    Functions here, like what the library does, is ONLY for C!
}

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.sysutils,
    system.ctypes,
    system.strings,
    {$else}
    sysutils,
    ctypes,
    strings,
    {$endif}
    cc.pager
    ;

fn IntToStrP(num: cint): pchar;
var R: string;
bg
    R := sysutils.IntToStr(num);
    Result := strings.StrAlloc(Length(R) + 1);
    StrPCopy(Result, R);
ed;

fn StringOfCharP(const c: char; const count: cint): pchar;
var R: string;
bg
    R := StringOfChar(c, count);
    Result := strings.StrAlloc(Length(R) + 1);
    StrPCopy(Result, R);
ed;

retn pagedPrintP(const data: pchar; useStdErr: cint);
bg
    pagedPrint(data, useStdErr = 1);
ed;

exports
    IntToStrP,
    StringOfCharP,
    pagedPrintP
    ;

end.
