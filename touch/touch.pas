program touch;

uses 
    {warn,} crt, {color,} 
    sysutils, strutils;

var 
    i : integer;
    ask : string;
    is_alone : boolean;

procedure check_ask(val,i:string);
begin
    if AnsiMatchStr(val, [i]) then 
        is_alone := true
    else if AnsiMatchStr(val, ['all']) then
        is_alone := false
end;

procedure done(arg:string); // use arg variable for is_alone = true
begin
    if is_alone = true then
        writeln('File ', arg, ' has been created.')
    else    
        writeln('All your required file has been created.');
end;

begin
    //if ParamCount = 0 then missing_file()
    {else} if ParamCount > 1 then
    begin
        writeln('There are many arguments that we are detected here. Which one you want to create?');
        writeln('Note that --help flag is not available for this application.');
        for i := 1 to ParamCount do begin  
            writeln('Arg no.', i , ' : ', ParamStr(i));
        end;
        //textgreen('Enter your answer here (all to use all): ');
        write('Enter your answer here (all to use all args): ');
        TextColor(White);
        read(ask);
        for i := 1 to ParamCount do begin// we use this loop only when we need it
            check_ask(ask, IntToStr(i)); // to avoid other crazy loops
        end;
        if is_alone = true then begin
                FileCreate(ParamStr(StrToInt(ask))); 
        end 
        else for i := 1 to ParamCount do begin
                FileCreate(ParamStr(i));
        end;
        // check for is_alone again:)
        if is_alone = true then 
            done(ParamStr(StrToInt(ask)))
        else 
            done('');
    end
    else if ParamCount = 1 then begin
            FileCreate(ParamStr(1));
            writeln('File ', ParamStr(1), ' has been created.');
    end;
end.