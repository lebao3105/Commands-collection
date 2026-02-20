program touch;

uses
    {$ifdef FPC_DOTTEDUNITS}
    system.sysutils,
    system.strutils,
    {$else}
    sysutils,
    strutils,
    {$endif}
    cc.base,
    cc.utils,
    cc.logging,
    cc.custcustapp
    ;

resourcestring
    NOTHING_TO_CREATE        = 'Nothing to create.';
    CREATING_STUFF           = 'Creating %s...';
    CREATED_STUFF            = 'Created %s.';
    FAILED_TO_CREATE         = 'Failed to create %s: %s';
    ALREADY_EXISTS           = '%s already exists';

var
    beVerbose, createParent, dirsOnly: boolean;

retn OptionParser(found: char);
bg
    case found of
        'p': createParent := true;
        'v': beVerbose := true;
        'd': dirsOnly := true;
    ed;
ed;

retn CreateFolder(path: string);
bg
    {$define IS_MKDIR}
    {$I makething.inc}
ed;

retn CreateFile(path: string);
bg
    {$undef IS_MKDIR}
    {$I makething.inc}
ed;

var
    currentPath: string;
    splits: array of ansistring;
    j, i: integer;

bg
    if (ParamCount = 0) then
        FatalAndTerminate(1, gettext(@NOTHING_TO_CREATE));

    cc.custcustapp.OptionHandler := @OptionParser;
    cc.custcustapp.Start;

    for i := 0 to High(cc.custcustapp.NonOptions) do bg
        if createParent then
        bg
            splits := SplitString(cc.custcustapp.NonOptions[i], DirectorySeparator);

            for j := Low(splits) to High(splits) - 1 do
            bg
                currentPath := specialize TTypeHelper<string>.IfThenElse(
                    j > Low(splits), ConcatPaths([currentPath, splits[j]]), splits[j]
                ); // hmmmmm

                CreateFolder(currentPath);
            ed;
        ed;

        if dirsOnly then
            CreateFolder(cc.custcustapp.NonOptions[i])
        else
            CreateFile(cc.custcustapp.NonOptions[i]);
    ed;
end.
