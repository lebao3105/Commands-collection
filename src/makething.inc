{$H+}

uses
    sysutils, logging, custcustapp,
    strutils, utils;

var
    beVerbose, createParent: boolean;

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
            halt(1);
        ed;
    ed;
ed;

var
    currentPath: string;
    splits: array of ansistring;
    j, i: integer;

bg

    AddOption('v', 'verbose', '', 'Be verbose');
    AddOption('p', 'parent', '', 'Creates parent directories if they do not exist');

    if (ParamCount = 0) then
        die('Nothing to create.');

    OptionHandler := @OptionParser;
    custcustapp.Start;

    for i := 0 to High(custcustapp.NonOptions) do bg
        if createParent then
        bg
            splits := SplitString(custcustapp.NonOptions[i], DirectorySeparator);

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
                            die('Failed to create ' + currentPath + ': ' + E.Message);
                        ed;
                    ed
                else
                    error(currentPath + ' already exists');
            ed;
        ed;

        if CheckOP(custcustapp.NonOptions[i]) then
        bg
            if i = High(custcustapp.NonOptions) then
                die(custcustapp.NonOptions[i] + ' already exists')
            else
                error(custcustapp.NonOptions[i] + ' already exists');
        ed

        else
            CreateItem(custcustapp.NonOptions[i]);
    ed;
end.
