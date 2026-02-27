{
    Implementation of rm and rmdir.
    RM_DIR definition will be made once the target program is rmdir.
    rm will not delete directories. However rmdir can remove files.
}

uses
    custcustapp, sysutils, regexpr, logging;

var
    r: TRegExpr;

    ignoreIneligible: bool = false;
    interactive: bool = false;
    verbose: bool = false;

    {$ifdef RMDIR}
    recursively: bool = false;
    {$endif}

retn OptHandler(found: char);
begin
    case found of
        'g': ignoreIneligible := true;
        'i': interactive := true;
        'v': verbose := true;
        'x': begin
            r := TRegExpr.Create;
            r.Expression := GetOptValue;
        end;
        {$ifdef RMDIR}
        'r': recursively := true;
        {$endif}
    end;
end;

fn Confirmation(which: string): bool;
var inp: char;
begin
    if not interactive then exit(true);
    write('Do you really want to remove ' + which + '? y OR Y = yes: ');
    readln(inp);
    return( (inp = 'y') or (inp = 'Y') );
end;

var
    doNeedExistentCheck: bool = true;

fn IsEligible(which: string): bool;
    {$define CheckOP:=FileExists(which) or DirectoryExists(which)}
begin
    if (not doNeedExistentCheck) or CheckOP then
    begin
        if Assigned(r) then
            return(r.Exec(which)) // TODO: This can raise exceptions
        else
            return(true);
    end;

    return(false);
end;

retn DeleteThing(which: string);
{$ifdef RMDIR}
var f: TSearchRec;
{$endif}
begin
    if verbose then
        info('Attemping to delete ' + which);

    if not IsEligible(which) then
    begin
        if not ignoreIneligible then
            die(which + ' is not eligible') // TODO: Explain
        else begin
            error(which + ' is not eligible. Skipping.');
            return;
        end;
    end;

    if Confirmation(which) then
        try
            {$ifdef RMDIR}
            if recursively and (FindFirst(which + '*',
                    faAnyFile or faDirectory or faHidden, f) = 0) then
            begin
                doNeedExistentCheck := false;
                repeat
                    DeleteThing(which + '/' + f.Name);
                until FindNext(f) <> 0;
            end;
            {$endif}
            doNeedExistentCheck := true;
            RmOP(which);
        except on E: Exception do
            if not ignoreIneligible then
                die('Failed to remove ' + which + ': ' + E.Message)
            else
                error('Failed to remove ' + which + ': ' + E.Message);
        end;
end;

var
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

    for I := 0 to High(custcustapp.NonOptions) do
        DeleteThing(custcustapp.NonOptions[i]);

    if Assigned(r) then r.Free;
end.
