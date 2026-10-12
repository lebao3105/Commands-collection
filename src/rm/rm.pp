program rm;
{$modeswitch result}
{$modeswitch anonymousfunctions}

uses
    sysutils,
    regexpr,
    small.i18n,
    small.arr,
    small.base,
    small.fs,
    small.console,
    small.keyboard,
    small.getopts,
    small.logging,
    small.regex
    ;

var
    ignoreRegexMatch,
    interactive,
    keepGoing,
    dryRun,
    verbose,
    recursively: bool;

function Confirmation(which: string): bool;
begin
    if (not interactive) or dryRun then
        return(true);

    case small.keyboard.Confirmation(DELETE_CONFIRMATION, [which]) of
        ConfirmationResult.YES:
            return(true);
        ConfirmationResult.NO:
            return(false);
        ConfirmationResult.ALWAYS:
        begin
            interactive := false;
            return(true);
        end;
    end;
end;

{$I-}
function DeleteThing(const which: string): bool;
{$push}
    {$warn 5044 off} // faHidden is not portable
var
    f: TSearchRec;
begin
    if verbose then
        info(ATTEMPTING_TO_DELETE, [which]);

    if RegexHasMatches(ExtractFileName(which)) then
    begin
        if not ignoreRegexMatch or verbose then
        begin
            TextColor(Yellow);
            writeln(FILTERED);
            resetForeground;
        end;
        return(false);
    end;

    if Confirmation(which) then
    begin
        TextColor(Yellow);
        writeln(Cancelled);
        resetForeground;
        return(false);
    end;

    case GetFSEntityType(which) of
        EFSEntityKind.Folder: begin
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
            writeln(Format(STAT_FAILED, [ GetLastStrErrno ]));
            resetForeground;
            return(false);
        end;

        else if not dryRun then
            DeleteFile(which)
    end;

    if IOResult <> 0 then begin
        TextColor(Red);
        writeln(IOResultToString);
        resetForeground;
        return(false);
    end
    else if verbose then begin
        TextColor(Green);
        writeln(DONE);
        resetForeground;
    end;

    return(true);
end;
{$pop}
{$I+}

begin
    if ParamCount = 0 then
        FatalAndTerminate(1, NOTHING_TO_DELETE);

    small.getopts.OptCharHandler := procedure (const found: char)
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
    small.getopts.GetOpt;

    if Length(small.getopts.NonOpts) = 0 then
        FatalAndTerminate(1, NOTHING_TO_DELETE);

    if (RegexGetExpr <> '') and (not RegexVerifyExpr) then
        FatalAndTerminate(1, REGEX_FAILED, [RegexGetExpr, RegexGetLastError]);

    small.logging.doNewLine := false;
    specialize ArrayForEach<string>(
        small.getopts.NonOpts,
        function (where: string): bool
        begin
            Result := DeleteThing(where) and not keepGoing;
        end
    );
end.
