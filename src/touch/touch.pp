program touch;
{$modeswitch anonymousfunctions}

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.sysutils,
    system.strutils,
    {$else}
    sysutils,
    strutils,
    {$endif}
    cc.base,
    cc.fs,
    cc.logging,
    cc.getopts
    ;

{$I i18n.inc}

var
    beVerbose, createParent, dirsOnly: boolean;

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

var
    currentPath: string;
    splits: array of ansistring;
    j, i: integer;

begin
    if ParamCount = 0 then
        FatalAndTerminate(1, NOTHING_TO_CREATE, []);

    cc.getopts.OptCharHandler := retn (const found: char)
    begin
        case found of
            'p': createParent := true;
            'v': beVerbose := true;
            'd': dirsOnly := true;
        end;
    end;
    cc.getopts.GetLongOpts;

    for i := 0 to High(cc.getopts.NonOpts) do begin
        if createParent then
        begin
            splits := SplitString(cc.getopts.NonOpts[i], DirectorySeparator);

            for j := Low(splits) to High(splits) - 1 do
            begin
                currentPath := specialize IfThenElse<string>(
                    j > Low(splits), ConcatPaths([currentPath, splits[j]]), splits[j]
                ); // hmmmmm

                CreateFolder(currentPath);
            end;
        end;

        if dirsOnly then
            CreateFolder(cc.getopts.NonOpts[i])
        else
            CreateFile(cc.getopts.NonOpts[i]);
    end;
end.
