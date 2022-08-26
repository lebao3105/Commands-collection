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
                    if (Attr and faDirectory) = faDirectory then
                        writeln(Name:20, '<Dir>':15, 'Uncountable':20) // don't use Size here
                    else if (Attr and faSymLink) = faSymLink then
                        writeln(Name:20, '<SymLink>':15, Size:20)
                    else
                        writeln(Name:20, '':15, Size:20);
                end;
            until FindNext(f) <> 0;
            FindClose(f);

            if dir = '.' then
            	directory := 'this'
            else
            	directory := dir;
            
            textgreenln('Found '+ IntToStr(l) + ' items in '+ directory+ ' directory.');
            TextColor(LightGray);
            writeln('Done!');
            halt(0);
        end
        
        else begin
            textred('Unable to open directory '+ dir+ '!');
            TextColor(LightGray);
            halt(1);
        end;
    end
    else
        not_a_dir(dir);
        halt(1);
end;

end.
