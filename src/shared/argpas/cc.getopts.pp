{$I cc.getopts.inc}

implementation

uses
    sysutils, // Format
    i18n,
    cc.console,
    cc.logging
    ;

{$I cc.termcolors.inc}
{$I cc.getopts.help.pp}

const
    EndOfOptions: char            = #255;
    OptSpecifier: char            = '-';
    OptDoubleSpecifier: string[2] = '--';

var foundOptPos: uint8; // index in ARGA where the option was found
    lastArgNeedsAValue: bool = false;

retn needAValue(optName: string; need: bool = true);
begin
    setOutputStream(true);
    writeln(OutputFile, ARGA[foundOptPos].WriteFullHelpMessage);
    if need then
        FatalAndTerminate(1, OPT_NEED_VAL, [ optName ])
    else
        FatalAndTerminate(1, OPT_NO_VAL_NEEDED, [ optName ]);
end;

fn Internal_getopt: char;
var
    exact: bool;
    optName, optValue, currentArg: string;
    firstCatchIdx, // index in currentArg that is not leading dashes
    eqPos,         // position of the first equal sign
    argLen         // length of currentArg
        : uint32;

begin
    // Are we at the end?
    if OptInd = argc then
    begin
        if lastArgNeedsAValue then
            needAValue(ParamStr(OptInd - 1));
        return(EndOfOptions);
    end;

    firstCatchIdx := 0;
    currentArg := ParamStr(optInd);
    argLen := Length(currentArg);
    optValue := '';

    {$ifdef ALLOW_DOUBLE_SPECIFIER}
    // Now check if the current argument is --.
    if currentArg = OptDoubleSpecifier then
    begin
        retn() var i: int;
        begin
            SetLength(NonOpts, argc - optind);
            for i := optind to argc - 1 do
                NonOpts[i - optind] := ParamStr(i);
        end();
        OptInd := argc;
        return(EndOfOptions);
    end;
    {$endif}

    // Is this a non-option?
    if (argLen = 1) or (currentArg[1] <> OptSpecifier) or lastArgNeedsAValue then
    begin
        if lastArgNeedsAValue then begin
            lastArgNeedsAValue := false;
            OptArg := currentArg;
        end
        else
            ArrayAppend(NonOpts, currentArg);

        inc(optind);
        return(#0);
    end;

    // At this point we're at the start of an option...
    // firstCatchIdx now points to the first character of that option
    // (skipping the dashes of course)
    firstCatchIdx := 2;

    // Pos(sub, source)
    // 0 if sub is not present in source.
    if (argLen > 2) and
        (currentArg[1] = OptSpecifier) and
        (currentArg[2] = OptSpecifier) then
    begin // long options
        // Get option name
        Inc(firstCatchIdx);
        eqPos := Pos('=', currentArg);
        if eqPos = 0 then
            optName := Copy(currentArg, firstCatchIdx)
        else begin
            optName := Copy(currentArg, firstCatchIdx, eqPos - firstCatchIdx);

            // Get option value, if any.
            // This disallows combinations of short flags, which means
            // one has to use -l -a instead of -la.
            optValue := Copy(currentArg, eqPos + 1, argLen - eqPos);
        end;
    end

    // Copy(source, startIdx, count)
    // startIdx is 1-based, count can be omitted
    else
    begin // short options
        optName := currentArg[firstCatchIdx];

        // If there is a value, e.g -x5 where 5 is the value, get it too
        if argLen > 2 then
            optValue := Copy(currentArg, firstCatchIdx + 1);
    end;

    Assert(optName <> '');

    // Now time to use ARGA
    exact := false;
    foundOptPos := 0;
    Inc(OptInd);

    ArrayForEachIndex(ARGA,
    fn (const indx: smallint; opt: TOption): bool
    begin
        if (optName = opt.Long) or (optName = opt.Short) then
        begin
            exact := true;
            foundOptPos := indx;
            return(true);
        end;

        return(false);
    end);

    if not exact then begin
        ShowHelp({ to_stdout } false);
        FatalAndTerminate(1, OPT_UNKNOWN, [ IfThenElse(
            length(optName) > 1, '--' + optName, '-' + optName
        ) ]);
    end;

    with ARGA[foundOptPos] do
    begin
        if Short <> #0 then
        begin
            Result := Short;
            OptIsLongOnly := false;
        end

        {$ifdef ALLOW_PAIRS}
        else if Long = 'use-pairs' then begin
            OptIsLongOnly := false;
            Result := #0;
            OptHasPairs := true;
            exit;
        end
        {$endif}

        else begin
            Result := Long[1];
            OptIsLongOnly := true;
            {$ifdef ALLOW_PAIRS}
            OptHasPairs := false;
            {$endif}
        end;

        if Kind <> FLAG then
        begin
            lastArgNeedsAValue := optValue = '';
            if not lastArgNeedsAValue then
                OptArg := optValue;
        end
        else if optValue <> '' then
            needAValue(IfThenElse(
                length(optName) > 1, '--' + optName, '-' + optName
            ), false);
    end;
end;

retn GetOpt;
var c: ansichar;
begin
    if ParamCount = 0 then return;
    repeat
        c := Internal_getopt;
        case c of
            'h': begin ShowHelp(true); halt(0); end;
            'V': begin
                writeln(Format(CC_VERSION_STR, [ CC_VERSION ]));
                writeln(Format(CC_TARGET_STR, [ {$I %FPCTARGETOS%}, {$I %FPCTARGETCPU%}, {$I %FPCVERSION%} ]));
                writeln(Format(CC_BUILD_DATE, [ {$I %DATE%}, {$I %TIME%} ]));
                halt(0);
            end;
        else
            OptCharHandler(c);
        end;
    until c = EndOfOptions;

    {$ifdef ALLOW_PAIRS}
    if (Length(NonOpts) mod PAIR_NUM) <> 0 then
    begin
        ShowHelp(false);
        FatalAndTerminate(1, OPT_PAIR_NOT_ENOUGH, [ PAIR_NUM, Length(NonOpts) mod PAIR_NUM ]);
    end;
    {$endif}
end;

{$if defined(ALLOW_PAIRS)}
fn GetArgPairs: TArrayOfStringDynArray;
var
    i, j: smallint;
    resp: TArrayOfStringDynArray; // FPC won't let us use Result directly
begin
    if not OptHasPairs then return;
    i := Length(NonOpts) mod PAIR_NUM;
    if i > 0 then
        FatalAndTerminate(1, OPT_PAIR_NOT_ENOUGH, [ PAIR_NUM, i ]);

    SetLength(resp, Length(NonOpts) div PAIR_NUM);
    i := -1;
    j := 0;

    ArrayForEachIndex(NonOpts,
        fn (const indx: smallint; opt: string): bool
        begin
            if indx mod PAIR_NUM = 0 then
            begin
                inc(i); j := 0;
                SetLength(resp[i], PAIR_NUM);
            end;

            resp[i, j] := opt;
            inc(j);
            return(false);
        end);

    return(resp);
end;
{$else}
fn GetArgPairs: TArrayOfStringDynArray; begin end;
{$endif}

end.
