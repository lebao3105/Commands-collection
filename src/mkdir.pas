program mkdir;
{$mode objFPC}{$H+}

uses 
    sysutils, logging, custapp, strutils, classes, utils;

type TMkDir = class(TCustomApplication)
protected
    procedure DoRun; override;
end;

procedure TMkDir.DoRun;
var
    errorMsg, currentPath: string;
    args, dirs: TStringList;
    splits: array of ansistring;
    j, i: integer;
    beVerbose, createParent: boolean;

begin
    args := TStringList.Create();
    dirs := TStringList.Create();

    errorMsg := CheckOptions('hvp', ['help', 'verbose', 'parent'], args, dirs);

    if HasOption('h', 'help') or (dirs.Count = 0) or (errorMsg <> '') then
    begin
        writeln(ParamStr(0), ' [flag] <directories>');
        writeln('Create directories. Use your system''s directory separator!');
        writeln('Use --help/-h flag to show this message (again).');
        writeln('-p / --parent creates the parent directories if they do not exist.');
        writeln('-v / --verbose to be verbose.');

        Frees([args, dirs]);
        
		if errorMsg <> '' then
			die(errorMsg)
		else
			halt(0);
    end;

    beVerbose := HasOption('v', 'verbose');
    createParent := HasOption('p', 'parent');

    for i := 0 to dirs.Count - 1 do begin
        if createParent then begin
            splits := SplitString(dirs[i], DirectorySeparator);

            for j := Low(splits) to High(splits) do
            begin
                currentPath := currentPath + DirectorySeparator + splits[j];
                writeln(currentPath);
                if not DirectoryExists(currentPath) then
                begin
                    try
                        System.MkDir(currentPath);
                        if beVerbose then
                            info('Created directory: ' + currentPath);
                    except
                        on E: Exception do begin
                            error('Error creating directory: ' + currentPath + ': ' + E.Message);
                            Frees([args, dirs]);
                            halt(1);
                        end;
                    end;
                end
                else if j = High(splits) then
                    die(currentPath + ' already exists!');
            end;
        end

        else if not DirectoryExists(dirs[i]) then begin
            try
                System.MkDir(dirs[i]);
                if beVerbose then
                    info('Created directory: ' + dirs[i]);
            except
                on E: Exception do begin
                    error('Error creating directory: ' + dirs[i] + ': ' + E.Message);
                    Frees([args, dirs]);
                    halt(1);
                end;
            end;
        end else
            die(dirs[i] + ' already exists!');
    end;

    Frees([args, dirs]);
    Terminate;
end;

var 
    MkDirApp: TMkDir;

begin
    MkDirApp := TMkDir.Create(nil);
    MkDirApp.StopOnException := true;
    MkDirApp.Run;
    MkDirApp.Free;
end.
