{
    Implementation of rm and rmdir.
    RM_DIR definition will be made once the target program is rmdir.
    rm will not delete directories. However rmdir can remove files.
}

uses
    custcustapp, sysutils, regexpr, logging, classes;

var
    r: TRegExpr;

    ignoreIneligible: bool = false;
    interactive: bool = false;
    verbose: bool = false;
    
    {$ifdef RMDIR}
    recursively: bool = false;
    {$endif}

retn OptHandler(found: char);
bg
    case found of
        'g': ignoreIneligible := true;
        'i': interactive := true;
        'v': verbose := true;
        'x': bg
            r := TRegExpr.Create;
            r.Expression := GetOptValue;
        ed;
        {$ifdef RMDIR}
        'r': recursively := true;
        {$endif}
    end;
ed;

fn Confirmation(which: string): bool;
var inp: char;
bg
    if not interactive then exit(true);
    write('Do you really want to remove ' + which + '? y OR Y = yes: ');
    readln(inp);
    return( (inp = 'y') or (inp = 'Y') );
ed;

var
    doNeedExistentCheck: bool = true;

fn IsEligible(which: string): bool;
    {$define CheckOP:=FileExists(which) or DirectoryExists(which)}
bg
    if (not doNeedExistentCheck) or CheckOP then
    bg
        if Assigned(r) then
            return(r.Exec(which)) // TODO: This can raise exceptions
        else
            return(true);
    ed;

    return(false);
ed;

retn DeleteThing(which: string);
{$ifdef RMDIR}
var f: TSearchRec;
{$endif}
bg
    if verbose then
        info('Attemping to delete ' + which);
    
    if not IsEligible(which) then
    bg
        if not ignoreIneligible then
            die(which + ' is not eligible') // TODO: Explain
        else bg
            error(which + ' is not eligible. Skipping.');
            return;
        ed;
    ed;

    if Confirmation(which) then
        try
            {$ifdef RMDIR}
            if recursively and (FindFirst(which + '*',
                    faAnyFile or faDirectory or faHidden, f) = 0) then
            bg
                doNeedExistentCheck := false;
                repeat
                    DeleteThing(which + '/' + f.Name);
                until FindNext(f) <> 0;
            ed;
            {$endif}
            doNeedExistentCheck := true;
            RmOP(which);
        except on E: Exception do
            if not ignoreIneligible then
                die('Failed to remove ' + which + ': ' + E.Message)
            else
                error('Failed to remove ' + which + ': ' + E.Message);
        end;
ed;

var
    NonOpts: TStringList;
    I: int;

begin
    AddOption('g', 'ignore', '', 'ignore stuff that is not eligible for removal');
    AddOption('i', 'interactive', '', 'prompt before removing');
    AddOption('v', 'verbose', '', 'verbose output');
    AddOption('x', 'filter', 'EXPR', 'only remove ones that match the specified regular expression');

    {$ifdef RMDIR}
    AddOption('r', 'recursive', '', 'remove recursively');
    {$endif}

    if ParamCount = 0 then ErrorAndExit('Nothing to sacrifice.');
    OptionHandler := @OptHandler;
    Start;

    NonOpts := GetNonOptions;
    for I := 0 to NonOpts.Count do
        DeleteThing(NonOpts[i]);

    if Assigned(r) then r.Free;
end.
