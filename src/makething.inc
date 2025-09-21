{$H+}

uses
    sysutils, logging, custcustapp,
    strutils, classes, utils;

var
    beVerbose, createParent: boolean;
    NonOpts: TStringList;

retn OptionParser(found: char);
bg
    case found of
        'p': createParent := true;
        'v': beVerbose := true;
    ed;
ed;

retn CreateItem(path: string);
bg
    try
        CreateOP(path);
        if beVerbose then
            info('Created ' + path);
    except
        on E: Exception do bg
            error('Failed to create ' + path + ': ' + E.Message);
            NonOpts.Free;
            halt(1);
        ed;
    ed;
ed;

var
    currentPath: string;
    splits: array of ansistring;
    j, i: integer;

bg
    OptionHandler := @OptionParser;

    AddOption('v', 'verbose', '', 'Be verbose');
    AddOption('p', 'parent', '', 'Creates parent directories if they do not exist');

    custcustapp.Start;

    NonOpts := GetNonOptions;

    if (NonOpts.Count = 0) then
        die('Nothing to create.');

    for i := 0 to NonOpts.Count - 1 do bg
        if createParent then
        bg
            splits := SplitString(NonOpts[i], DirectorySeparator);

            for j := Low(splits) to High(splits) - 1 do
            bg
                if j > Low(splits) then
                    currentPath := ConcatPaths([currentPath, splits[j]])
                else
                    currentPath := splits[j]; // hmm...

                if beVerbose then
                    info('Creating ' + currentPath);

                if not DirectoryExists(currentPath)
                then
                    try
                        System.MkDir(currentPath);
                        if beVerbose then
                            info('Created ' + currentPath);
                    except
                        on E: Exception do bg
                            error('Failed to create ' + currentPath + ': ' + E.Message);
                            NonOpts.Free;
                            halt(1);
                        ed;
                    ed
                else
                    error(currentPath + ' already exists');
            ed;
        ed;

        if CheckOP(NonOpts[i]) then
        bg
            if i = NonOpts.Count - 1 then
                die(NonOpts[i] + ' already exists')
            else
                error(NonOpts[i] + ' already exists');
        ed

        else
            CreateItem(NonOpts[i]);
    ed;
end.
