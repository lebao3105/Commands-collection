unit listing;
Interface

uses
    sysutils, logging, strutils;
    
var
    f: TSearchRec;
    l: longint=0;
    directory: string;

procedure listitems(path:string);

Implementation

procedure listitems(path:string);
begin
    {$ifdef win32}
    if StartsStr(path, '/') or StartsStr(path, '\') then
	    path := 'C:' + path;
    {$endif}

    // if the specified path is relative
    if StartsStr(path, '.\') or StartsStr(path, './') then
        path := ExtractFilePath(ParamStr(0)) + path + '/'
    else
        if (not EndsStr(path, '/')) or (not EndsStr(path, '\')) then
            path := path + '/';

    writeln(path);

    if DirectoryExists(path) then
    begin
        if FindFirst(path + '*', faAnyFile and faDirectory and (not faHidden), f) = 0 then
        begin
            repeat
                Inc(l);  
                with f do
                begin
                    if (Attr and faDirectory) = faDirectory then
                        writeln(Name:20, '<Dir>':15, '':20)
                    else if (Attr and faSymLink) = faSymLink then
                        writeln(Name:20, '<SymLink>':15, Size:20)
                    else
                        writeln(Name:20, '':15, Size:20);
                end;
            until FindNext(f) <> 0;
            FindClose(f);

            if path = '.' then
            	directory := 'this'
            else
            	directory := path;
            
            info('Found '+ IntToStr(l) + ' items in '+ directory+ ' directory.');
            writeln('Done!');
            halt(0);
        end
        
        else
            die('Unable to open directory ' + path + '!');
    end
    else
        die(Format('Not a directory: ', [path]));
end;

end.
