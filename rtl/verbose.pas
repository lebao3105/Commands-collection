unit verbose;
// print verbose message
interface
    
procedure cat_prog(s, file_name:string);

implementation

procedure cat_prog(s, file_name:string);
begin
    if s = 'begin' then
        writeln('cat is going to read the contents of file: ', file_name);
  		writeln('=========================================');
    if s = 'end' then
        writeln('cat has read the contents of file: ', file_name);
        writeln('Press Enter to exit the program.');
end;    
end.