// Unit to warn the user about something e.g missing file
unit warn;
Interface
function missing_num():integer;
function missing_argv():integer;
function missing_file():integer;
function help():integer;
Implementation
uses
    color, crt;

function missing_num():integer;
begin
    textred('Fatal: ');
    TextColor(White);
    writeln('You are missing number(s) to do this action. Exiting...');
end;
function missing_argv():integer;
begin
    textred('Fatal: ');
    TextColor(White);
    writeln('You are missing (an) argument(s) for the application. Exiting...');
end;
function missing_file():integer;
begin
    textred('Fatal: ');
    TextColor(White);
    writeln('The program needs (one) more file(s) to start. Exiting...');
end;
function help():integer;
begin
    writeln('You may want to use the help program or read the README.md file from the source code.');
    writeln('Link: https://github.com/lebao3105/Commands-collection');
end;
end.