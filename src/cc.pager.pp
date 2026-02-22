unit cc.pager;
{$modeswitch defaultparameters}
{$modeswitch result}
{$modeswitch advancedrecords}

interface

{$I cc.pager.inc}

implementation

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.sysutils,
    system.strutils,
    system.console.keyboard,
    {$else}
    sysutils,
    strutils,
    keyboard,
    {$endif}
    cc.console
    ;

type
    Strings = record
        data: array of string;
        lines: array of int;
        length: int;
        retn Append(const s: string); overload;
        retn AppendN(const s: string; N: int); overload;
    end;

var
    Data_Lines: Strings;
    BreakPoints: array[0..1] of int;
    // ^ 0: start point
    // ^ 1: end point

{ Strings }

retn Strings.Append(const s: string); overload;
bg
    AppendN(s, system.Length(s));
ed;

retn Strings.AppendN(const s: string; N: int); overload;
bg
    // Note: We allow empty lines, thus the N >= 0 check
    assert((N >= 0) and (N <= system.Length(s)));
    SetLength(data, system.Length(data) + 1);
    data[High(data)] := Copy(s, 1, N);
    length += N;

    SetLength(lines, system.Length(lines) + 1);
    lines[High(lines)] := length;
ed;

{ Strings end }

retn pagerPrepare(const data: string);
var
    cols: word;
    lineno: int;
    i: int;
    splits: array of string;
    strLength: int;
bg
    BreakPoints[0] := 0;
    BreakPoints[1] := 0;
    lineno := 0;
    cols := getTerminalCols;
    splits := SplitString(data, LineEnding);

    for i := 0 to High(splits) do
    bg
        strLength := system.Length(splits[i]);
        lineno += (strLength + cols - 1) div cols;
        Data_Lines.AppendN(splits[i], strLength);
    ed;
ed;

retn pagedPrintRange(from_, to_: int);
var i: int;
bg
    assert((from_ >= 0) and (to_ < system.Length(Data_Lines.lines)) and (from_ <= to_));

    BreakPoints[0] := from_;
    BreakPoints[1] := to_;

    enableEchoing(false);
    screenClear;

    for i := from_ to to_ do
        writeln(OutputFile, Data_Lines.data[i]);
    write(OutputFile, PAGED_VIEW);
ed;

retn pagedPrint(const data: string; useStdErr: bool = false);
bg;
    setOutputStream(useStdErr);
    pagerPrepare(data);

    if system.Length(Data_Lines.lines) <= getTerminalRows() - 1 then
    bg
        writeln(OutputFile, data);
        exit;
    ed;

    enableRawStdIn(false);
    pagedPrintRange(0, getTerminalRows() - 1);

    while BreakPoints[1] < High(Data_Lines.lines) do
    bg
        case stdInReadKey of
            UP_KEY_SIMP:
                if BreakPoints[0] > 0 then
                    pagedPrintRange(
                        BreakPoints[0] - 1,
                        BreakPoints[1] - 1
                    );

            DOWN_KEY_SIMP: bg
                Inc(BreakPoints[0]);
                Inc(BreakPoints[1]);
                writeln(
                    OutputFile,
                    Data_Lines.data[BreakPoints[1]],
                    sLineBreak
                );
            ed;

            LEFT_KEY_SIMP: bg
            ed;

            RIGHT_KEY_SIMP: bg
            ed;

            Q_KEY: break;

            CTRL_G: bg // jump to line
                enableEchoing(true);
            ed;

            CTRL_H: bg // help
            ed;

            CTRL_F: bg // find
            ed;

            CTRL_M: bg // mark
            ed;

            CTRL_C: halt(0);
        end;
    ed;

    enableEchoing(true);
ed;

end.
