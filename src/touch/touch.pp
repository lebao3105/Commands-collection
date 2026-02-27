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
    cc.fs,
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
begin
    case found of
        'p': createParent := true;
        'v': beVerbose := true;
        'd': dirsOnly := true;
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

var
    currentPath: string;
    splits: array of ansistring;
    j, i: integer;

begin
    if (ParamCount = 0) then
        FatalAndTerminate(1, NOTHING_TO_CREATE);

    cc.custcustapp.OptionHandler := @OptionParser;
    cc.custcustapp.Start;

    for i := 0 to High(cc.custcustapp.NonOptions) do begin
        if createParent then
        begin
            splits := SplitString(cc.custcustapp.NonOptions[i], DirectorySeparator);

            for j := Low(splits) to High(splits) - 1 do
            begin
                currentPath := specialize TTypeHelper<string>.IfThenElse(
                    j > Low(splits), ConcatPaths([currentPath, splits[j]]), splits[j]
                ); // hmmmmm

                CreateFolder(currentPath);
            end;
        end;

        if dirsOnly then
            CreateFolder(cc.custcustapp.NonOptions[i])
        else
            CreateFile(cc.custcustapp.NonOptions[i]);
    end;
end.
