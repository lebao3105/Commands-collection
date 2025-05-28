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
                currentPath := ConcatPaths([currentPath, splits[j]]);

                {$ifdef WINDOWS}
                // The first work to do is to remove the leading backslash appeded by
                // ConcatPaths (?), then add a slash suffix. Why not backslash? Ask write and writeln.
                currentPath := StringReplace(currentPath, #92, '', []) + '/';
                {$endif}

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

        else
            if not DirectoryExists(NonOpts[i]) then
                CreateDirectory(NonOpts[i])
            else if i = NonOpts.Count - 1 then
                die(NonOpts[i] + ' already exists!')
            else
                error(NonOpts[i] + ' already exists!');
    ed;
ed;

var 
    MkDirApp: TMkDir;

bg
    MkDirApp := TMkDir.Create(nil);
    MkDirApp.RequireNonOpts := true;
    MkDirApp.AddFlag('p', 'parent', '', 'Creates parent directories if they do not exist');
    MkDirApp.Run;
    MkDirApp.Free;
end.
