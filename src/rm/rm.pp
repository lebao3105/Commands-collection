program rm;
{$modeswitch result}
{$modeswitch anonymousfunctions}

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.sysutils,
    system.regexpr,
    {$else}
    sysutils,
    regexpr,
    {$endif}
    cc.base,
    cc.getopts,
    cc.logging,
    cc.regex
    ;

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

fn RegexFileNameCheck(const name: string): bool;
var
    regcheck: bool;
begin
    regcheck := RegexHasMatches(name);

    // No matches
    if not regcheck then
    begin
        if RegexGetLastErrorID <> 0 then
        begin
            error(REGEX_FAILED, [RegexGetExpr, RegexGetLastError]);
            if not keepGoing then
                halt(1);
            return;
        end;

        Result := ignoreRegexMatch;
        if not Result and verbose then
            info(FILTERED, [name]);
        
        return;
    end;

    // There are matches
    Result := not ignoreRegexMatch;
    if Result and verbose then
        info(FILTERED, [name]);
end;

fn DeleteThing(const which: string): bool;
var
    f: TSearchRec;

begin
    if verbose then
        info(ATTEMPTING_TO_DELETE, [which]);
    
    if not RegexFileNameCheck(ExtractFileName(which)) then
        return(not keepGoing);

    if Confirmation(which) then
    begin
        if DirectoryExists(which) then
        begin
            if recursively and (FindFirst(which + '/*',
                    faAnyFile or faDirectory or faHidden, f) = 0) then
                repeat
                    DeleteThing(which + '/' + f.Name);
                until FindNext(f) <> 0;

            if not dryRun then
                RemoveDir(which);
        end

        else if FileExists(which) and not dryRun then
            if not dryRun then
                DeleteFile(which)

        else begin
            error(NON_EXISTANT, [which]);
            return(not keepGoing);
        end;

        info(DELETED, [which]);
    end;
end;

var regcheck: specialize TOptional<ERegExpr>;
begin
    if ParamCount = 0 then
        fatal(NOTHING_TO_DELETE, []);

    cc.getopts.OptCharHandler := retn (const found: char)
    begin
        case found of
            'g': ignoreRegexMatch := true;
            'd': dryRun := true;
            'i': interactive := true;
            'v': verbose := true;
            'x': RegexAppendExpr(OptArg);
            'r': recursively := true;
            'k': keepGoing := true;
        end;
    end;
    cc.getopts.GetOpt;

    if High(cc.getopts.NonOpts) = 0 then
        fatal(NOTHING_TO_DELETE, []);

    if RegexGetExpr <> '' then begin
        regcheck := RegexVerifyExpr;
        if regcheck.HasValue then
            fatal(REGEX_FAILED, [RegexGetExpr, regcheck.Value.Message]);
    end;

    specialize ArrayForEach<string>(
        cc.getopts.NonOpts,
        @DeleteThing
    );
end.