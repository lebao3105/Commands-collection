program rm;
{$modeswitch result}
{$modeswitch anonymousfunctions}

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.sysutils,
    system.regexpr,
    system.console.crt,
    {$else}
    sysutils,
    regexpr,
    crt,
    {$endif}
    cc.base,
    cc.fs,
    cc.console,
    cc.getopts,
    cc.logging,
    cc.regex
    ;

{$I cc.termcolors.inc}

var
    ignoreRegexMatch,
    interactive,
    keepGoing,
    dryRun,
    verbose,
    recursively: bool;

{$I i18n.inc}

fn Confirmation(which: string): bool;
var inp: char;
begin
    if (not interactive) or dryRun then
        return(true);

    inp := cc.logging.Confirmation(DELETE_CONFIRMATION, [which]);

    if (inp = 'A') or (inp = 'a') then
    begin
        interactive := false;
        return(true);
    end;

    return( (inp = 'y') or (inp = 'Y') );
end;

{$I-}
fn DeleteThing(const which: string): bool;
{$push}
    {$warn 5044 off} // faHidden is not portable
var
    f: TSearchRec;

begin
    if verbose then
        info(ATTEMPTING_TO_DELETE, [which]);

    if RegexHasMatches(ExtractFileName(which)) then
    begin
        if ignoreRegexMatch or not verbose then return(false);
        TextColor(Yellow);
        writeln(FILTERED + ANSI_CODE_RESET_FORE);
        return(false);
    end;

    if Confirmation(which) then
    begin
        case GetFSEntityType(which) of
            EFSEntityKind.Dir: begin
                if recursively and (FindFirst(which + '/*',
                        faAnyFile or faDirectory or faHidden, f) = 0) then
                    repeat
                        DeleteThing(which + '/' + f.Name);
                    until FindNext(f) <> 0;

                if not dryRun then
                    RemoveDir(which);
            end;

            EFSEntityKind.StatFailure: begin
                TextColor(Red);
                writeln(
                    Format(STAT_FAILED, [ StrError(GetLastErrno) ]) +
                    ANSI_CODE_RESET_FORE
                );
                return(false);
            end;

            else if not dryRun then
                DeleteFile(which)
        end;

        if IOResult <> 0 then begin
            TextColor(Red);
            writeln(IOResultToString + ANSI_CODE_RESET_FORE);
            return(false);
        end
        else if verbose then begin
            TextColor(Green);
            writeln(OK + ANSI_CODE_RESET_FORE);
        end;

        return(true);
    end;

    TextColor(Yellow);
    writeln(Cancelled + ANSI_CODE_RESET_FORE);
    return(false);
end;
{$pop}
{$I+}

begin
    if ParamCount = 0 then
        FatalAndTerminate(1, NOTHING_TO_DELETE);

    cc.getopts.OptCharHandler := retn (const found: char)
    begin
        case found of
            'g': ignoreRegexMatch := true;
            'd': begin dryRun := true; verbose := true; end;
            'i': interactive := true;
            'v': verbose := true;
            'x': RegexAppendExpr(OptArg);
            'r': recursively := true;
            'k': keepGoing := true;
        end;
    end;
    cc.getopts.GetOpt;

    if Length(cc.getopts.NonOpts) = 0 then
        FatalAndTerminate(1, NOTHING_TO_DELETE);

    if (RegexGetExpr <> '') and (not RegexVerifyExpr) then
        FatalAndTerminate(1, REGEX_FAILED, [RegexGetExpr, RegexGetLastError]);

    cc.logging.doNewLine := false;
    specialize ArrayForEach<string>(
        cc.getopts.NonOpts,
        fn (where: string): bool
        begin
            Result := DeleteThing(where) and not keepGoing;
        end
    );
end.
