unit listing;
Interface
uses
    sysutils,
    warn, crt,
    color;
    
var
    f: TSearchRec;
    l: longint=0;
    directory: string;

procedure listitems(dir:string);

Implementation

procedure listitems(dir:string);
begin
    {$ifdef WINDOWS}
    if (dir = '/') or (dir = '\') then
	Insert('C:', dir, 1);
    //writeln(dir);
    {$endif}
    if DirectoryExists(dir) then
    begin
        if FindFirst(dir + '/*', faAnyFile and faDirectory and (not faHidden), f) = 0 then
        begin
            repeat
                Inc(l);  
                with f do
                begin
                    if Size = 0 then
                        writeln(Name:20, '<Dir>':15)
                    else
                        writeln(Name:20, Size:15);
                end;
            until FindNext(f) <> 0;
            FindClose(f);
            if dir = '.' then
            	directory := 'this'
            else
            	directory := dir;
            textgreenln('Found '+ IntToStr(l) + ' items in '+ directory+ ' directory.');
            TextColor(White);
            writeln('Done!');
            halt(0);
        end
        
        else begin
            textred('Unable to open directory '+ dir+ '!');
            TextColor(White);
            halt(1);
        end;
    end
    else
        not_a_dir(dir);
        halt(1);
end;

end.
