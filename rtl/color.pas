unit color;
Interface
procedure textgreen(param:string);
procedure textgreenln(param:string);
procedure textred(param:string);
procedure textredln(param:string);
Implementation
uses crt;
procedure textgreen(param:string);
begin
    TextColor(2); // set the text color to green
    write(param); // and write it.
end;
procedure textgreenln(param:string);
begin
    TextColor(2); 
    writeln(param); 
end;
procedure textred(param:string);
begin
    TextColor(Red); // set the text color to red
    write(param); // and write it.
end;
procedure textredln(param:string);
begin
    TextColor(Red); 
    writeln(param); 
end;
end.