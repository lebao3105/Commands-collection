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
begin
    AppendN(s, system.Length(s));
end;

retn Strings.AppendN(const s: string; N: int); overload;
begin
    // Note: We allow empty lines, thus the N >= 0 check
    assert((N >= 0) and (N <= system.Length(s)));
    SetLength(data, system.Length(data) + 1);
    data[High(data)] := Copy(s, 1, N);
    length += N;

    SetLength(lines, system.Length(lines) + 1);
    lines[High(lines)] := length;
end;

{ Strings end }

retn pagerPrepare(const data: string);
var
    cols: word;
    lineno: int;
    i: int;
    splits: array of string;
    strLength: int;
begin
    BreakPoints[0] := 0;
    BreakPoints[1] := 0;
    lineno := 0;
    cols := getTerminalCols;
    splits := SplitString(data, LineEnding);

    for i := 0 to High(splits) do
    begin
        strLength := system.Length(splits[i]);
        lineno += (strLength + cols - 1) div cols;
        Data_Lines.AppendN(splits[i], strLength);
    end;
end;

retn pagedPrintRange(from_, to_: int);
var i: int;
begin
    assert((from_ >= 0) and (to_ < system.Length(Data_Lines.lines)) and (from_ <= to_));

    BreakPoints[0] := from_;
    BreakPoints[1] := to_;

    // enableEchoing(false);
    screenClear;

    for i := from_ to to_ do
        writeln(OutputFile, Data_Lines.data[i]);
    write(OutputFile, PAGED_VIEW);
end;

retn pagedPrint(const data: string; useStdErr: bool = false);
begin;
    setOutputStream(useStdErr);
    pagerPrepare(data);

    if system.Length(Data_Lines.lines) <= getTerminalRows() - 1 then
    begin
        writeln(OutputFile, data);
        exit;
    end;

    // enableRawStdIn(false);
    pagedPrintRange(0, getTerminalRows() - 1);

    while BreakPoints[1] < High(Data_Lines.lines) do
    begin
        case stdInReadKey of
            UP_KEY_SIMP:
                if BreakPoints[0] > 0 then
                    pagedPrintRange(
                        BreakPoints[0] - 1,
                        BreakPoints[1] - 1
                    );

            DOWN_KEY_SIMP: begin
                Inc(BreakPoints[0]);
                Inc(BreakPoints[1]);
                writeln(
                    OutputFile,
                    Data_Lines.data[BreakPoints[1]],
                    sLineBreak
                );
            end;

            LEFT_KEY_SIMP: begin
            end;

            RIGHT_KEY_SIMP: begin
            end;

            Q_KEY: break;

            CTRL_G: begin // jump to line
                enableEchoing(true);
            end;

            CTRL_H: begin // help
            end;

            CTRL_F: begin // find
            end;

            CTRL_M: begin // mark
            end;

            CTRL_C: halt(0);
        end;
    end;

    enableEchoing(true);
end;

end.
