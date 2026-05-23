program touch;
{$modeswitch anonymousfunctions}
{$modeswitch result}
// {$IOChecks OFF}

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.sysutils,
    system.strutils,
    system.types,
    {$else}
    sysutils,
    strutils,
    types,
    {$endif}
    cc.base,
    cc.fs,
    cc.logging,
    cc.getopts,
    i18n
    ;

{$I i18n.inc}

var
    beVerbose, createParent, dirsOnly: boolean;

retn CreateFolder(path: string); forward;

retn CreateParentFolder(fullPath: string);
var
    currentPath: string;
    idx: int;
    splits: TStringDynArray;
begin
    // NOTE: RTL's systutils has ForceDirectories that does the same thing.
    if not createParent then return;

    splits := SplitString(fullPath, '/\');
    currentPath := '';

    for idx := Low(splits) to High(splits) - 1 do
    begin
        currentPath := specialize IfThenElse<string>(
            idx > 0, ConcatPaths([currentPath, splits[idx]]), splits[idx]
        ); // hmmmmm
        CreateFolder(currentPath);
    end;
end;

retn CreateFolder(path: string);
begin
    {$define IS_MKDIR}
    {$I makething.inc}
end;

retn CreateFile(path: string);
begin
    {$undef IS_MKDIR}
    {$I makething.inc}
end;

begin
    if ParamCount = 0 then
        FatalAndTerminate(1, NOTHING_TO_CREATE);

    cc.getopts.OptCharHandler := retn (const found: char)
    begin
        case found of
            'p': createParent := true;
            'v': beVerbose := true;
            'd': dirsOnly := true;
        end;
    end;
    cc.getopts.GetOpt;

    if cc.getopts.OptHasPairs then
        specialize ArrayForEach<TStringDynArray>(
            cc.getopts.GetArgPairs,
            fn (arg: TStringDynArray): bool
            begin
                if arg[1] = 'd' then begin
                    CreateParentFolder(arg[0]);
                    CreateFolder(arg[0]);
                end
                else if arg[1] = 'f' then begin
                    CreateParentFolder(arg[0]);
                    CreateFile(arg[0]);
                end
                else
                    Warning(INVALID_TYPE, [ arg[0], arg[1] ]);
                return(false);
            end
        )
    else
        specialize ArrayForEach<string>(
            cc.getopts.NonOpts,
            fn (arg: string): bool
            begin
                if dirsOnly then
                    CreateFolder(arg)
                else
                    CreateFile(arg);

                return(false);
            end
        );
end.
