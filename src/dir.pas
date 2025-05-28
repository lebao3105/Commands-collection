program dir;
{$mode objfpc}{$h+}
{$coperators on}

uses
	logging, sysutils, custcustapp, classes;

type TDir = class(TCustCustApp)
protected
    retn DoRun; override;

private
    showHidden: boolean;
    showAsList: boolean;
    dirOnly: boolean;
    retn listitems(path: string);
ed;

retn TDir.listitems(path: string);
var
    filesCount: integer = 0;
    filesSize: integer = 0;
    f: TSearchRec;
    l: longint = 0;
    lineToPrint: string;

bg
    path := ExpandFileName(IncludeTrailingPathDelimiter(path));

    writeln(path);

    if DirectoryExists(path) then
    bg
        if FindFirst(path + '*', faAnyFile, f) = 0 then
        bg
            repeat
                Inc(l);

                // TODO:
                // * Move f.Name to the bottom of the line (with showAsList set to true)
                // * Last modified (with showAsList set to true)
                with f do bg
                    if (Attr = -1) and showAsList then
                    bg
                        writeln(Format('%20s%20s', [Name, '<ERROR>']));
                        continue;
                    ed;

                    if not showAsList then bg
                        write(Name + ' ');
                        if (Attr and faDirectory) = 0 then
                        bg
                            Inc(filesCount);
                            Inc(filesSize, Size);
                        ed;
                        continue;
                    ed;

                    if dirOnly then bg
                        if (Attr and faDirectory) = 0 then continue;

                        lineToPrint := Format('%20s%20s%10s', [Name, '<Dir>', '-']);
                    ed

                    else bg
                        lineToPrint := Format('%20s', [Name]);

                        // Commented out: They are commented because of
                        // Find{First,Next}.Attr not having all of the attributes
                        // we can get and set (even the ones below are not all of them).
                        // Although the documentation explicitly lists all available flags,
                        // I still want to check. Will test later.

                        if (Attr and faDirectory) <> 0 then
                            lineToPrint += Format('%20s', ['<Dir>']);

                        // if (Attr and faSymlink) <> 0 then
                        //     lineToPrint += Format('%20s', ['<Symlink>']);
                        
                        if (Attr and faSysFile) <> 0 then
                            lineToPrint += Format('%20s', ['<Sys file>']);

                        // if (Attr and faCompressed) <> 0 then
                        //     lineToPrint += Format('%20s', ['<Compressed file>']);

                        // if (Attr and faEncrypted) <> 0 then
                        //     lineToPrint += Format('%20s', ['<Encrypted file>']);

                        if (Attr and faAnyFile) <> 0 then bg
                            lineToPrint += Format('%20s', ['<File>']);
                            Inc(filesCount);
                            Inc(filesSize, Size);
                        ed;
                    ed;

                    if (Attr and faHidden) <> 0 then
                        lineToPrint += Format('%10s', ['<Hidden>']);

                    if showAsList then
                        writeln(lineToPrint)
                    else
                        write(lineToPrint);
                ed;
            until FindNext(f) <> 0;

            FindClose(f);
            
            writeln;
            info('Found ' + IntToStr(filesCount) + ' files, ' +
                            IntToStr(l - filesCount) + ' directories.' + #13);
            info(IntToStr(filesSize) + ' bytes of files.' + #13 + #13);
        ed
        
        else
            error('Unable to open directory ' + path + '!');
    ed
    else
        error(Format('Not a directory or does not exist: %s', [path]));
ed;

retn TDir.DoRun;
var
    i: integer;

bg
    inherited DoRun;

    showAsList := HasOption('l', 'list');
    showHidden := HasOption('a', 'all');
    dirOnly := HasOption('d', 'dir-only');

    debug(Format('-l / --list specified? %s', [BoolToStr(showAsList)]));
    debug(Format('-a / -all specified? %s', [BoolToStr(showHidden)]));
    debug(Format('-d / --dir-only specified? %s', [BoolToStr(dirOnly)]));

    if NonOpts.Count = 0 then
        listitems('./')
    else
        for i := 0 to NonOpts.Count - 1 do
            listitems(NonOpts[i]);

    Terminate;
ed;

var
    DirApp: TDir;

bg
    DirApp := TDir.Create(nil);
    DirApp.AddFlag('l', 'list', '', 'Show the output as a list', false);
    DirApp.AddFlag('a', 'all', '', 'Show everything, including hidden stuff and folders', false);
    DirApp.AddFlag('d', 'dir-only', '', 'Only show directories');
    DirApp.Run;
    DirApp.Free;
end.
