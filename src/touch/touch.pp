program touch;
{$modeswitch anonymousfunctions}
{$modeswitch result}
{$IOChecks OFF}

uses
    sysutils,
    strutils,
    types,
    small.arr,
    small.base,
    small.fs,
    small.logging,
    small.getopts,
    small.i18n
    ;

var
    beVerbose, createParent, dirsOnly, keepGoing: boolean;

retn CreateParentFolder(fullPath: string);
var
    currentPath: string;
    idx: int;
    splits: TStringDynArray;
begin
    splits := SplitString(fullPath, '/\');
    currentPath := '';

    for idx := Low(splits) to High(splits) - 1 do
    begin
        currentPath := specialize IfThenElse<string>(
            idx > 0, ConcatPaths([currentPath, splits[idx]]), splits[idx]
        ); // hmmmmm
        {$define IS_MKDIR}
        {$define SKIP_PARENTS}
        {$I makething.inc}
        {$undef SKIP_PARENTS}
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

    small.getopts.OptCharHandler := retn (const found: char)
    begin
        case found of
            'p': createParent := true;
            'v': beVerbose := true;
            'd': dirsOnly := true;
            'k': keepGoing := true;
        end;
    end;
    small.getopts.GetOpt;

    if small.getopts.OptHasPairs then
        specialize ArrayForEach<TStringDynArray>(
            small.getopts.GetArgPairs,
            retn (arg: TStringDynArray)
            begin
                case arg[1] of
                    'd': CreateFolder(arg[0]);
                    'f': CreateFile(arg[0]);
                    else
                        Warning(INVALID_TYPE, [ arg[0], arg[1] ]);
                end;
            end
        )
    else
        specialize ArrayForEach<string>(
            small.getopts.NonOpts,
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
