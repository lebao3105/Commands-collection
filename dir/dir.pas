program dir;
{$mode objfpc}{$h+}

uses
	logging, sysutils, custapp, classes;

type TDir = class(TCustomApplication)
protected
    procedure DoRun; override;

private
    showHidden: boolean;
    showAsList: boolean;
    procedure listitems(path: string);
    function getOptions: shortint;
end;

function TDir.getOptions: ShortInt;
begin
    if showHidden then
        Result := faAnyFile and faDirectory and not faHidden
        //                              intended^^^
    else
        Result := faAnyFile and faDirectory and faHidden;
end;

procedure TDir.listitems(path: string);
var
    filesCount: integer = 0;
    filesSize: integer = 0;
    f: TSearchRec;
    l: longint = 0;

begin
    path := ExpandFileName(IncludeTrailingPathDelimiter(path));

    writeln(path);

    if DirectoryExists(path) then
    begin
        if FindFirst(path + '*', getOptions, f) = 0 then
        begin
            repeat
                Inc(l);  
                with f do
                    if (Attr and faDirectory) = faDirectory then
                    begin
                        if showAsList then
                            writeln(Name:20, '<Dir>':15, '-':20)
                        else
                            write(Name + ' ');
                    end
                    else if (Attr and faSymLink) = faSymLink then begin
                        if showAsList then
                            writeln(Name:20, '<SymLink>':15, Size:20)
                        else
                            write(Name + ' ');
                        filesSize := filesSize + Size;
                    end
                    else begin
                        if showAsList then
                            writeln(Name:20, '':15, Size:20)
                        else
                            write(Name + ' ');
                        filesSize := filesSize + Size;
                        filesCount := filesCount + 1;
                    end;
            until FindNext(f) <> 0;

            FindClose(f);
            writeln;
            
            info('Found ' + IntToStr(l) + ' items in '+ path + ' directory: ' +
                            IntToStr(filesCount) + ' files, ' +
                            IntToStr(l - filesCount) + ' directories.' + #13);
            info(IntToStr(filesSize) + ' bytes of files.' + #13);
        end
        
        else
            error('Unable to open directory ' + path + '!');
    end
    else
        error(Format('Not a directory or does not exist: %s', [path]));
end;

procedure TDir.DoRun;
var
    args, dirs: TStringList;
    i: integer;
    errorMsg: string;

begin
    args := TStringList.Create;
    dirs := TStringList.Create;

    errorMsg := CheckOptions('hla', ['help', 'list', 'all'], args, dirs);
    if errorMsg <> '' then begin error(errorMsg); ExitCode := 1; end
    else begin
        if HasOption('h', 'help') then
        begin
            writeln(ParamStr(0), ' [options] [folders]');
            writeln('List items inside (a) directories.');
            writeln('--help / -h                : Show this and exit');
            writeln('--list / -l                : Show things as a list with their informations');
            writeln('--all / -a                 : Show everything, including hidden things');
            Terminate;
            Exit;
        end;

        showAsList := HasOption('l', 'list');
        showHidden := HasOption('a', 'all');

        if dirs.Count = 0 then
            listitems('./')
        else
            for i := 0 to dirs.Count - 1 do
                listitems(dirs[i]);
    end;

    args.Free;
    dirs.Free;
    Terminate;
end;

var
    DirApp: TDir;

begin
    DirApp := TDir.Create(nil);
    DirApp.StopOnException := true;
    DirApp.Run;
    DirApp.Free;
end.
