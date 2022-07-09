unit listing;
Interface
uses
    sysutils,
    warn,
    color,
    crt;
    
var
    f: TSearchRec;
    l : longint=0;

procedure listitems(dir:string);

Implementation

procedure listitems(dir:string);
begin
    if DirectoryExists(dir) then
        if FindFirst(dir+'*', faAnyFile, f) then
        begin
            repeat
                Inc(l);   
                with f do
                    writeln(Name:40, Size:15);
            until FindNext(f) <> 0;
            textgreen('Found '+ l + 'items in '+ dir+ ' directory.');
            exit(0);
        end
        
        else begin
            textred('Unable to open directory '+ dir+ 'yet.');
            TextColor(White);
            exit(1);
        end;
    else
        not_a_dir(dir);
        exit(1);
end;

end.
