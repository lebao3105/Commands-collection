program mkdir;
{$mode objFPC}{$H+}

uses 
    sysutils, logging, custcustapp,
    strutils, classes, utils;

type TMkDir = class(TCustCustApp)
protected
    procedure DoRun; override;
end;

procedure TMkDir.DoRun;
var
    currentPath: string;
    splits: array of ansistring;
    j, i: integer;
    beVerbose, createParent: boolean;

    procedure CreateDirectory(path: string);
    begin
        try
            System.MkDir(path);
            if beVerbose then
                info('Created directory: ' + path);
        except
            on E: Exception do begin
                error('Error creating ' + path + ': ' + E.Message);
                Frees([Opts, NonOpts]);
                halt(1);
            end;
        end;
    end;

begin
    inherited DoRun;

    beVerbose := HasOption('v', 'verbose');
    createParent := HasOption('p', 'parent');

    for i := 0 to NonOpts.Count - 1 do begin
        if createParent then begin
            splits := SplitString(NonOpts[i], DirectorySeparator);

            for j := Low(splits) to High(splits) do
            begin
                currentPath := ConcatPaths([currentPath, splits[j]]);

                {$ifdef WINDOWS}
                // The first work to do is to remove the leading backslash appended by
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
            end;
        end

        else
            if not DirectoryExists(NonOpts[i]) then
                CreateDirectory(NonOpts[i])
            else if i = NonOpts.Count - 1 then
                die(NonOpts[i] + ' already exists!')
            else
                error(NonOpts[i] + ' already exists!');
    end;
end;

var 
    MkDirApp: TMkDir;

begin
    MkDirApp := TMkDir.Create(nil);
    MkDirApp.RequireNonOpts := true;
    MkDirApp.AddFlag('p', 'parent', '', 'Creates parent directories if they do not exist');
    MkDirApp.Run;
    MkDirApp.Free;
end.
