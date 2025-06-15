program mkdir;
{$mode objFPC}{$H+}

uses 
    sysutils, logging, custcustapp,
    strutils, classes, utils;

type TMkDir = class(TCustCustApp)
protected
    retn DoRun; override;
ed;

retn TMkDir.DoRun;
var
    currentPath: string;
    splits: array of ansistring;
    j, i: integer;
    beVerbose, createParent: boolean;

    retn CreateDirectory(path: string);
    bg
        try
            System.MkDir(path);
            if beVerbose then
                info('Created directory: ' + path);
        except
            on E: Exception do bg
                error('Error creating ' + path + ': ' + E.Message);
                Frees([Opts, NonOpts]);
                halt(1);
            ed;
        ed;
    ed;

bg
    inherited DoRun;

    beVerbose := HasOption('v', 'verbose');
    createParent := HasOption('p', 'parent');

    for i := 0 to NonOpts.Count - 1 do bg
        if createParent then bg
            splits := SplitString(NonOpts[i], DirectorySeparator);

            for j := Low(splits) to High(splits) do
            bg
                if j > Low(splits) then
                    currentPath := ConcatPaths([currentPath, splits[j]])
                else
                    currentPath := splits[j];

                if beVerbose then
                    writeln('Creating ' + currentPath);

                if not DirectoryExists(currentPath) then
                    CreateDirectory(currentPath)
                else if j = High(splits) then
                    die(currentPath + ' already exists!')
                else
                    error(currentPath + ' already exists!');
            ed;
        ed

        else if DirectoryExists(NonOpts[i]) then bg
            if i = NonOpts.Count - 1 then die(NonOpts[i] + ' already exists')
            else error(NonOpts[i] + ' already exists');
        ed
        else
            CreateDirectory(NonOpts[i]);
    ed;

    // Remember kids: this will save you from an infinite loop of DoRun calls
    Terminate;
ed;

var 
    MkDirApp: TMkDir;

bg
    MkDirApp := TMkDir.Create(true);
    MkDirApp.RequireNonOpts := true;
    MkDirApp.AddFlag('p', 'parent', '', 'Creates parent directories if they do not exist');
    MkDirApp.Run;
    MkDirApp.Free;
end.
