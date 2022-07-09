// Unit to warn the user about something e.g missing file
unit warn;
Interface
procedure missing_num();
procedure missing_argv();
procedure missing_file();
procedure help_prog();
procedure missing_dir();
procedure not_a_dir(dir:string);
Implementation
uses
    color, crt;

procedure missing_num();
begin
    textred('Fatal: ');
    TextColor(White);
    writeln('You are missing number(s) to do this action. Exitting...');
    delay(800);
end;
procedure missing_argv();
begin
    textred('Error: ');
    TextColor(White);
    writeln('You are missing (an) argument(s) for the application. Exitting...');
    delay(800);
end;
procedure missing_file();
begin
    textred('Fatal: ');
    TextColor(White);
    writeln('The program needs (one) more file(s) to start. Exitting...');
    delay(800);
end;
procedure help_prog();
begin
    writeln('You may want to use the help program or read the README.md file from the source code.');
    writeln('Link: https://github.com/lebao3105/Commands-collection');
    writeln('Exitting...');
    delay(800);
end;
procedure missing_dir();
begin
    textred('Fatal: ');
    TextColor(White);
    writeln('Missing directory(_ies) for the program. Exitting...');
    delay(800);
end;
procedure not_a_dir(dir:string);
begin
    textred('Error occured: ');
    TextColor(White);
    writeln('Target item ', dir, ' is not exist, or is not a directory yet.');
    writeln('Check your input and try again.');
    delay(800);
end;
end.
