program presskey;
// Pascal version of Windows's pause.
// Helpful on UNIX OSes.
uses
    crt, warn, color;

var
    i : integer;

// These functions are the same work, they still have some differents
procedure defaultfn;
begin
    writeln('Press any key to continue...');
    repeat
    until (KeyPressed);
end;

procedure print_message(message:string);
begin
    writeln(message);
    repeat
    until (KeyPressed);
end;

begin
    if ParamCount = 0 then defaultfn
    else begin
        for i := 1 to ParamCount do begin
            if (ParamStr(i) = '--custom-message') or (ParamStr(i) = '-c') then
            begin
                if ParamStr(i+1) = '' then
                    missing_argv
                else
                    print_message(ParamStr(i+1));
                    defaultfn;
            end

            else if (ParamStr(i) = '--error') or (ParamStr(i) = '-e') then
            begin
                if ParamStr(i+1) = '' then
                    missing_argv
                else
                    TextColor(Red);
                    print_message(ParamStr(i+1));
                    TextColor(LightGray);
                    defaultfn;
            end;

            if (ParamStr(i) = '--help') or (ParamStr(i) = '-h') then
            begin
                writeln('presskey');
                writeln('This program suspends the current running program (the developer needs to call this program in their code), then print a message.');
                writeln('More message(s) can be used with --custom-message/-c parameter. Also we can show an error with --error/-e.');
                writeln('Finally, of course, use --help/-h to show this message again:-)');
                writeln('This is a demostration with no other parameters passed:');
                defaultfn;
            end;

        end;
    end;
end.