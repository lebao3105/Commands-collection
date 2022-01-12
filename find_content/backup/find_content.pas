program find_content;
uses    
    Sysutils;
var 
    target_file: TextFile;
    file_ask: string;
    n, i: integer;
    content, target_content: string;
    yes_no:string;

label 
    ask, main;

begin
    if ParamCount = 0 then 
        begin
            writeln('At least 3 arguments needed. Aborting.');
            exit;
        end;
    if ParamCount = 1 then 
        begin 
            writeln('Missing argument. Aborting.'); 
            exit; 
        end;
    if ParamCount = 2 then 
        begin 
            writeln('Missing argument. Aborting.'); 
            exit; 
        end
    else  
    for n := 1 to ParamCount do
    (* Check for the --target flag *)
    if ParamStr(n) = '--target' then
        if (n + 1 = ParamCount) then
            begin 
                writeln('Missing the target file. Aborting.'); 
                exit; 
            end
            else begin (*1*)
                writeln('Note: Now the program will search for the text in ', ParamStr(n+1), ' are you sure this is the right file name?');
                writeln('find_content only can use the file after the --target flag.');
                write('Enter your answer here: [y /n] '); readln(yes_no);
            if yes_no = 'y' then 
                (* Read the file content like cat *)
            main: begin
                writeln('Reading file ', ParamStr(n+1));
                AssignFile(target_file, ParamStr(n+1));
                try // I still try to handle the error
                    reset(target_file);
                    // read the file content now
                    while not eof(target_file) do begin
                        readln(target_file, content);
                        for i := 1 to (n - 1) do // use i to avoid error
                        if Pos(ParamStr(i), content) <> 0 then begin
                            writeln(ParamStr(i), 
                                    ' found! The position is: ', 
                                    Pos(ParamStr(i), content));
                            exit;
                        end
                        else writeln('The target content', ParamStr(i),
                                    ' not found.');
                             exit;
                    end;
                    CloseFile(target_file);
                except
                    on E: EInOutError do begin
                        writeln('An error occurred, the details is: ', E.Message);
                        exit; end;
                    end;
        end;
    end; (*1*)
end.
