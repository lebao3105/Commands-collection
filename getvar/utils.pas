unit utils;
Interface
procedure textgreen(param:string);
procedure textgreenln(param:string);
procedure textred(param:string);
procedure textredln(param:string);
function GetOSEnv(variable:string):string;
Implementation
uses crt, Dos,
    {$IFDEF Unix} BaseUnix {$ENDIF};

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
//get OS variables
function GetOSEnv(variable:string):string;
begin
   {$IFDEF WINDOWS}
   writeln(GetEnv(variable));
   {$ELSE}
   writeln(fpGetEnv(variable));
   {$ENDIF}
end;
end.
