// Unit to warn the user about something e.g missing file
unit warn;
Interface
function missing_num():integer;
function missing_argv():integer;
function missing_file():integer;
function help_prog():integer;
function missing_dir():integer;
Implementation
uses
    color, crt;

function missing_num():integer;
begin
    textred('Fatal: ');
    TextColor(White);
    writeln('You are missing number(s) to do this action. Exitting...');
    delay(800);
end;
function missing_argv():integer;
begin
    textred('Fatal: ');
    TextColor(White);
    writeln('You are missing (an) argument(s) for the application. Exitting...');
    delay(800);
end;
function missing_file():integer;
begin
    textred('Fatal: ');
    TextColor(White);
    writeln('The program needs (one) more file(s) to start. Exitting...');
    delay(800);
end;
function help_prog():integer;
begin
    writeln('You may want to use the help program or read the README.md file from the source code.');
    writeln('Link: https://github.com/lebao3105/Commands-collection');
    writeln('Exitting...');
    delay(800);
end;
function missing_dir():integer;
begin
    textred('Fatal: ');
    TextColor(White);
    writeln('Missing directory(_ies) for the program. Exitting...');
    delay(800);
end;
end.